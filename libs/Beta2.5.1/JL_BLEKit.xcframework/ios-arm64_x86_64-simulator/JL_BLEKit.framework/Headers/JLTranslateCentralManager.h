//
//  JLTranslateCentralManager.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/6/18.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "JL_Assist.h"
#import "JL_ManagerM.h"
#import "JLTranslateDeviceInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class JLTranslateCentralManager;

@protocol JLTranslateCentralManagerDelegate <NSObject>

@optional
/// 发现从机设备
- (void)translateCentralManager:(JLTranslateCentralManager *)manager
              didDiscoverSlave:(JLTranslateDeviceInfo *)device;

/// 从机连接成功
- (void)translateCentralManager:(JLTranslateCentralManager *)manager
              didConnectSlave:(JLTranslateDeviceInfo *)device;

/// 从机断开连接
- (void)translateCentralManager:(JLTranslateCentralManager *)manager
           didDisconnectSlave:(JLTranslateDeviceInfo *)device
                         error:(nullable NSError *)error;

/// 从机连接失败
- (void)translateCentralManager:(JLTranslateCentralManager *)manager
        didFailToConnectSlave:(JLTranslateDeviceInfo *)device
                          error:(NSError *)error;

/// 从机设备信息获取完成（配对 + cmdTargetFeature + cmdGetSystemInfo 完成）
- (void)translateCentralManager:(JLTranslateCentralManager *)manager
                  didReadySlave:(JLTranslateDeviceInfo *)device;

/// BLE状态变更
- (void)translateCentralManager:(JLTranslateCentralManager *)manager
                 didUpdateState:(CBManagerState)state;

@end

/**
 * 翻译功能从机管理器
 * 内部基于 JL_Assist + JL_ManagerM 复用外部蓝牙管理模式
 */
@interface JLTranslateCentralManager : NSObject

@property (nonatomic, weak) id<JLTranslateCentralManagerDelegate> delegate;

/// 当前BLE状态
@property (nonatomic, readonly) CBManagerState state;

/// 是否正在扫描
@property (nonatomic, readonly) BOOL isScanning;

/// 已连接的从机设备列表
@property (nonatomic, readonly) NSArray<JLTranslateDeviceInfo *> *connectedSlaves;

/// 是否需要设备认证握手（默认 YES）
@property (nonatomic, assign) BOOL needPaired;

/// 标记为主动断开从机（设为 YES 后，从机 BLE 断开不会触发自动重连）
@property (nonatomic, assign) BOOL isIntentionallyDisconnecting;

+ (instancetype)sharedManager;

/// 配置服务UUID（应与主设备一致，默认 AE00/AE01/AE02）
- (void)configureServiceUUID:(NSString *)serviceUUID
                   writeChar:(NSString *)writeUUID
                    readChar:(NSString *)readUUID;

/// 配置设备认证密钥（16字节，对应 JL_Assist.mPairKey）
- (void)configurePairKey:(nullable NSData *)pairKey;

/// 开始扫描从机设备
- (void)startScanningForSlaves;

/// 停止扫描
- (void)stopScanning;

/// 连接从机设备（连接后自动完成配对、获取设备信息、获取系统功能）
- (void)connectSlave:(JLTranslateDeviceInfo *)slave;

/// 断开从机设备
- (void)disconnectSlave:(JLTranslateDeviceInfo *)slave;

/// 根据UUID获取已连接的从机
- (nullable JLTranslateDeviceInfo *)connectedSlaveForUUID:(NSString *)uuid;

/// 断开所有从机
- (void)disconnectAllSlaves;

/// 获取从机对应的 JL_ManagerM（用于后续命令交互）
- (nullable JL_ManagerM *)cmdManagerForSlave:(JLTranslateDeviceInfo *)slave;

/// 设置目标从机地址（广播包解析出的 BLE 地址字符串，用于扫描过滤）
/// - Parameter address: 形如 "AA:BB:CC:DD:EE:FF"
- (void)setTargetSlaveAddress:(nullable NSString *)address;

/// 重置内部状态（每次进入同声翻译模式时调用）
- (void)resetConfiguration;

@end

NS_ASSUME_NONNULL_END
