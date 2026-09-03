//
//  JLTranslateTWSEngine.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/6/18.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLTranslateDeviceInfo.h"
#import "JLTranslateTWSStateMachine.h"

NS_ASSUME_NONNULL_BEGIN

@class JLTranslateTWSEngine;

@protocol JLTranslateTWSEngineDelegate <NSObject>

@optional
/// TWS 引擎状态变更
- (void)twsEngine:(JLTranslateTWSEngine *)engine stateChanged:(JLTranslateTWSMachineState)state;

/// 请求进入 TWS 分离模式（调用方需要发送 0x8034 op=0x08）
- (void)twsEngineDidRequestEnterSplitMode:(JLTranslateTWSEngine *)engine;

/// 请求退出 TWS 分离模式
- (void)twsEngineDidRequestExitSplitMode:(JLTranslateTWSEngine *)engine;

/// 从机已就绪
- (void)twsEngine:(JLTranslateTWSEngine *)engine slaveDidReady:(JLTranslateDeviceInfo *)slave;

/// 发生错误
- (void)twsEngine:(JLTranslateTWSEngine *)engine didFail:(NSError *)error;

@end

/// TWS 引擎
@interface JLTranslateTWSEngine : NSObject

@property (nonatomic, weak) id<JLTranslateTWSEngineDelegate> delegate;
@property (nonatomic, strong, readonly) JLTranslateTWSStateMachine *stateMachine;
@property (nonatomic, strong, nullable) JLTranslateDeviceInfo *masterDevice;
@property (nonatomic, strong, nullable) JLTranslateDeviceInfo *slaveDevice;

- (void)configureMaster:(JLTranslateDeviceInfo *)master;
- (void)configureSlave:(JLTranslateDeviceInfo *)slave;

/// 开始 TWS 分离流程
- (void)startSplitting;

/// 标记 TWS 分离成功
- (void)markSplitSuccess;

/// 标记从机已连接并就绪
- (void)markSlaveReady;

/// 标记开始同声翻译工作
- (void)markWorking;

/// 断开配对
- (void)disconnectPairing;

/// 重置
- (void)reset;

/// 更新 TWS 状态（收到 0x8034 op=0x08 通知时调用）
/// - Parameters:
///   - isConnected: TWS 是否已连接
///   - roleInfos: 设备角色信息列表
- (void)updateTWSState:(BOOL)isConnected roleInfos:(NSArray<JLTranslateDeviceInfo *> *)roleInfos;

@end

NS_ASSUME_NONNULL_END
