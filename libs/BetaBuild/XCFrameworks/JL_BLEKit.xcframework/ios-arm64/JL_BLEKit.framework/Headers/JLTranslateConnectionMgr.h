//
//  JLTranslateConnectionMgr.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/6/18.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLTranslateDeviceInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class JLTranslateConnectionMgr;

@protocol JLTranslateConnectionMgrDelegate <NSObject>

@optional
/// 连接成功
- (void)connectionMgr:(JLTranslateConnectionMgr *)mgr didConnectDevice:(JLTranslateDeviceInfo *)device;

/// 连接失败
- (void)connectionMgr:(JLTranslateConnectionMgr *)mgr didFailToConnectDevice:(JLTranslateDeviceInfo *)device error:(NSError *)error;

/// 断开连接
- (void)connectionMgr:(JLTranslateConnectionMgr *)mgr didDisconnectDevice:(JLTranslateDeviceInfo *)device error:(nullable NSError *)error;

@end

/// 同声翻译连接管理器
/// 负责 MASTER / SLAVE 两路连接的生命周期协调
@interface JLTranslateConnectionMgr : NSObject

@property (nonatomic, weak) id<JLTranslateConnectionMgrDelegate> delegate;

/// 主机设备
@property (nonatomic, strong, nullable) JLTranslateDeviceInfo *masterDevice;

/// 从机设备
@property (nonatomic, strong, nullable) JLTranslateDeviceInfo *slaveDevice;

/// 两路是否都已就绪
@property (nonatomic, readonly) BOOL isBothReady;

/// 配置主机
- (void)configureMaster:(JLTranslateDeviceInfo *)master;

/// 配置从机
- (void)configureSlave:(JLTranslateDeviceInfo *)slave;

/// 标记主机就绪
- (void)markMasterReady:(BOOL)ready;

/// 标记从机就绪
- (void)markSlaveReady:(BOOL)ready;

/// 重置状态
- (void)reset;

@end

NS_ASSUME_NONNULL_END
