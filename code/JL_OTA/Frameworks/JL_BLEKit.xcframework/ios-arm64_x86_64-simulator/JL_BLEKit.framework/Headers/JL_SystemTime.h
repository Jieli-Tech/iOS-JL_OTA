//
//  JL_SystemTime.h
//  JL_BLEKit
//
//  Created by 李放 on 2021/12/20.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_FunctionBaseManager.h>
#import <JL_BLEKit/JL_TypeEnum.h>
#import <JL_BLEKit/JL_Tools.h>

NS_ASSUME_NONNULL_BEGIN

@interface JL_SystemTime : JL_FunctionBaseManager


/// 设备当前时间
@property(nonatomic,strong)JLModel_RTC *rtc;

#pragma mark ---> 设置系统时间
/**
 @param date 时间类
 */
-(void)cmdSetSystemTime:(NSDate*)date __attribute__((deprecated ( "Please use the (cmdSetSystemYear: Month: Day: Hour: Minute: Second) method instead. The current method will be invalid")));


/// 设置系统年月日时分秒
/// @param year 年
/// @param month 月
/// @param day 日
/// @param hour 时
/// @param min 分
/// @param sec 秒
-(void)cmdSetSystemYear:(uint16_t)year
                  Month:(uint8_t)month
                    Day:(uint8_t)day
                   Hour:(uint8_t)hour
                 Minute:(uint8_t)min
                 Second:(uint8_t)sec;

@end

NS_ASSUME_NONNULL_END
