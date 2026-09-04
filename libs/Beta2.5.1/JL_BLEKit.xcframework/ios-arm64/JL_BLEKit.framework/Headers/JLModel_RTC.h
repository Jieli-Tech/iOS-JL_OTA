//
//  JLModel_RTC.h
//  JL_BLEKit
//
//  Created by 杰理科技 on 2021/10/15.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/RTC_RingInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLModel_RTC : NSObject

/// 年
@property (assign,nonatomic) uint16_t       rtcYear;

/// 月
@property (assign,nonatomic) uint8_t        rtcMonth;

/// 日
@property (assign,nonatomic) uint8_t        rtcDay;

/// 时
@property (assign,nonatomic) uint8_t        rtcHour;

/// 分
@property (assign,nonatomic) uint8_t        rtcMin;

/// 秒
@property (assign,nonatomic) uint8_t        rtcSec;

/// RTC使能
@property (assign,nonatomic) BOOL           rtcEnable;

/// RTC循环模式
/// mode: 值为 0 时只响一次
/// bit0: 每天
/// bit1: 周一
/// bit2: 周二
/// bit3: 周三
/// bit4: 周四
/// bit5: 周五
/// bit6: 周六
/// bit7: 周日
@property (assign,nonatomic) uint8_t        rtcMode;


/// RTC索引
@property (assign,nonatomic) uint8_t        rtcIndex;

/// 名称
@property (copy  ,nonatomic) NSString       *rtcName;

/// 自定义闹铃内容
/// 这部分内容取自设备音乐浏览所获得的句柄以及簇号
@property (strong,nonatomic) RTC_RingInfo   *ringInfo;

/// 闹铃数据
@property (strong,nonatomic) NSData         *RingData;
@end

NS_ASSUME_NONNULL_END
