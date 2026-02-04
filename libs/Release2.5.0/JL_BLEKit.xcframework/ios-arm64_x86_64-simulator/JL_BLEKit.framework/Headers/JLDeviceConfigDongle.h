//
//  JLDeviceConfigDongle.h
//  JL_BLEKit
//
//  Created by EzioChan on 2025/11/17.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <JL_BLEKit/JL_BLEKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Auracast
@interface JLDeviceConfigDongle : JLDeviceConfigBasic
/// 是否支持Auracast
@property (nonatomic, assign, readonly) BOOL isSupportAuracast;
/// 是否支持接收Auracast
@property (nonatomic, assign, readonly) BOOL isSupportReceiveAuracast;
/// 是否支持发射端 Auracast
@property (nonatomic, assign, readonly) BOOL isSupportLancerAuracast;

/// 是否支持TWS
/// 说明设备支持TWS设备功能。
/// 包含设备名称，弹窗快连，按键设置，灯效设置、工作模式等功能；
@property (nonatomic, assign, readonly)BOOL isSupportTwsFunc;

/// 是否支持重命名
/// 设备是否支持修改设备名
@property (nonatomic, assign, readonly)BOOL isSupportRename;
@end

NS_ASSUME_NONNULL_END
