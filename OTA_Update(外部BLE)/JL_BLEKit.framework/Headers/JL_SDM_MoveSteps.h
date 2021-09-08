//
//  JL_SDM_MoveSteps.h
//  Test
//
//  Created by EzioChan on 2021/4/6.
//  Copyright © 2021 Zhuhai Jieli Technology Co.,Ltd. All rights reserved.
//

#import "JLSportDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JL_SDM_MoveSteps : JLSportDataModel

@property(nonatomic,assign)long long allStep;
@property(nonatomic,assign)long rtStep;

/// 处理回复数据内容
/// @param value 数据内容
/// @param submask 功能标记位
+(JL_SDM_MoveSteps*)responseData:(NSData *)value subMask:(NSData *)submask;

/// 选择性请求内容
+(JL_SDM_MoveSteps*)requireAll:(BOOL)as rtStep:(BOOL)rts;
/// 请求内容
+(JL_SDM_MoveSteps*)require;

@end

NS_ASSUME_NONNULL_END
