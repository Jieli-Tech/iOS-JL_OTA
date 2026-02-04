//
//  JLDevAudioManager.h
//  JL_BLEKit
//  Created by EzioChan on 2025/12/12.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_TypeEnum.h>
#import <JL_BLEKit/JL_Tools.h>
#import <JL_BLEKit/JLModel_SPEEX.h>

NS_ASSUME_NONNULL_BEGIN

@class JL_ManagerM;
@class JLDevAudioManager;

@protocol JLDevAudioManagerDelegate <NSObject>
 /// 录音数据回调
 /// - Parameters:
 ///   - manager: 操作设备
 ///   - data: 数据
 - (void)devAudioManager:(JLDevAudioManager *)manager Audio:(NSData *)data;

 /// 设备端开始录音
 /// - Parameters:
 ///   - manager: 操作设备
 ///   - param: 录音参数
 - (void)devAudioManager:(JLDevAudioManager *)manager StartByDeviceWithParam:(JLRecordParams *)param;

 /// 设备端结束录音
 /// - Parameters:
 ///   - manager: 操作设备
 ///   - param: 语音助手配置参数
 - (void)devAudioManager:(JLDevAudioManager *)manager StopByDeviceWithParam:(JLSpeechRecognition *)param;

 /// 录音状态回调
 /// - Parameters:
 ///   - manager: 操作设备
 ///   - status: 状态
 - (void)devAudioManager:(JLDevAudioManager *)manager Status:(JL_SpeakType)status;

@end

/// 设备录音管理对象（新）
/// 对外接口与旧类一致，仅更换类名，内部转发至 JL_SpeexManager
@interface JLDevAudioManager : NSObject

@property (nonatomic, weak) id<JLDevAudioManagerDelegate> delegate;

 /// 获取单例
 /// - Parameters:
 ///   - delegate: 代理
 ///   - manager: 操作设备
 /// - Returns: 录音管理对象实例
 + (JLDevAudioManager *)shareDevAudioManager:(id<JLDevAudioManagerDelegate>)delegate WithManager:(JL_ManagerM *)manager;

 /// 获取录音状态
 /// - Returns: 当前录音状态
 - (JL_SpeakType)cmdCheckRecordStatus;

 /// 开始录音
 /// - Parameters:
 ///   - manager: 操作设备
 ///   - params: 录音参数
 ///   - result: 命令操作结果回调
 - (void)cmdStartRecord:(JL_ManagerM *)manager Params:(JLRecordParams *)params Result:(JL_CMD_RESPOND __nullable)result;
 /// 停止录音
 /// - Parameters:
 ///   - manager: 操作设备
 ///   - reason: VAD类型
 ///   - result: 命令操作结果回调
 - (void)cmdStopRecord:(JL_ManagerM *)manager Reason:(JLSpeakDownReason)reason Result:(JL_CMD_RESPOND __nullable)result;
 /// 停止录音2
 /// - Parameters:
 ///   - manager: 操作设备
 ///   - reason: vad类型
 ///   - schr: 语音设置助手
 ///   - result: 回调结果
 - (void)cmdStopRecord:(JL_ManagerM *)manager Reason:(JLSpeakDownReason)reason SpeechHelper:(JLSpeechRecognition *)schr Result:(JL_CMD_RESPOND __nullable)result;

 /// 允许录音（设备端主动发起时的同意响应）
 /// 在收到设备主动发起录音的回调后调用，设备会播放提示音
 - (void)cmdAllowSpeak;
 /// 拒绝录音（设备端主动发起时的拒绝响应）
 /// 在收到设备主动发起录音的回调后调用，拒绝设备开始录音
 - (void)cmdRejectSpeak;

 /// 停止语音
 /// 发送命令给音箱，停止接收数据，即检测到断句
 - (void)cmdSpeakingDone __attribute__((deprecated("当前命令已失效，请使用cmdStopRecord:(JL_ManagerM *)manager Reason:(JLSpeakDownReason) reason")));

@end

NS_ASSUME_NONNULL_END
