//
//  Model.h
//  QRCode
//
//  Created by Shown on 2017/6/8.
//  Copyright © 2017年 xiaoR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

+ (void)setIndex:(NSInteger)index;
+ (NSArray<NSString *> *)allHistoryString;
+ (void)deldtrAllHistoryString;

+ (NSString *)firstString;

+ (NSString *)lastString;
+ (NSString *)nextString;

+ (void)insertString:(NSString *)string;


@end
