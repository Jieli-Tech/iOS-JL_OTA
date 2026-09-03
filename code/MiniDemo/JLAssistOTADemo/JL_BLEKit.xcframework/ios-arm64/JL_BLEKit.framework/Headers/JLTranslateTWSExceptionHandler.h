//
//  JLTranslateTWSExceptionHandler.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/6/18.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLTranslateDeviceInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class JLTranslateTWSExceptionHandler;

@protocol JLTranslateTWSExceptionHandlerDelegate <NSObject>

@optional
/// 从机异常断开
- (void)exceptionHandler:(JLTranslateTWSExceptionHandler *)handler slaveDidDisconnect:(JLTranslateDeviceInfo *)device error:(nullable NSError *)error;

/// 主机异常断开
- (void)exceptionHandler:(JLTranslateTWSExceptionHandler *)handler masterDidDisconnect:(JLTranslateDeviceInfo *)device error:(nullable NSError *)error;

/// 超时异常
- (void)exceptionHandler:(JLTranslateTWSExceptionHandler *)handler timeoutOccurred:(NSString *)identifier;

@end

/// TWS 异常处理器
@interface JLTranslateTWSExceptionHandler : NSObject

@property (nonatomic, weak) id<JLTranslateTWSExceptionHandlerDelegate> delegate;

+ (instancetype)sharedHandler;

/// 注册监控设备
- (void)monitorDevice:(JLTranslateDeviceInfo *)device;

/// 停止监控设备
- (void)stopMonitoringDevice:(JLTranslateDeviceInfo *)device;

/// 停止所有监控
- (void)stopAllMonitoring;

/// 上报异常
- (void)reportExceptionWithDevice:(nullable JLTranslateDeviceInfo *)device error:(nullable NSError *)error;

/// 上报超时
- (void)reportTimeout:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
