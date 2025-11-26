//
//  JLModelSceneNoiseReduction.h
//  JL_BLEKit
//
//  Created by EzioChan on 2023/9/13.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <JL_BLEKit/JLCmdBasic.h>

NS_ASSUME_NONNULL_BEGIN
@class JLModelSceneNoiseReduction;

@protocol JLModelSceneNoiseReductionDelegate <NSObject>

-(void)sceneNoiseReductionGetInfo:(JLModelSceneNoiseReduction *)model;

@end

typedef void(^JLSceneNoiseReductionBlock)(JLModelSceneNoiseReduction *model);

/// TWS场景降噪
@interface JLModelSceneNoiseReduction : JLCmdBasic

/// 版本号
@property(nonatomic,assign)uint8_t version;

/// 场景降噪模式:
/// 0x00:智能
/// 0x01:轻度
/// 0x02:均衡
/// 0x03:深度
@property(nonatomic,assign)uint8_t scene;

@property(nonatomic,weak)id<JLModelSceneNoiseReductionDelegate> delegate;

/// 获取设备场景降噪
/// - Parameter manager: 设备对象
-(void)sceneNoiseStatusGet:(JL_ManagerM *)manager Result:(JLSceneNoiseReductionBlock)block;

/// 设置设备场景降噪
/// - Parameters:
///   - manager: 设备对象
///   - scene: 场景降噪
///   - result:回调
-(void)sceneNoiseStatusSet:(JL_ManagerM *)manager Scene:(uint8_t)scene Result:(JL_CMD_RESPOND)result;


@end

NS_ASSUME_NONNULL_END
