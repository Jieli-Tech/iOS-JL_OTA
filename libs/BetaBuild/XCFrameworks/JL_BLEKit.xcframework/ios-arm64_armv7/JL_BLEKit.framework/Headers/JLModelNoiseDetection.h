//
//  JLModelNoiseDetection.h
//  JL_BLEKit
//
//  Created by EzioChan on 2023/9/13.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <JL_BLEKit/JL_BLEKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JLModelNoiseDetection;

@protocol JLModelNoiseDetectionDelegate <NSObject>

-(void)noiseDetectionGetInfo:(JLModelNoiseDetection *)model;

@end

typedef void(^JLModelNoiseDetectionBlock)(JLModelNoiseDetection *model);

/// TWS风噪检测
@interface JLModelNoiseDetection : JLCmdBasic

/// 版本号
@property(nonatomic,assign)uint8_t version;

/// 风噪检测:
/// 0x00:关闭
/// 0x01:开启
@property(nonatomic,assign)uint8_t status;

@property(nonatomic,weak)id<JLModelNoiseDetectionDelegate> delegate;

/// 获取设备风噪检测
/// - Parameter manager: 设备对象
-(void)noiseDetectionStatusGet:(JL_ManagerM *)manager Result:(JLModelNoiseDetectionBlock)block;

/// 设置设备风噪检测
/// - Parameters:
///   - manager: 设备对象
///   - status: 开关
///   - result:回调
-(void)noiseDetectionStatusSet:(JL_ManagerM *)manager Status:(uint8_t)status Result:(JL_CMD_RESPOND)result;


@end

NS_ASSUME_NONNULL_END
