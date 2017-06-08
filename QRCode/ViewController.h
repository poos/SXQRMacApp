//
//  ViewController.h
//  QRCode
//
//  Created by Shown on 2017/6/7.
//  Copyright © 2017年 xiaoR. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SXTextField.h"


@interface ViewController : NSViewController <NSTextFieldDelegate>

@property (weak) IBOutlet SXTextField *textField;
@property (weak) IBOutlet NSButton *qrImage;
@property (weak) IBOutlet NSTextField *label;

@end

