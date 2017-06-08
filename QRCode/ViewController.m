//
//  ViewController.m
//  QRCode
//
//  Created by Shown on 2017/6/7.
//  Copyright © 2017年 xiaoR. All rights reserved.
//

#import "ViewController.h"
#import "SXTextField.h"
#import <AVFoundation/AVFoundation.h>
#import "Model.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [NSApplication sharedApplication] set
    self.title = @"二维码生产器";
    
    __weak ViewController *weakBlock = self;
    _textField.sureBlock = ^{
        [weakBlock sureAction:nil];
    };
    
    _textField.valueChangeBlock = ^{
        _label.stringValue = [NSString stringWithFormat:@"一共输入了 %ld 个字符", _textField.stringValue.length];
    };
    _textField.stringValue = @"hello";
    if ([Model firstString]) {
        _textField.stringValue = [Model firstString];
    }
}

- (IBAction)sureAction:(id)sender {
    CGImageRef image = [self qrImageForString:_textField.stringValue imageSize:150.f logoImageSize:0];
    [_qrImage setImage:[self imageFromCGImageRef:image]];
    
}
- (IBAction)historyAction:(id)sender {
    [Model deldtrAllHistoryString];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (BOOL)textField:(NSTextField *)textField textView:(NSTextView *)textView shouldSelectCandidateAtIndex:(NSUInteger)index {
    CGImageRef image = [self qrImageForString:_textField.stringValue imageSize:150.f logoImageSize:0];
    [_qrImage setImage:[self imageFromCGImageRef:image]];
    return NO;
}

#pragma mark ----------------生成二维码

- (CGImageRef)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    return [self createNonInterpolatedNSImageFormCIImage:outPutImage withSize:Imagesize waterImageSize:waterImagesize];
}

- (CGImageRef)createNonInterpolatedNSImageFormCIImage:(CIImage *)image withSize:(CGFloat) size waterImageSize:(CGFloat)waterImagesize{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
//    //原图
//    CIImage *outputImage = [CIImage imageWithCGImage:scaledImage];
//    //给二维码加 logo 图
//    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
//    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
//    //logo图
//    CIImage *waterimage = [CIImage imageNamed:@"icon_imgApp"];
//    //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
//    [waterimage drawInRect:CGRectMake((size-waterImagesize)/2.0, (size-waterImagesize)/2.0, waterImagesize, waterImagesize)];
//    CIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    return scaledImage;
}

- (NSImage*) imageFromCGImageRef:(CGImageRef)image {
    NSRect imageRect = NSMakeRect(0.0, 0.0, 0.0, 0.0);
    CGContextRef imageContext = nil;
    NSImage* newImage = nil;
   
    // Get the image dimensions.
    imageRect.size.height = CGImageGetHeight(image);
    imageRect.size.width = CGImageGetWidth(image);
    // Create a new image to receive the Quartz image data.
    newImage = [[NSImage alloc] initWithSize:imageRect.size];
    [newImage lockFocus];
    
    
    // Get the Quartz context and draw.
    imageContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextDrawImage(imageContext, *(CGRect*)&imageRect, image);
    [newImage unlockFocus];
    
    return newImage;
    
}

@end
