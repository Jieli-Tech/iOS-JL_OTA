//
//  JLTranslationManager.h
//  JL_BLEKit
//
//  Created by EzioChan on 2025/1/3.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JLTranslateAudio.h>
#import <JL_BLEKit/JLModel_SPEEX.h>
#import <JL_BLEKit/JLTranslateSetMode.h>
#import <JL_BLEKit/JLTranslateSet.h>

NS_ASSUME_NONNULL_BEGIN

@class JL_ManagerM;
@class JLTranslationManager;
@class JLTranslateDeviceInfo;
@class JLTranslateTimeoutPolicy;

/// 同声翻译回调
@protocol JLTranslationManagerSimultaneousDelegate <NSObject>

@optional
/// 同声翻译状态变更
- (void)translationManager:(JLTranslationManager *)manager simultaneousStateChanged:(NSInteger)state;

/// 从机设备已就绪
- (void)translationManager:(JLTranslationManager *)manager slaveDidReady:(JLTranslateDeviceInfo *)slave;

/// 从机设备断开
- (void)translationManager:(JLTranslationManager *)manager slaveDidDisconnect:(JLTranslateDeviceInfo *)slave error:(nullable NSError *)error;

/// 同声翻译发生错误
- (void)translationManager:(JLTranslationManager *)manager simultaneousDidFail:(NSError *)error;

/// 收到从机音频数据（同声翻译模式下）
/// @param manager 翻译管理器
/// @param audio 从机音频数据
- (void)translationManager:(JLTranslationManager *)manager didReceiveSlaveAudio:(JLTranslateAudio *)audio;

/// 从机录音状态变更（同声翻译模式）
/// @param manager 翻译管理器
/// @param status 录音状态（JL_SpeakTypeDo 开始 / JL_SpeakTypeDone 结束 / JL_SpeakTypeDoing 进行中）
- (void)translationManager:(JLTranslationManager *)manager didReceiveSlaveRecordStatus:(JL_SpeakType)status;

@end

/// 翻译回调
@protocol JLTranslationManagerDelegate <NSObject>

/// 初始化成功
/// @param uuid 设备UUID
-(void)onInitSuccess:(NSString *)uuid;

/// 模式改变
/// @param uuid 设备UUID
/// @param mode 翻译模式
-(void)onModeChange:(NSString *)uuid Mode:(JLTranslateSetMode *)mode;

/// 音频数据
/// @param uuid 设备UUID
/// @param data 音频数据
-(void)onReceiveAudioData:(NSString *)uuid AudioData:(JLTranslateAudio *)data;

/// 错误
/// @param uuid 设备UUID
/// @param err 错误
-(void)onError:(NSString *)uuid Error:(NSError *) err;

@optional

/// 通话状态
/// @param isCalling 是否在通话
/// @param uuid 设备UUID
-(void)isOnCalling:(BOOL)isCalling UUID:(NSString *)uuid;


/// 音频队列结束(或空闲/已结束/中间传输时短暂的播空了）
/// @param uuid 设备UUID
-(void)onSendAudioQueueOver:(NSString *)uuid;

/// 录音状态变更（主机 / 普通设备录音）
/// @param uuid 设备UUID
/// @param status 录音状态（JL_SpeakTypeDo 开始 / JL_SpeakTypeDone 结束 / JL_SpeakTypeDoing 进行中）
-(void)onReceiveRecordStatus:(NSString *)uuid Status:(JL_SpeakType)status;

@end

typedef void(^JLTranslationManagerGetBlock)(JLTranslateSetMode *_Nullable mode,NSError *_Nullable err);

typedef void(^JLTranslationManagerSetBlock)(JLTranslateSetResultType status,NSError *_Nullable err);

/// 翻译传输管理对象
/// Translation transmission management object
@interface JLTranslationManager : NSObject

/// 代理
@property (nonatomic, weak) id<JLTranslationManagerDelegate> delegate;

/// 同声翻译代理
@property (nonatomic, weak) id<JLTranslationManagerSimultaneousDelegate> simultaneousDelegate;

/// 命令最大超时时间
/// 默认是 10s
/// Command maximum timeout time
/// Default is 10s
@property (nonatomic, assign) NSTimeInterval cmdMaxTimeOut;



/// 设备蓝牙 UUID
/// Device Bluetooth UUID
@property (nonatomic, strong, readonly) NSString *uuid;

/// 当前的翻译模式
/// Current translation mode
@property (nonatomic, strong, readonly) JLTranslateSetMode *translateMode;

/// 录音策略，默认是手机端录音
/// Recording policy, the default is to record on the phone
@property (nonatomic, assign) JLTranslateRecordType recordtype;

/// 是否在通话中
/// Whether in a call
@property (nonatomic, assign) BOOL isCalling;

/// 最大MTU，默认是 200 最大不超过 MTU - 20 byte
/// Max MTU, the default is 200, which is not greater than MTU - 20 byte
@property (nonatomic, assign) NSInteger maxMtu;

