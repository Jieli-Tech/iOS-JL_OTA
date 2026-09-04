//
//  JLEcTimerHelper.h
//  JL_BLEKit
//
//  Created by EzioChan on 2025/3/13.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLEcTimerHelper : NSObject
/// 创建单次定时器
+ (NSString *)startTimerWithTimeout:(NSTimeInterval)timeout completion:(void (^)(NSString *timerID))completion;

/// 创建重复定时器
+ (NSString *)setInterval:(NSTimeInterval)interval completion:(void (^)(NSString *timerID))completion;

/// 停止定时器
+ (void)stopTimer:(NSString *)timerID;

/// 停止所有定时器
+ (void)stopAllTimers;

/// 开始计算耗时
+ (NSUUID *)startCalculateTime;

/// 停止计算耗时
+ (NSTimeInterval) stopCalculateTime:(NSUUID *)uuid;
@end

NS_ASSUME_NONNULL_END
