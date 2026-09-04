//
//  JL_SystemVolume.h
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

@interface JL_SystemVolume : JL_FunctionBaseManager

/// 是否支持多通道音量（媒体音量 + 通话音量）
/// 由设备配置信息(0xD9)中 audioFunc.supportMultiSceneTuning 决定，内部自动获取
@property (readonly, assign, nonatomic) BOOL supportMultiChannelVolume;

- (instancetype)init NS_UNAVAILABLE;
/// 内部构造方法，仅由 JL_ManagerLink 调用
- (instancetype)initForManager;

#pragma mark ---> 设置系统音量
/**
 @param volume 音量值
 */
-(void)cmdSetSystemVolume:(UInt8)volume;
-(void)cmdSetSystemVolume:(UInt8)volume Result:(JL_CMD_RESPOND __nullable)result;

#pragma mark ---> 设置媒体音量
/**
 需要设备支持多通道音量功能（supportMultiChannelVolume = YES），否则不执行设置
 @param volume 媒体音量值
 */
-(void)cmdSetMediaVolume:(UInt8)volume;
-(void)cmdSetMediaVolume:(UInt8)volume Result:(JL_CMD_RESPOND __nullable)result;

#pragma mark ---> 设置通话音量
/**
 需要设备支持多通道音量功能（supportMultiChannelVolume = YES），否则不执行设置
 @param volume 通话音量值
 */
-(void)cmdSetCallVolume:(UInt8)volume;
-(void)cmdSetCallVolume:(UInt8)volume Result:(JL_CMD_RESPOND __nullable)result;

@end

NS_ASSUME_NONNULL_END
