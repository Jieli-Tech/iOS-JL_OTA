//
//  JL_SystemEQ.h
//  JL_BLEKit
//
//  Created by 李放 on 2021/12/20.
//  Modify by EzioChan on 2023/09/22
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_FunctionBaseManager.h>
#import <JL_BLEKit/JL_TypeEnum.h>
#import <JL_BLEKit/JL_Tools.h>


NS_ASSUME_NONNULL_BEGIN
@class JL_SystemEQ;
typedef void(^JLSystemEQResult)(JL_CMDStatus status,JL_SystemEQ * _Nullable model);

@interface JL_SystemEQ : JL_FunctionBaseManager

///  当前EQ模式
@property (assign,nonatomic) JL_EQMode eqMode;

/// EQ段数类型
@property (assign,nonatomic) JL_EQType eqType;

/// EQ参数值
/// （只适用于EQ Mode == CUSTOM情况）
@property (strong,  nonatomic) NSArray *eqArray;

/// 自定义 EQ数组
@property (strong,  nonatomic) NSArray *eqCustomArray;

/// EQ频率
@property (strong,  nonatomic) NSArray *eqFrequencyArray;

/// EQ的预设值数组
@property (strong,nonatomic) NSArray <JLModel_EQ*> *eqDefaultArray;


/// 设置系统EQ
/// - Parameters:
///   - eqMode: EQ模式
///   - params: EQ参数
-(void)cmdSetSystemEQ:(JL_EQMode)eqMode Params:(NSArray* __nullable)params;

/// 查询系统EQ内容
-(void)cmdGetSystemEQ:(JLSystemEQResult)result;


@end

NS_ASSUME_NONNULL_END
