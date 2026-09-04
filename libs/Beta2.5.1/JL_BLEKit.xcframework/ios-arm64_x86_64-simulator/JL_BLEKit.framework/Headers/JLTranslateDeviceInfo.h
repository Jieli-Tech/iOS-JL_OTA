//
//  JLTranslateDeviceInfo.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/6/18.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JLTranslateTWSLocation) {
    JLTranslateTWSLocationUnknown = 0,
    JLTranslateTWSLocationLeft = 1,     // 左耳
    JLTranslateTWSLocationRight = 2     // 右耳
};

typedef NS_ENUM(NSInteger, JLTranslateTWSRole) {
    JLTranslateTWSRoleUnknown = 0,
    JLTranslateTWSRoleMaster = 1,       // 主机
    JLTranslateTWSRoleSlave = 2         // 从机
};

/// 同声翻译设备信息（主/从机）
@interface JLTranslateDeviceInfo : NSObject

/// 设备角色
@property (nonatomic, assign) JLTranslateTWSRole role;

/// 物理位置
@property (nonatomic, assign) JLTranslateTWSLocation location;

/// BLE 地址（6 bytes）
@property (nonatomic, copy, nullable) NSData *bleAddress;

/// 经典蓝牙地址（6 bytes）
@property (nonatomic, copy, nullable) NSData *classicAddress;

/// BLE 地址字符串
@property (nonatomic, copy, nullable) NSString *bleAddressString;

/// 连接方式（Cfg 解析）
/// 0: BLE, 1: SPP, 3: Gatt Over BR/EDR
@property (nonatomic, assign) NSInteger connectWay;

/// 从广播包解析出的设备是否可连接（status 字段）
@property (nonatomic, assign) BOOL isConnectable;

/// 设备 UUID（连接后生成）
@property (nonatomic, copy, nullable) NSString *uuid;

/// 设备名称
@property (nonatomic, copy, nullable) NSString *name;

/// CBPeripheral 对象（连接后设置）
@property (nonatomic, strong, nullable) CBPeripheral *peripheral;

/// RSSI
@property (nonatomic, strong, nullable) NSNumber *rssi;

/// VID
@property (nonatomic, assign) NSInteger vid;

/// UID
@property (nonatomic, assign) NSInteger uid;

/// PID
@property (nonatomic, assign) NSInteger pid;

/// 是否支持 BLE
@property (nonatomic, assign) BOOL supportBLE;

/// 广播包原始数据
@property (nonatomic, copy, nullable) NSData *advertisementData;

/// 是否已连接
@property (nonatomic, assign, readonly) BOOL isConnected;

/// 从 JLTranslationManager 中持有的主设备 manager
@property (nonatomic, strong, nullable) NSObject *manager;

/// 通过广播数据初始化
+ (nullable JLTranslateDeviceInfo *)deviceWithAdvertisement:(NSDictionary<NSString *, id> *)advertisementData rssi:(NSNumber *)rssi;

/// 从 TWS 状态数据解析从机信息
+ (nullable JLTranslateDeviceInfo *)slaveDeviceWithTwsData:(NSData *)data;

/// BLE 地址字符串转换
+ (nullable NSString *)stringFromAddress:(nullable NSData *)address;

- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
