//
//  Model.m
//  QRCode
//
//  Created by Shown on 2017/6/8.
//  Copyright © 2017年 xiaoR. All rights reserved.
//

#import "Model.h"

#define historyArrUserKey @"HistoryArrUserKey"

static NSMutableArray *stringArr = nil;
static NSInteger indexArr = 0;

@implementation Model

+ (void)load {
    stringArr = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:historyArrUserKey];
    [stringArr addObjectsFromArray:arr];
}

+ (void)setIndex:(NSInteger)index {
    indexArr = index;
}

+ (NSArray *)allHistoryString {
    return stringArr;
}

+ (void)deldtrAllHistoryString {
    NSString *str = [stringArr firstObject];
    [stringArr removeAllObjects];
    [stringArr addObject:str];
    
    [[NSUserDefaults standardUserDefaults] setValue:stringArr forKey:historyArrUserKey];
}

+ (NSString *)firstString {
    if (!stringArr.count) {
        return nil;
    }
    indexArr = 0;
    return [stringArr firstObject];
}

+ (NSString *)lastString {
    if (indexArr < stringArr.count -1) {
        indexArr ++;
    }
    NSLog(@"index------>%ld", indexArr);
    return stringArr[indexArr];
}
+ (NSString *)nextString {
    if (indexArr >= 1) {
        indexArr --;
    }
    NSLog(@"index------>%ld", indexArr);
    return stringArr[indexArr];
}

+ (void)insertString:(NSString *)string {
    if ([stringArr containsObject:string]) {
        [stringArr removeObject:string];
    }
    [stringArr insertObject:string atIndex:0];
    [[NSUserDefaults standardUserDefaults] setValue:stringArr forKey:historyArrUserKey];
}

@end
