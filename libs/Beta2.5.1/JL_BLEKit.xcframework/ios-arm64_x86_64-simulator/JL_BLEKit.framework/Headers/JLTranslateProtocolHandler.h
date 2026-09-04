//
//  JLTranslateProtocolHandler.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/6/18.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLTranslateSetMode.h"
#import "JLTranslateAudio.h"

NS_ASSUME_NONNULL_BEGIN

@class JLTranslateProtocolHandler;

@protocol JLTranslateProtocolHandlerDelegate <NSObject>

@optional
/// 收到 TWS 状态通知
- (void)protocolHandler:(JLTranslateProtocolHandler *)handler didReceiveTWSState:(NSData *)data;

/// 收到从机角色信息
- (void)protocolHandler:(JLTranslateProtocolHandler *)handler didReceiveSlaveRole:(NSData *)data;

/// 收到从机音频数据
- (void)protocolHandler:(JLTranslateProtocolHandler *)handler didReceiveSlaveAudio:(JLTranslateAudio *)audio;

@end

/// 同声翻译协议处理器
/// 负责 0x8034 / 0x08 等 TWS 相关命令的打包与解析
@interface JLTranslateProtocolHandler : NSObject

@property (nonatomic, weak) id<JLTranslateProtocolHandlerDelegate> delegate;

/// 解析 TWS 状态数据，返回从机角色信息数据
- (nullable NSData *)parseTWSStateData:(NSData *)data;

/// 构建进入同声翻译模式的设置对象
- (JLTranslateSetMode *)buildSimultaneousModeWithDataType:(JL_SpeakDataType)dataType;

/// 解析从机返回的音频数据
- (nullable JLTranslateAudio *)parseSlaveAudioData:(NSData *)data sourceType:(JLTranslateAudioSourceType)sourceType;

@end

NS_ASSUME_NONNULL_END
