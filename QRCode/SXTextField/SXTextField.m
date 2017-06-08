//
//  SXTextField.m
//  QRCode
//
//  Created by Shown on 2017/6/7.
//  Copyright © 2017年 xiaoR. All rights reserved.
//

#import "SXTextField.h"
#import "Model.h"

@implementation SXTextField


- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
}


#pragma mark ------------监听键盘快捷键
- (BOOL)performKeyEquivalent:(NSEvent *)theEvent {
    NSString  *characters = [theEvent charactersIgnoringModifiers];
    if ([characters isEqual:@"["]) {
        self.stringValue = [Model lastString];
        if (_sureBlock) {
            _sureBlock();
        }
        return YES;
    }
    if ([characters isEqual:@"]"]) {
        self.stringValue = [Model nextString];
        if (_sureBlock) {
            _sureBlock();
            }
        return YES;
    }
    return NO;
}

#pragma mark ------------textField的代理
- (void)textViewDidChangeSelection:(NSNotification *)notification {
    if (_valueChangeBlock) {
        _valueChangeBlock();
    }
}


- (BOOL)textView:(NSTextView *)aTextView doCommandBySelector:(SEL)aSelector{
    //NSLog(@"%@",NSStringFromSelector(aSelector));
    //回车键
    if (aSelector == @selector(insertNewline:)) {
        //Do something against ENTER key
//        NSLog(@"------------------------>return");
        if (_sureBlock) {
            _sureBlock();
        }
        [Model insertString:self.stringValue];
        //这里是按下回车后的具体处理
        return YES;
        
    } else if (aSelector == @selector(deleteForward:)) {
        //Do something against DELETE key
        
    } else if (aSelector == @selector(deleteBackward:)) {
        //Do something against BACKSPACE key
        
    } else if (aSelector == @selector(insertTab:)) {
        //Do something against TAB key
    }
    return NO;
}

@end
