//
//  JLConnectWaySwitcher.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/4/15.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_BLEKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JL_ManagerM;

/// 通讯方式
typedef NS_ENUM(uint8_t, JLCommunicationMode) {
    /// BLE 连接
    JLCommunicationModeBle = 0,
    /// SPP 连接
    JLCommunicationModeSpp = 1,
    /// GATT Over BR/EDR 连接
    JLCommunicationModeGOE = 2,
};

/// 通讯方式切换
@interface JLConnectWaySwitcher : NSObject

/// 通讯方式切换
/// - Parameters:
///   - manager: 设备通讯对象
///   - mode: 通讯方式
///   - result: 结果
+(void)communicationWithManager:(JL_ManagerM*)manager Mode:(JLCommunicationMode)mode Result:(void(^)(BOOL ret))result;

@end

NS_ASSUME_NONNULL_END
