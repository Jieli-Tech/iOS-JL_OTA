//
//  JL_SDM_OxSaturation.h
//  Test
//
//  Created by EzioChan on 2021/4/7.
//  Copyright © 2021 Zhuhai Jieli Technology Co.,Ltd. All rights reserved.
//

#import "JLSportDataModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 血氧饱和度
@interface JL_SDM_OxSaturation : JLSportDataModel

/// 饱和度
@property(nonatomic,assign)int staturation;

/// 血氧饱和度
/// 处理回复数据内容
/// @param value 数据内容
/// @param submask 功能标记位
+(JL_SDM_OxSaturation*)responseData:(NSData *)value subMask:(NSData *)submask;

/// 请求内容
+(JL_SDM_OxSaturation*)require;


@end

NS_ASSUME_NONNULL_END
