//
//  JLDeviceConfigTws.h
//  JL_BLEKit
//
//  Created by EzioChan on 2024/1/23.
//  Copyright © 2024 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JLDeviceConfigFuncModel.h>

NS_ASSUME_NONNULL_BEGIN

/// TWS设备配置
@interface JLDeviceConfigTws : JLDeviceConfigBasic

/// 是否支持替换提示音
@property(nonatomic, assign)BOOL isSupportReplaceTipsVoice;

/// 是否支持语音翻译
/// Voice translation
@property(nonatomic,assign,readonly)BOOL isSupportTranslate;

/// 是否使用A2DP播放
/// 翻译耳机功能扩展
/// is use A2DP to play
@property(nonatomic,assign,readonly)BOOL isUseA2DP;

/// 是否支持Opus立体声
@property(nonatomic,assign,readonly)BOOL isSupportOpusStereo;

/// 是否支持耳机健康功能
/// is support ear health
@property(nonatomic,assign, readonly)BOOL isSupportHealthData;

/// 是否支持Auracast
@property (nonatomic, assign, readonly) BOOL isSupportAuracast;

/// 是否支持接收Auracast
@property (nonatomic, assign, readonly) BOOL isSupportReceiveAuracast;

/// 是否支持发射端 Auracast
@property (nonatomic, assign, readonly) BOOL isSupportLancerAuracast;

/// 是否支持心跳机制
@property (nonatomic, assign, readonly) BOOL isSupportHeartBeat;

/// 是否支持TWS
/// 说明设备支持TWS设备功能。
/// 包含设备名称，弹窗快连，按键设置，灯效设置、工作模式等功能；
@property (nonatomic, assign, readonly)BOOL isSupportTwsFunc;

/// 是否支持重命名
/// 设备是否支持修改设备名
@property (nonatomic, assign, readonly)BOOL isSupportRename;

@end

NS_ASSUME_NONNULL_END
