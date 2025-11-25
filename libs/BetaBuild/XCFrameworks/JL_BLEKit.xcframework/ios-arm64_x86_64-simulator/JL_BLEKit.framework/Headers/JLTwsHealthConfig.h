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

/// 最大心率
@property(nonatomic,assign)NSInteger maxHeartRate;
/// 最小心率
@property(nonatomic,assign)NSInteger minHeartRate;
/// 最终心率
@property(nonatomic,assign)NSInteger avgHeartRate;

@end


/// 血氧模型
@interface JLTwsSpO2Model : NSObject

/// 最大血氧
@property(nonatomic,assign)NSInteger maxSpO2;
/// 最小血氧
@property(nonatomic,assign)NSInteger minSpO2;
/// 最终血氧
@property(nonatomic,assign)NSInteger avgSpO2;

@end

NS_ASSUME_NONNULL_END
