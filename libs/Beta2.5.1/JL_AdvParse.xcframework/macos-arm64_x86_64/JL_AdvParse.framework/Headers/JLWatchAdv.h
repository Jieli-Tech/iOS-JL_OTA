//
//  JLWatchAdv.h
//  JL_AdvParse
//
//  Created by EzioChan on 2023/12/12.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <JL_AdvParse/JLDevicesAdv.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLWatchAdv : JLDevicesAdv

/// 经典蓝牙地址
@property(nonatomic, strong) NSString *edrAddr;

/// 连接方式
/// 0x00 ble
/// 0x01 spp
@property(nonatomic, assign) int8_t connectWay;


/// 手表状态
/// 0x00:经典蓝牙未连接
/// 0x01:经典蓝牙已连接 0x02:设备正在回连
/// 0x03:设备不可连接 (需要手动进入配对模式)
@property(nonatomic, assign) int8_t connectState;

/// 是否需要先连上 ble
@property(nonatomic, assign) BOOL priorityConnection;

@end

NS_ASSUME_NONNULL_END
