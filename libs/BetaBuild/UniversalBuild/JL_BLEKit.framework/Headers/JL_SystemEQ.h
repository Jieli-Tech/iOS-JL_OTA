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

@protocol JL_SystemEQDelegate <NSObject>
@optional
/// EQ 模式发生变更
-(void)jlSystemEQ:(JL_SystemEQ *)systemEQ didChangeMode:(JL_EQMode)mode;
/// EQ 参数值发生变更
-(void)jlSystemEQ:(JL_SystemEQ *)systemEQ didChangeArray:(NSArray *)eqArray;
/// EQ 段数类型发生变更
-(void)jlSystemEQ:(JL_SystemEQ *)systemEQ didChangeType:(JL_EQType)type;
/// EQ 频率数组发生变更
-(void)jlSystemEQ:(JL_SystemEQ *)systemEQ didChangeFrequencyArray:(NSArray *)freqArray;
/// EQ 预设值数组发生变更
-(void)jlSystemEQ:(JL_SystemEQ *)systemEQ didChangeDefaultArray:(NSArray<JLModel_EQ *> *)defaultArray;
/// 综合更新回调（任何以上变更都会额外触发此方法，便于简单场景一次性处理）
-(void)jlSystemEQDidUpdate:(JL_SystemEQ *)systemEQ;
@end

@interface JL_SystemEQ : JL_FunctionBaseManager

/// 代理
@property (weak, nonatomic) id<JL_SystemEQDelegate> delegate;

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
