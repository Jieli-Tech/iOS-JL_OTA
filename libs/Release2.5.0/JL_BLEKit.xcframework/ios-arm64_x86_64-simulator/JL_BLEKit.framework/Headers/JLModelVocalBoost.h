//
//  JLModelVocalBoost.h
//  JL_BLEKit
//
//  Created by EzioChan on 2023/9/13.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <JL_BLEKit/JL_BLEKit.h>

NS_ASSUME_NONNULL_BEGIN


@class JLModelVocalBoost;

@protocol JLModelVocalBoostDelegate <NSObject>

-(void)vocalBoostGetInfo:(JLModelVocalBoost *)model;

@end

typedef void(^JLModelVocalBoostBlock)(JLModelVocalBoost *model);


/// TWS人声增强
@interface JLModelVocalBoost : JLCmdBasic

/// 版本号
@property(nonatomic,assign)uint8_t version;

/// 人声增强:
/// 0x00: 关闭人声增强模式;
/// 0x01: 开启人声增强模式
@property(nonatomic,assign)uint8_t status;

@property(nonatomic,weak)id<JLModelVocalBoostDelegate> delegate;

/// 获取设备人声增强
/// - Parameter manager: 设备对象
-(void)vocalBoostStatusGet:(JL_ManagerM *)manager Result:(JLModelVocalBoostBlock)block;

/// 设置设备人声增强
/// - Parameters:
///   - manager: 设备对象
///   - status: 开关
///     0x00: 关闭人声增强模式;
///     0x01: 开启人声增强模式
///   - result:回调
-(void)vocalBoostStatusSet:(JL_ManagerM *)manager Status:(uint8_t)status Result:(JL_CMD_RESPOND)result;


@end

NS_ASSUME_NONNULL_END
