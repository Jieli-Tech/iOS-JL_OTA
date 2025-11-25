//
//  JLTwsHealthManager.h
//  JL_BLEKit
//
//  Created by EzioChan on 2025/10/11.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/ECOneToMorePtl.h>

NS_ASSUME_NONNULL_BEGIN
@class JL_ManagerM;
@class JLTwsHealthConfig;
@class JLTwsSpO2Model;
@class JLTwsHeartRateModel;

/// 心率、血氧、步数回调
@protocol JLTwsHealthManagerDelegate <NSObject>

/// Tws 耳机设备的心率、血氧、步数
/// @param model Tws 耳机设备的心率、血氧、步数
-(void)twsHealthConfigModel:(JLTwsHealthConfig *)model;

/// Tws 耳机设备的心率、血氧、步数传感器状态
/// @param heartRateStatus 心率传感器状态
/// @param bloodOxygenStatus 血氧传感器状态
/// @param stepStatus 步数传感器状态
/// @param inEarSensorStatus 入耳检测传感器状态
-(void)twsHealthSensorStatus:(BOOL)heartRateStatus bloodOxygenStatus:(BOOL)bloodOxygenStatus stepStatus:(BOOL)stepStatus inEarSensorStatus:(BOOL)inEarSensorStatus;

/// Tws 耳机设备的心率
/// @param heartRate 心率
-(void)twsHealthHeartRate:(JLTwsHeartRateModel *) heartRate;

/// Tws 耳机设备的心率检测超时时间
/// 这里的超时时间是指在没有检测到心率变化的情况下，超过这个时间间隔后，会触发超时回调
/// @param timeOut 超时时间，单位：秒
-(void)twsHealthHeartRateTimeOut:(NSInteger) timeOut;
/// Tws 耳机设备的心率检测错误码
/// @param errorCode 错误码
-(void)twsHealthHeartRateCheckError:(NSInteger) errorCode;

/// Tws 耳机设备的血氧
/// @param spO2 血氧
-(void)twsHealthBloodOxygen:(JLTwsSpO2Model *) spO2;

/// Tws 耳机设备的血氧检测超时时间
/// 这里的超时时间是指在没有检测到血氧变化的情况下，超过这个时间间隔后，会触发超时回调
/// @param timeOut 超时时间，单位：秒   
-(void)twsHealthBloodOxygenTimeOut:(NSInteger) timeOut;
/// Tws 耳机设备的血氧检测错误码
/// @param errorCode 错误码
-(void)twsHealthBloodOxygenCheckError:(NSInteger) errorCode;

@end

typedef void(^JLTwsHealthModeBlock)(JLTwsHealthConfig *_Nullable mode, NSError * _Nullable error);

typedef void(^JLTwsHealthSensorStatusBlock)(BOOL heartRateStatus, BOOL bloodOxygenStatus, BOOL stepStatus, BOOL inEarSensorStatus);

typedef void(^JLTwsHealthHeartRateBlock)(NSInteger heartRateTimeout);

typedef void(^JLTwsHealthBloodOxygenBlock)(NSInteger bloodOxygenTimeout);

typedef void(^JLTwsHealthStartStepBlock)(void);

typedef void(^JLTwsHealthStepBlock)(NSInteger step);

/// Tws 耳机设备的心率、血氧、步数
@interface JLTwsHealthManager : ECOneToMorePtl

/// 心率传感器状态
/// YES:开启检测中
/// NO:关闭
@property(nonatomic, assign)BOOL heartRateSensorStatus;

/// 血氧传感器状态
/// YES:开启检测中
/// NO:关闭
@property(nonatomic, assign)BOOL bloodOxygenSensorStatus;

/// 步数传感器状态
/// YES:开启检测中
/// NO:关闭
@property(nonatomic, assign)BOOL stepSensorStatus;

/// 入耳检测传感器状态
/// YES:入耳中
/// NO:出耳
@property(nonatomic, assign)BOOL inEarSensorStatus;

/// 心率检测超时时间
@property(nonatomic, assign)NSInteger heartRateTimeOut;

/// 血氧检测超时时间
@property(nonatomic, assign)NSInteger bloodOxygenTimeOut;

/// 最后检测到的心率
@property(nonatomic, assign)NSInteger lastHeartRate;

/// 最后检测到的血氧
@property(nonatomic, assign)NSInteger lastBloodOxygen;

/// 代理
@property(nonatomic, weak)id<JLTwsHealthManagerDelegate> delegate;

-(instancetype)init NS_UNAVAILABLE;

-(instancetype) init:(JL_ManagerM *)manager delegate:(id<JLTwsHealthManagerDelegate>)delegate;

/// 查询配置
/// - Parameters:
///   - block: 回调
-(void)cmdGetHealthConfigWithResult:(JLTwsHealthModeBlock)block;

/// 查询状态
/// - Parameters:
///   - block: 回调
-(void)cmdCheckSensorStatus:(JLTwsHealthSensorStatusBlock __nullable)block;

/// 开始检测心率
/// - Parameters:
///   - block: 回调
-(void)cmdStartCheckHeartRate:(JLTwsHealthHeartRateBlock __nullable)block;

/// 取消检测心率
-(void)cmdCancelCheckHeartRate;

/// 开始检测血氧
/// - Parameters:
///   - block: 回调
-(void)cmdStartCheckBloodOxygen:(JLTwsHealthBloodOxygenBlock __nullable)block;

/// 取消检测血氧
-(void)cmdCancelCheckBloodOxygen;

/// 开始检测步数
-(void)cmdStartCheckStep:(JLTwsHealthStartStepBlock __nullable)block;

/// 取消检测步数
-(void)cmdCancelCheckStep;

/// 获取步数
/// @param block 获取步数回调
-(void)cmdGetHealthStep:(JLTwsHealthStepBlock)block;

@end

NS_ASSUME_NONNULL_END
