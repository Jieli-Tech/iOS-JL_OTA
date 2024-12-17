//
//  JL_SpeechAIttsHandler.h
//  JL_BLEKit
//
//  Created by EzioChan on 2023/7/22.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JLModel_SPEEX.h>
#import <JL_BLEKit/JL_BigDataManager.h>

NS_ASSUME_NONNULL_BEGIN

@class JL_ManagerM;
@protocol JL_SpeechAIttsHandlerDelegate <NSObject>

/// 设备回调ai云数据
/// - Parameters:
///   - manager: 设备
///   - aicloud: AI云数据对象
-(void)receiveDataFrom:(JL_ManagerM *)manager WithAiCloud:(JLSpeechAiCloud *)aicloud;

/// 设备返回tts合成数据
/// - Parameters:
///   - manager: 设备
///   - tts: tts数据对象
-(void)receiveDataFrom:(JL_ManagerM *)manager WithTTS:(JLSpeechTTSSynthesis *)tts;

@end

@interface JL_SpeechAIttsHandler : NSObject

@property(nonatomic,weak)id<JL_SpeechAIttsHandlerDelegate> delegate;


/// 初始化一个语音大数据传输实例
/// - Parameter mgr: JL_ManagerM
- (instancetype)initWithMgr:(JL_ManagerM *)mgr;

/// 发送tts语音合成信息
/// - Parameters:
///   - tts: tts语音对象内容
///   - manager: 设备
///   - result: 回调结果
-(void)speechSendTTs:(JLSpeechTTSSynthesis *)tts manager:(JL_ManagerM *)manager result:(JL_BIGDATA_RT)result;

/// 发送ai云数据到设备
/// - Parameters:
///   - cloud: ai云数据
///   - manager: 设备
///   - result: 回调结果
-(void)speechSendAiCloud:(JLSpeechAiCloud *)cloud manager:(JL_ManagerM *)manager result:(JL_BIGDATA_RT)result;

@end

NS_ASSUME_NONNULL_END
