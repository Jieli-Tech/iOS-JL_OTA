//
//  JLTwsHealthMode.h
//  JL_BLEKit
//
//  Created by EzioChan on 2025/10/11.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// tws 健康配置
@interface JLTwsHealthConfig : NSObject

//是否支持单次心率采集
@property (nonatomic, assign) BOOL isSupportOnceHeartRate;

//是否支持全天心率采集
@property (nonatomic, assign) BOOL isSupportAllDayHeartRate;

//是否支持单次血氧采集
@property (nonatomic, assign) BOOL isSupportOnceBloodOxygen;

//是否支持全天步数采集
@property (nonatomic, assign) BOOL isSupportAllDayStep;


-(JLTwsHealthConfig *)initWithData:(NSData *)data;

@end

/// 心率模型
@interface JLTwsHeartRateModel : NSObject

/// 实时心率
@property(nonatomic,assign)NSInteger avgHeartRate;
/// 静息心率
@property(nonatomic,assign)NSInteger restHeartRate;
/// 最大心率
@property(nonatomic,assign)NSInteger maxHeartRate;
/// 单次测量心率
@property(nonatomic,assign)NSInteger onceHeartRate;

/// 初始化心率模型
/// @param data 数据
/// @param subMask 子掩码
-(instancetype)initWithData:(NSData *)data subMask:(uint8_t)subMask;

@end


/// 血氧模型
@interface JLTwsSpO2Model : NSObject

///血氧饱和度
@property(nonatomic,assign)NSInteger avgSpO2;
/// 最大值
@property(nonatomic,assign)NSInteger maxSpO2;
/// 最小值
@property(nonatomic,assign)NSInteger minSpO2;
/// 单次测量血氧饱和度
@property(nonatomic,assign)NSInteger onceSpO2;

/// 初始化血氧模型
/// @param data 数据
/// @param subMask 子掩码
-(instancetype)initWithData:(NSData *)data subMask:(uint8_t)subMask;

@end


/// 步数模型
@interface JLTwsStepModel : NSObject

/// 实时步数
@property(nonatomic,assign)NSInteger realTimeStep;
/// 距离,单位：0.01公里
@property(nonatomic,assign)NSInteger distance;
/// 热量：单位：千卡
@property(nonatomic,assign)NSInteger calorie;

/// 初始化步数模型
/// @param data 数据
/// @param subMask 子掩码
-(instancetype)initWithData:(NSData *)data subMask:(uint8_t)subMask;

@end

NS_ASSUME_NONNULL_END
