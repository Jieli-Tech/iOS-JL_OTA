//
//  SDKBleHelper.h
//  JL_OTA
//
//  Created by EzioChan on 2022/10/12.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_BLEKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDKBleHelper : NSObject

/// 过滤扫描结果（SDK 路径）：
/// 返回的数组中，系统已连接（服务号 AE00）的设备会固定在列表首位；
/// 这类设备由 retrieveConnectedPeripheralsWithServices: 获取，不依赖广播。
+(NSMutableArray <JL_EntityM *>*)fitterHandle:(NSArray*)basicArray;

/// 扫描开始后主动通知一次“系统已连接设备”（沿用 kJL_BLE_M_FOUND 通知）。
/// 用于兼容：设备已被系统连接但停止广播，不会触发扫描发现回调的场景。
+(void)notifyConnectedPeripherals;

@end

NS_ASSUME_NONNULL_END