/// 同声翻译从机连接配对密钥（16字节，对应 JL_Assist.mAuthKey）
/// 若设备认证已关闭，可置为 nil
@property (nonatomic, copy, nullable) NSData *simultaneousPairKey;

/// 同声翻译超时策略，默认 defaultPolicy
/// 进入模式前设置生效
@property (nonatomic, strong) JLTranslateTimeoutPolicy *simultaneousTimeoutPolicy;

/// 同声翻译主机设备信息（TWS 配对中角色为 Master 的设备，可用于判断左右耳位置）
@property (nonatomic, strong, readonly, nullable) JLTranslateDeviceInfo *masterDevice;

/// 同声翻译从机设备信息（TWS 配对中角色为 Slave 的设备，可用于判断左右耳位置）
@property (nonatomic, strong, readonly, nullable) JLTranslateDeviceInfo *slaveDevice;

/// 设备对象
/// Device object
@property (nonatomic, strong, readonly) JL_ManagerM *manager;

/// 初始化
/// init
/// - Parameters:
///   - delegate: 代理 JLTranslationManagerDelegate
///   - manager: 设备对象 DeviceManager
///   - result: 回调
- (instancetype)initWithDelegate:(id<JLTranslationManagerDelegate>)delegate Manager:(JL_ManagerM *)manager Result:(void(^)(BOOL success, NSError *_Nullable err))result;

/// 是否支持翻译功能
/// Does it support translation function
- (BOOL)trIsSupportTranslate;

/// 是否通过 a2dp 播放
/// Is it played through a2dp
- (BOOL)trIsPlayWithA2dp;


/// 是否正在工作
/// Is it working
- (BOOL)trIsWorking;

/// 获取当前翻译模式
/// Get the current translation mode
/// 回复的内容通过 JLTranslationManagerDelegate 代理回调
/// Reply content through JLTranslationManagerDelegate delegate
/// - Parameter block: 回调
- (void)trGetCurrentTranslationMode:(JLTranslationManagerGetBlock _Nullable)block;

/// 开始翻译模式
/// Start translation mode
/// - Parameter mode: 翻译模式 translation mode
/// - Parameter block: 回调
- (void)trStartTranslateMode:(JLTranslateSetMode *)mode Block:(JLTranslationManagerSetBlock _Nullable)block;

/// 退出翻译模式
/// Exit translation mode
/// - Parameter block: 回调
- (void)trExitMode:(JLTranslationManagerSetBlock _Nullable)block;

/// 写入翻译音频,翻译完/操作完后的音频需要携带原音频的音频类型 JLTranslateAudio 进行回复
/// Write in translation audio, translation complete/operation complete audio need to carry the original audio JLTranslateAudio reply
/// - Parameters:
///   - audio: JLTranslateAudio 原返回音频类型
///   - audioData: 处理完的音频数据
/// - Note: 同声翻译模式下，此方法默认将音频下发给主机；如需下发给从机，请使用 `trWriteAudioToSlave:TranslateData:`
- (void)trWriteAudio:(JLTranslateAudio *)audio TranslateData:(NSData *)audioData;

/// 同声翻译模式下，将翻译后的音频下发给从机
/// - Parameters:
///   - audio: 音频类型信息（audioType 等字段有效）
///   - audioData: 处理完的音频数据
- (void)trWriteAudioToSlave:(JLTranslateAudio *)audio TranslateData:(NSData *)audioData;


/// 写入翻译音频，翻译完/操作完后的音频需要携带原音频的音频类型 JLTranslateAudio 进行回复
/// 此方案是采取无交互式的下发方法，根据数据对应可能需要的播放时长来进行直接下发，可能存在风险
/// 当前默认的时长是 20ms 42 byte 的 jlv2 压缩数据，不支持修改
/// - Parameters:
///   - audio: JLTranslateAudio 原返回音频类型
///   - audioData: 处理完的音频数据
-(void)trWriteAudioV2:(JLTranslateAudio *)audio TranslateData:(NSData *)audioData;

/// 已准备好发送队列
-(void)trSendIsRelay;

/// 销毁
/// Destroy
/// 如果销毁，需要重新生成对象，此对象的回调将会失效
/// Destroy, if it is destroyed, the callback of this object will be invalidated
- (void)trDestory;

#pragma mark - 同声翻译模式

/// 是否支持同声翻译功能
- (BOOL)trIsSupportSimultaneousMode;

/// 进入同声翻译模式
/// - Parameter completion: 完成回调
- (void)trEnterSimultaneousMode:(void (^ _Nullable)(BOOL success, NSError *_Nullable error))completion;

/// 退出同声翻译模式
/// - Parameter completion: 完成回调
- (void)trExitSimultaneousMode:(void (^ _Nullable)(void))completion;

/// 暂停同声翻译
- (void)trPauseSimultaneousMode:(void (^ _Nullable)(BOOL success, NSError *_Nullable error))completion;

/// 恢复同声翻译
- (void)trResumeSimultaneousMode:(void (^ _Nullable)(BOOL success, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
