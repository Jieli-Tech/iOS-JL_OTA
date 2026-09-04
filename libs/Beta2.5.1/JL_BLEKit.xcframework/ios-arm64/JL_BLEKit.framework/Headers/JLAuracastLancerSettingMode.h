//
//  JLAuracastLancerSettingMode.h
//  JL_BLEKit
//
//  Created by EzioChan on 2025/11/17.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 音频格式
typedef NS_ENUM(UInt8, JLBroadcastSetAudioFormat) {
    /// 名称： 8_1
    /// 采样率(Hz)： 8000
    /// 帧间隔（us）：7500
    /// 包长（Byte）：26
    /// 码率（kbps）：27.732
    /// 重发次数 ：2
    /// 最大传输延时(ms) ：8
    /// 演示延时(ms) ：40
    JLBroadcastSetAudioFormat8_1 = 0x01,
    /// 名称： 8_2
    /// 采样率(Hz)： 8000
    /// 帧间隔（us）：10000
    /// 包长（Byte）：30
    /// 码率（kbps）：24
    /// 重发次数：2
    /// 最大传输延时(ms)：10
    /// 演示延时(ms)：40
    JLBroadcastSetAudioFormat8_2 = 0x02,
    /// 名称： 16_1_1
    /// 采样率(Hz)： 16000
    /// 帧间隔（us）：7500
    /// 包长（Byte）：30
    /// 码率（kbps）：32
    /// 重发次数：2
    /// 最大传输延时(ms)：8
    /// 演示延时(ms)：40
    JLBroadcastSetAudioFormat16_1_1 = 0x03,
    /// 名称： 16_2_1
    /// 采样率(Hz)： 16000
    /// 帧间隔（us）：10000
    /// 包长（Byte）：40
    /// 码率（kbps）：48
    /// 重发次数：2
    /// 最大传输延时(ms)：10
    /// 演示延时(ms)：40
    JLBroadcastSetAudioFormat16_2_1 = 0x04,
    /// 名称： 24_1_1
    /// 采样率(Hz)： 24000
    /// 帧间隔（us）：7500
    /// 包长（Byte）：45
    /// 码率（kbps）：48
    /// 重发次数：2
    /// 最大传输延时(ms)：8
    /// 演示延时(ms)：40
    JLBroadcastSetAudioFormat24_1_1 = 0x05,
    /// 名称： 24_2_1
    /// 采样率(Hz)： 24000
    /// 帧间隔（us）：10000
    /// 包长（Byte）：60
    /// 码率（kbps）：48
    /// 重发次数：2
    /// 最大传输延时(ms)：10
    /// 演示延时(ms)：40
    JLBroadcastSetAudioFormat24_2_1 = 0x06,
    /// 名称： 32_1_1
    /// 采样率(Hz)： 32000
    /// 帧间隔（us）：7500
    /// 包长（Byte）：60
    /// 码率（kbps）：64
    /// 重发次数：2
    /// 最大传输延时(ms)：8
    /// 演示延时(ms)：40
    JLBroadcastSetAudioFormat32_1_1 = 0x07,
    /// 名称： 32_2_1
    /// 采样率(Hz)： 32000
    /// 帧间隔（us）：10000
    /// 包长（Byte）：80
    /// 码率（kbps）：64
    /// 重发次数：2
    /// 最大传输延时(ms)：10
    /// 演示延时(ms)：40
    JLBroadcastSetAudioFormat32_2_1 = 0x08,
    /// 名称： 441_1_1
    /// 采样率(Hz)： 44100
    /// 帧间隔（us）：8163
    /// 包长（Byte）：97
    /// 码率（kbps）：95.06
    /// 重发次数：4
    /// 最大传输延时(ms)：24
    /// 演示延时(ms)：40
    JLBroadcastSetAudioFormat441_1_1 = 0x09,
    /// 名称： 441_2_1
    /// 采样率(Hz)： 44100
    /// 帧间隔（us）：10884
    /// 包长（Byte）：130
    /// 码率（kbps）：95.55
    /// 重发次数：4
    /// 最大传输延时(ms)：31
    /// 演示延时(ms)：40
    JLBroadcastSetAudioFormat441_2_1 = 0x0A,
    /// 名称： 48_1
    /// 采样率(Hz)： 48000
    /// 帧间隔（us）：7500
    /// 包长（Byte）：75
    /// 码率（kbps）：80
    /// 重发次数：4
    /// 最大传输延时(ms)：15
    /// 演示延时(ms)：40
    JLBroadcastSetAudioFormat48_1 = 0x0B,
    /// 名称： 48_2
    /// 采样率(Hz)： 48000
    /// 帧间隔（us）：10000
    /// 包长（Byte）：100
    /// 码率（kbps）：80
    /// 重发次数：4
    /// 最大传输延时(ms)：20
    /// 演示延时(ms)：40
    JLBroadcastSetAudioFormat48_2 = 0x0C
    
};
/**
 Auracast 发射端设置数据模型
 */
@interface JLAuracastLancerSettingMode : NSObject

/// 广播名称
@property(nonatomic, copy) NSString *broadcastName;
/// 音频格式
@property(nonatomic, assign) JLBroadcastSetAudioFormat audioFormatIndex;
/// 是否加密
@property(nonatomic, assign) BOOL encryptEnabled;
/// 广播加密密码
@property(nonatomic, copy) NSData * _Nullable broadcastCode;
/// 发射功率设置
@property(nonatomic, assign) uint8_t powerLevel;

-(instancetype)initParseData:(NSData *)data;

-(void)updateParseData:(NSData *)data;

-(NSData *)toLTVData;

@end

NS_ASSUME_NONNULL_END
