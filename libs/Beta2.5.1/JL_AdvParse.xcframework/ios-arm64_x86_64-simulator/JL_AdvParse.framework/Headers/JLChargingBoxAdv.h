//
//  JLChargingBoxAdv.h
//  JL_AdvParse
//
//  Created by EzioChan on 2023/12/12.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import "JLDevicesAdv.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLChargingBoxAdv : JLDevicesAdv

/// 经典蓝牙地址
@property(nonatomic, strong) NSString *edrAddr;

/// 是否已配对
@property(nonatomic, assign) BOOL isParied;

/// 是否已开盖
@property(nonatomic, assign) BOOL isOpen;

/// 耳机状态
///0x00:不显示弹窗
///0x01:经典蓝牙未连接
///0x02:经典蓝牙已连接
///0x03:设备正在回连
///0x04:设备不可连接 (需要手动进入配对模式)
@property(nonatomic, assign) uint8_t status;

/// 左耳电量
@property(nonatomic, assign) uint8_t batteryLeft;

/// 右耳电量
@property(nonatomic, assign) uint8_t batteryRight;

/// 充电仓电量
@property(nonatomic, assign) uint8_t batteryBox;

///左耳是否在充电中
@property(nonatomic, assign) BOOL isChargingLeft;

///右耳是否在充电中
@property(nonatomic, assign) BOOL isChargingRight;

///充电仓是否在充电中
@property(nonatomic, assign) BOOL isChargingBox;

/// seq
/// 用于区分是否同一次开机。每次开机或者断开连接后 增加1
@property(nonatomic, assign) uint8_t seq;

///模式
/// 0x00:充电模式
/// 0x01:发射模式
@property(nonatomic, assign) uint8_t mode;

/// 加密 Hash 校验值
@property(nonatomic, copy) NSData *hashData;

@end

NS_ASSUME_NONNULL_END
