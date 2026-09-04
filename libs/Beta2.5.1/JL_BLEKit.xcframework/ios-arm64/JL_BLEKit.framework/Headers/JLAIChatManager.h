//
//  JLAIChatManager.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/9/2.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_TypeEnum.h>

NS_ASSUME_NONNULL_BEGIN

@class JL_ManagerM;
@class JLAIChatManager;
@class JLAIChatConfig;

/// AI 对话模式
typedef NS_ENUM(UInt8, JLAIChatMode) {
    /// 单轮对话
    JLAIChatModeSingle         = 0,
    /// 连续对话
    JLAIChatModeContinuous     = 1,
};

/// AI 对话状态
typedef NS_ENUM(UInt8, JLAIChatState) {
    /// 空闲（已退出对话流程）
    JLAIChatStateIdle          = 0,
    /// 等待用户说话
    JLAIChatStateWaiting       = 1,
    /// 正在拾音（设备采麦，App 侧应暂停本地播报）
    JLAIChatStateRecording     = 2,
    /// 正在处理（接收文本数据）
    JLAIChatStateProcessing    = 3,
    /// 正在上传（大文件，例如图片）
    JLAIChatStateUploading     = 4,
    /// 正在播报（接收语音播报数据）
    JLAIChatStatePlaying       = 5,
    /// 正在拍照
    JLAIChatStateCapturing     = 6,
};

/// AI 对话退出原因
typedef NS_ENUM(UInt8, JLAIChatExitReason) {
    /// 主动退出
    JLAIChatExitReasonManual     = 0x00,
    /// 超时退出
    JLAIChatExitReasonTimeout    = 0x01,
    /// 录音失败
    JLAIChatExitReasonRecordFail = 0x02,
    /// 资源缺失
    JLAIChatExitReasonNoResource = 0x03,
    /// 网络异常
    JLAIChatExitReasonNetwork    = 0x04,
    /// 鉴权失败
    JLAIChatExitReasonAuth       = 0x05,
    /// 云服务错误
    JLAIChatExitReasonCloud      = 0x06,
};

/// 传输操作行为
typedef NS_ENUM(UInt8, JLAIChatAction) {
    /// 传输大数据
    JLAIChatActionTransferData = 1,
    /// 传输大文件
    JLAIChatActionTransferFile = 2,
};

/// AI 对话代理回调
@protocol JLAIChatManagerDelegate <NSObject>

/// 设备请求进入 AI 对话模式（收到后须调用 replyEnterMode 回复）
/// @param mgr 管理器
/// @param mode 设备请求的对话模式
/// @param config 设备请求的对话配置
- (void)aiChatManager:(JLAIChatManager *)mgr
didRequestEnterWithMode:(JLAIChatMode)mode
               config:(JLAIChatConfig *)config;

/// 设备请求退出 AI 对话模式（收到后须调用 replyExitMode 回复）
/// @param mgr 管理器
/// @param reason 退出原因
- (void)aiChatManager:(JLAIChatManager *)mgr
 didRequestExitWithReason:(JLAIChatExitReason)reason;

/// 对话状态变化通报
/// @param mgr 管理器
/// @param state 当前状态
/// @param mode 当前对话模式
- (void)aiChatManager:(JLAIChatManager *)mgr
      didChangeState:(JLAIChatState)state
                mode:(JLAIChatMode)mode;

@end

/// AI 对话管理器（对话模式进入/退出协商、状态通报、传输操作通知）
@interface JLAIChatManager : NSObject

/// 代理
@property (nonatomic, weak) id<JLAIChatManagerDelegate> delegate;

/// 当前缓存的状态
@property (nonatomic, assign, readonly) JLAIChatState currentState;

/// 当前缓存的对话模式
@property (nonatomic, assign, readonly) JLAIChatMode currentMode;

/// 协商生效的对话配置（进入模式后更新）
@property (nonatomic, strong, readonly, nullable) JLAIChatConfig *effectiveConfig;

/// 复位本地状态（断开连接时调用）
- (void)resetState;

/// 查询设备当前对话状态
/// @param manager 设备对象
/// @param result 回调（成功时携带当前模式与状态）
- (void)chatGetState:(JL_ManagerM *)manager
              result:(void(^)(JL_CMDStatus status, JLAIChatMode mode, JLAIChatState state))result;

/// 主动退出 AI 对话模式
/// @param manager 设备对象
/// @param result 回调
- (void)chatExit:(JL_ManagerM *)manager
          result:(nullable JL_CMD_RESPOND)result;

/// 回复设备进入对话模式的请求（在 didRequestEnterWithMode:config: 后调用）
/// @param manager 设备对象
/// @param accept 是否接受
/// @param cfg 接受时回传的对话配置
/// @param result 回调
- (void)replyEnterMode:(JL_ManagerM *)manager
                accept:(BOOL)accept
                config:(nullable JLAIChatConfig *)cfg
                result:(nullable JL_CMD_RESPOND)result;

/// 回复设备退出对话模式的请求（在 didRequestExitWithReason: 后调用）
/// @param manager 设备对象
/// @param result 回调
- (void)replyExitMode:(JL_ManagerM *)manager
               result:(nullable JL_CMD_RESPOND)result;

/// 通知操作状态（包裹大数据/大文件传输的起止，须成对调用）
/// @param action 传输行为
/// @param start YES 开始 / NO 结束
/// @param manager 设备对象
/// @param result 回调
- (void)notifyTransferAction:(JLAIChatAction)action
                       start:(BOOL)start
                     manager:(JL_ManagerM *)manager
                      result:(nullable JL_CMD_RESPOND)result;

@end

/// AI 对话配置（进入对话模式时双方协商）
@interface JLAIChatConfig : NSObject

/// 是否需要下发识别文本信息
@property (nonatomic, assign) BOOL needAsrText;

/// 是否需要下发应答文本信息
@property (nonatomic, assign) BOOL needAnswerText;

/// 是否需要应答语音播报
@property (nonatomic, assign) BOOL needTTS;

/// 语音播报播放方式：YES 设备播放 / NO App 本地播放
@property (nonatomic, assign) BOOL ttsToDevice;

/// 原始配置值
@property (nonatomic, assign, readonly) uint8_t rawValue;

/// 从原始字节解析
+ (nullable JLAIChatConfig *)configWithRawValue:(uint8_t)raw;

/// 按各属性生成实例
+ (JLAIChatConfig *)configWithAsrText:(BOOL)asrText
                           answerText:(BOOL)answerText
                               needTTS:(BOOL)needTTS
                          ttsToDevice:(BOOL)ttsToDevice;

@end

NS_ASSUME_NONNULL_END
