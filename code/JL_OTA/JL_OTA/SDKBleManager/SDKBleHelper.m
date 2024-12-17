//
//  SDKBleHelper.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/12.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "SDKBleHelper.h"
#import "FittingView.h"
#import <JL_BLEKit/JL_BLEKit.h>

@implementation SDKBleHelper

+(NSMutableArray <JL_EntityM *>*)fitterHandle:(NSArray*)basicArray{
    NSMutableArray *localArray = [NSMutableArray new];
    NSString *key = [[FittingView getFitterKey] uppercaseString];
    for (JL_EntityM *entity in basicArray) {
        if ([key isEqualToString:@""]) {
            [localArray addObject:entity];
        }else{
            if ([[entity.mItem uppercaseString] rangeOfString:key].location == NSNotFound || !entity.mItem) {
                //
                kJLLog(JLLOG_DEBUG, @"过滤 ----> NAME:%@ RSSI:%@", entity.mItem,entity.mRSSI);
            }else{
                [localArray addObject:entity];
            }
        }
    }
    return localArray;
}



@end
