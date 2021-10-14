//
//  JLWatchEnum.h
//  JL_BLEKit
//
//  Created by EzioChan on 2021/8/2.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *_Nonnull const  JL_Watch_HeartRate;
extern NSString *_Nonnull const  JL_Watch_AirPressure;
extern NSString *_Nonnull const  JL_Watch_Altitude;
extern NSString *_Nonnull const  JL_Watch_MoveSteps;
extern NSString *_Nonnull const  JL_Watch_Stress;
extern NSString *_Nonnull const  JL_Watch_Oxsaturation;
extern NSString *_Nonnull const  JL_Watch_MaxOxg;
extern NSString *_Nonnull const  JL_Watch_RecTime;
extern NSString *_Nonnull const  JL_Watch_SportMsg;
extern NSString *_Nonnull const  JL_Watch_WatchLog;

NS_ASSUME_NONNULL_BEGIN

typedef enum : UInt32 {
    /// 加速度
    Log_Acceleration = 0x80000000 >> 31,
    /// 心率和血氧
    Log_HeartRate_BloodOxy = 0x80000000 <<30,
} WATCH_LOG_MASK;

typedef enum : UInt32 {
    ///设备回的加速度
    Log_Res_Acceleration = 0x00,
    /// 设备回的心率血氧
    Log_Res_HeartRate_BloodOxy = 0x01,
} WATCH_LOG_TYPE;


@interface JLWatchEnum : NSObject


@end

NS_ASSUME_NONNULL_END
