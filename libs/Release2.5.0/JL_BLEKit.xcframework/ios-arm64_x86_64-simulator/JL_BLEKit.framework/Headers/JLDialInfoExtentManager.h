//
//  JLDialInfoExtentManager.h
//  JL_BLEKit
//
//  Created by EzioChan on 2024/2/20.
//  Copyright © 2024 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JL_TypeEnum.h"

@class JLDialInfoExtentedModel;
@class JL_ManagerM;

NS_ASSUME_NONNULL_BEGIN

/// 表盘信息扩展内容回调
/// Dial information extended content block
typedef void(^JLDialInfoExtentedBlock)(JL_CMDStatus status,JLDialInfoExtentedModel *_Nullable op);

/// 请求设备表盘信息扩展内容类
/// Request device dial information extended content class
@interface JLDialInfoExtentManager : NSObject

/// 单例
/// Single
+(instancetype)share;

/// 开始请求表盘信息扩展内容
/// Start request dial information extended content
/// - Parameters:
///   - manager: 设备 - Device manager
///   - block: 状态回调 - Dial information extended content block
-(void)getDialInfoExtented:(JL_ManagerM *)manager result:(JLDialInfoExtentedBlock)block;

@end

NS_ASSUME_NONNULL_END
