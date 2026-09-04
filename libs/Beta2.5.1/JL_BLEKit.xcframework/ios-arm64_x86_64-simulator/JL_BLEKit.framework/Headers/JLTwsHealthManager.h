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
@class JLTwsStepModel;
@class JLTwsHealthHeartRateModel;

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

@optional
/// Tws 耳机设备的心率
/// @param heartRate 心率
-(void)twsHealthHeartRate:(JLTwsHeartRateModel *) heartRate;

/// Tws 耳机设备的血氧
/// @param spO2 血氧
-(void)twsHealthBloodOxygen:(JLTwsSpO2Model *) spO2;

/// Tws 耳机设备的步数
/// @param step 步数
-(void)twsHealthStep:(JLTwsStepModel *) step;

/// Tws 耳机设备的全天心率
/// @param dailyHeartRate 全天心率
-(void)twsHealthDailyHeartRate:(JLTwsHealthHeartRateModel *) dailyHeartRate;

/// Tws 耳机设备开启了心率监测
-(void)twsHealthStartHeartRate;

/// Tws 耳机设备取消了心率监测
-(void)twsHealthCancelHeartRate;

/// Tws 耳机设备开启了血氧监测
-(void)twsHealthStartBloodOxygen;

/// Tws 耳机设备取消了血氧监测
-(void)twsHealthCancelBloodOxygen;

/// Tws 耳机设备开启了步数监测
-(void)twsHealthStartStep;

/// Tws 耳机设备取消了步数监测
-(void)twsHealthCancelStep;

/// Tws 耳机设备开启同步全天心率数据
-(void)twsHealthStartDailyHeartSync;

/// Tws 耳机设备结束同步全天心率数据
-(void)twsHealthEndDailyHeartSync;

@end

typedef NS_ENUM(NSUInteger, JLTwsHealthOpType) {
    JLTwsHealthOpTypeStartHeartRate = 1,
    JLTwsHealthOpTypeCancelHeartRate = 2,
    JLTwsHealthOpTypeStartBloodOxygen = 3,
    JLTwsHealthOpTypeCancelBloodOxygen = 4,
    JLTwsHealthOpTypeStartStep = 5,
    JLTwsHealthOpTypeCancelStep = 6,
    JLTwsHealthOpTypeStartDailyHeartSync = 32,
    JLTwsHealthOpTypeEndDailyHeartSync = 33,
};

typedef void(^JLTwsHealthModeBlock)(JLTwsHealthConfig *_Nullable mode, NSError * _Nullable error);

typedef void(^JLTwsHealthSensorStatusBlock)(BOOL heartRateStatus, BOOL bloodOxygenStatus, BOOL stepStatus, BOOL inEarSensorStatus, NSError * _Nullable error);

typedef void(^JLTwsHealthResultBlock)(NSError * _Nullable error);

/// 管理 TWS 耳机健康数据的统一入口，负责：
/// 1) 发送健康相关指令（心率、血氧、步数、全天心率同步等）
/// 2) 解析设备应答与设备主动推送事件，并通过回调/代理分发
/// 3) 管理传感器状态、最近一次检测结果与超时配置
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
/// YES:入耳
/// NO:出耳
@property(nonatomic, assign)BOOL inEarSensorStatus;

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


/// 控制耳机进行健康数据相关的操作
/// 操作类型：
/// JLTwsHealthOpTypeStartHeartRate 开启心率监测
/// JLTwsHealthOpTypeCancelHeartRate 取消心率监测
/// JLTwsHealthOpTypeStartBloodOxygen 开启血氧监测
/// JLTwsHealthOpTypeCancelBloodOxygen 取消血氧监测
/// JLTwsHealthOpTypeStartStep 开启步数监测
/// JLTwsHealthOpTypeCancelStep 取消步数监测
/// JLTwsHealthOpTypeStartDailyHeartSync 开启同步全天心率数据
/// JLTwsHealthOpTypeEndDailyHeartSync 结束同步全天心率数据
/// 示例：开启心率监测
/// [manager twsHealthOpActionWithType:JLTwsHealthOpTypeStartHeartRate result:^(void){
///     NSLog(@"心率监测已开启");
/// }];
///
/// 示例：取消心率监测
/// [manager twsHealthOpActionWithType:JLTwsHealthOpTypeCancelHeartRate result:^(void){
///     NSLog(@"心率监测已取消");
/// }];
///
/// 示例：开启血氧监测
/// [manager twsHealthOpActionWithType:JLTwsHealthOpTypeStartBloodOxygen result:^(void){
///     NSLog(@"血氧监测已开启");
/// }];
///
/// 示例：取消血氧监测
/// [manager twsHealthOpActionWithType:JLTwsHealthOpTypeCancelBloodOxygen result:^(void){
///     NSLog(@"血氧监测已取消");
/// }];
///
/// 示例：开启步数监测
/// [manager twsHealthOpActionWithType:JLTwsHealthOpTypeStartStep result:^(void){
///     NSLog(@"步数监测已开启");
/// }];
///
/// 示例：取消步数监测
/// [manager twsHealthOpActionWithType:JLTwsHealthOpTypeCancelStep result:^(void){
///     NSLog(@"步数监测已取消");
/// }];
///
/// 示例：开启同步全天心率数据
/// [manager twsHealthOpActionWithType:JLTwsHealthOpTypeStartDailyHeartSync result:^(void){
///     NSLog(@"全天心率同步已开启");
/// }];
///
/// 示例：结束同步全天心率数据
/// [manager twsHealthOpActionWithType:JLTwsHealthOpTypeEndDailyHeartSync result:^(void){
///     NSLog(@"全天心率同步已结束");
/// }];
/// - Parameters:
///   - type: 操作类型
///   - block: 回调
-(void)twsHealthOpActionWithType:(JLTwsHealthOpType)type result:(JLTwsHealthResultBlock __nullable)block;

/// 查询实时步数
/// 轮询策略
/// - Parameter time: 轮询间隔 单位 s
/// 一般固件要求时间为 5min 内轮询一次
/// 例子：[manager loopQueryRealStep:4 * 60];
-(void)loopQueryRealStep:(NSTimeInterval)time;

/// 取消轮询
/// 例子：[manager cancelLoopQueryRealStep];
-(void)cancelLoopQueryRealStep;

/// 查询实时步数
/// 例子：[manager queryRealStep];
-(void)queryRealStep;


@end

NS_ASSUME_NONNULL_END
