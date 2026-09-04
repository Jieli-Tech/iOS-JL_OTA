//
//  JLEarphoneAdv.h
//  JL_AdvParse
//
//  Created by EzioChan on 2023/12/12.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import "JLDevicesAdv.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLEarphoneAdv : JLDevicesAdv

/// 左耳电量
@property(nonatomic, assign) uint8_t batteryLeft;

/// 右耳电量
@property(nonatomic, assign) uint8_t batteryRight;

///左耳是否在充电中
@property(nonatomic, assign) BOOL isChargingLeft;

///右耳是否在充电中
@property(nonatomic, assign) BOOL isChargingRight;

/// 是否已配对
@property(nonatomic, assign) BOOL isParied;

/// 是否主机
@property(nonatomic, assign) BOOL isMaster;

/// 是否允许连接
@property(nonatomic, assign) BOOL enableConnect;

/// 耳机状态
///0x00:不显示弹窗
///0x01:经典蓝牙未连接
///0x02:经典蓝牙已连接
///0x03:设备正在回连
///0x04:设备不可连接 (需要手动进入配对模式)
@property(nonatomic, assign) uint8_t status;


@end

NS_ASSUME_NONNULL_END
