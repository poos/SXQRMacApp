//
//  SXTextField.h
//  QRCode
//
//  Created by Shown on 2017/6/7.
//  Copyright © 2017年 xiaoR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SXTextField : NSTextField

@property (copy) void(^sureBlock)(void);
@property (copy) void(^valueChangeBlock)(void);

@end
