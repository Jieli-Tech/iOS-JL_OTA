//
//  JL_SoundCardManager.h
//  JL_BLEKit
//
//  Created by 李放 on 2021/12/20.
//  Modify by EzioChan on 2023/09/25.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_TypeEnum.h>
#import <JL_BLEKit/JL_Tools.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(uint8_t, JL_KalaoIndex) {
    ///卡拉OK 混响
    JL_KalaoIndexReverberation  = 0,
    ///卡拉OK 延时
    JL_KalaoIndexDelayed        = 1,
    ///卡拉OK 音量
    JL_KalaoIndexVolume         = 2,
};

@class JL_ManagerM;

/// 声卡功能
@interface JLSoundCardIndexValue : NSObject

@property (assign,nonatomic)uint8_t index;

@property (assign,nonatomic)uint16_t value;

@end

@protocol JLSoundCardMgrDelegate <NSObject>

/// 声卡控制回调
/// - Parameters:
///   - mask: 掩码
///   - items: 掩码对应的值
-(void)jlsoundCardMask:(uint64_t)mask values:(NSArray <JLSoundCardIndexValue *> *)items;

/// 声卡控制回调
/// - Parameter frequencyArray: 频率数组
-(void)jlsoundCardMicFrequency:(NSArray*)frequencyArray;

/// 声卡控制回调
/// - Parameter eqArray: EQ数组
-(void)jlsoundCardMicEQ:(NSArray*)eqArray;

@end


/// 卡拉OK（声卡控制相关）
@interface JL_SoundCardManager : NSObject

/// 卡拉OK 组件索引
@property (assign,nonatomic)long index;

/// 卡拉OK 组件的值
@property (assign,nonatomic)long value;

/// 卡拉OK 固件返回的掩码
@property (assign,nonatomic)uint64_t mask;

/// 声卡功能参数列表
@property (strong,nonatomic)NSArray <JLSoundCardIndexValue *>* iVitems;

/// 卡拉OK 频率数组
@property (strong,nonatomic)NSArray *micFrequencyArray;

/// 卡拉OK EQ数组
@property (strong,nonatomic)NSArray *micEQArray;

/// 代理
@property (weak,nonatomic)id<JLSoundCardMgrDelegate> delegate;

/// 设置卡拉OK【index、value】
/// - Parameters:
///  - manager: 设备对象
///  - index: index 参数类型 JL_KalaoIndex 目前支持混响、延时、音量的设置。（具体可以看固件的json文件）
///  - value:  0-100
///  - result: 设置结果
-(void)cmdSetKalaok:(JL_ManagerM *)manager Index:(JL_KalaoIndex)index Value:(uint16_t)value result:(JL_CMD_RESPOND)result;

/// 设置卡拉OK【MIC EQ增益】
/// - Parameters:
///  - manager: 设备对象
///  - array:  @[@(0),@(0),@(0),@(0),@(0)]  单个取值范围 [-8.0 , +8.0]。
///  - result: 设置结果
-(void)cmdSetKaraoke:(JL_ManagerM *)manager micEQ:(NSArray*)array result:(JL_CMD_RESPOND)result;

@end

NS_ASSUME_NONNULL_END
