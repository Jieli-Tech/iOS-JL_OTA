//
//  JL_CustomManager.h
//  JL_BLEKit
//  Created by 李放 on 2021/12/21.
//  Modify by EzioChan on 2023/03/16.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JL_FunctionBaseManager.h"
#import "JL_TypeEnum.h"
#import "JL_Tools.h"

NS_ASSUME_NONNULL_BEGIN

///设备返回的自定义数据
extern NSString *kJL_MANAGER_CUSTOM_DATA;
/// 设备返回的自定义数据(回复包)
extern NSString *kJL_MANAGER_CUSTOM_DATA_RSP;


@protocol JLCustomCmdPtl <NSObject>

/// 设备回复自定义数据内容
/// - Parameters:
///   - device: 设备句柄
///   - data: 回复数据内容
-(void)customCmdResponse:(JL_ManagerM *)manager Status:(uint8_t)status WithData:(NSData *)data;

/// 设备主动请求
/// - Parameters:
///   - device: 设备
///   - data: 请求数据内容
-(void)customCmdRequire:(JL_ManagerM *)manager WithData:(NSData *)data;


@end

@interface JL_CustomManager : JL_FunctionBaseManager

/// 数据回调委托
@property(nonatomic,weak)id<JLCustomCmdPtl> delegate;

#pragma mark ---> 用户自定义数据
/**
 @param data 数据
 @param result 回复
 */
-(void)cmdCustomData:(NSData* __nullable)data
              Result:(JL_CMD_RESPOND __nullable)result;

@end

NS_ASSUME_NONNULL_END
