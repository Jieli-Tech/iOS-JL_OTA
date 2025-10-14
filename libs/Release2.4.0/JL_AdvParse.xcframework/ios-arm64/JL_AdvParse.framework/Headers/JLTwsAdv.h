//
//  JLTwsAdv.h
//  JL_AdvParse
//
//  Created by EzioChan on 2023/12/12.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import "JLDevicesAdv.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLTwsAdv : JLDevicesAdv

//MARK: - Version 0

/// 经典蓝牙地址
@property(nonatomic, strong) NSString *edrAddr;

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

/// 加密 Hash 校验值
@property(nonatomic, copy) NSData *hashData;

//MARK: - Version 1
/// BLE连接属性(enableConnect)
@property(nonatomic, assign) BOOL bleEnable;

//MARK: - Version 2
/// 连接方式
/// 0x00 BLE 通迅
/// 0x01 SPP 通迅
@property(nonatomic, assign) uint8_t connectWay;

/// 是否支持智能充电仓
@property(nonatomic, assign) BOOL isSupportChargBox;

//MARK: - Version 3
/// 左耳电量为挂脖耳机电量!!!，其他耳机电量使用
@end

NS_ASSUME_NONNULL_END
