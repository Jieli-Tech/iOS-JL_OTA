//
//  JLTranslateTWSStateMachine.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/6/18.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JLTranslateTWSMachineState) {
    JLTranslateTWSMachineStateIdle = 0,
    JLTranslateTWSMachineStateEntering,        // 正在进入 TWS 分离
    JLTranslateTWSMachineStateScanningSlave,   // 正在搜索从机
    JLTranslateTWSMachineStateConnectingSlave, // 正在连接从机
    JLTranslateTWSMachineStateSlaveReady,      // 从机就绪
    JLTranslateTWSMachineStateWorking,         // 同声翻译工作中
    JLTranslateTWSMachineStateExiting,         // 正在退出
    JLTranslateTWSMachineStateError            // 异常
};

/// TWS 状态机
@interface JLTranslateTWSStateMachine : NSObject

@property (nonatomic, assign, readonly) JLTranslateTWSMachineState currentState;

/// 状态变更回调
@property (nonatomic, copy, nullable) void (^stateDidChange)(JLTranslateTWSMachineState oldState, JLTranslateTWSMachineState newState);

- (void)transitionToState:(JLTranslateTWSMachineState)state;

- (BOOL)isInState:(JLTranslateTWSMachineState)state;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
