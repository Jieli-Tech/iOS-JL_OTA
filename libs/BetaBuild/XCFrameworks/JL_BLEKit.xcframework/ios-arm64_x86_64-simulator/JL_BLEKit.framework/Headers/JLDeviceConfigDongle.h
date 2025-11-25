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
@property (nonatomic, assign) BOOL isSupportAuracast;
/// 是否支持接收Auracast
@property (nonatomic, assign) BOOL isSupportReceiveAuracast;
/// 是否支持发射端 Auracast
@property (nonatomic, assign) BOOL isSupportLancerAuracast;

@end

NS_ASSUME_NONNULL_END
