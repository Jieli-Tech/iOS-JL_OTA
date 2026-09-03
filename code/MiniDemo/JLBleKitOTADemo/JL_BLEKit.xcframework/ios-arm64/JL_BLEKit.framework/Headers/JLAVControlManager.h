//
//  JLAVControlManager.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/7/16.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_FileManager.h>
#import <JL_BLEKit/JLAVRecordStatus.h>
#import <JL_BLEKit/JLAVRecordConfig.h>

@class JL_ManagerM;
@class JLAVRecordStatus;

/// 同步录像/录音状态回调
/// @param status 命令状态
/// @param recordStatus 设备当前录像/录音状态，解析失败为 nil
typedef void(^JLAVSyncStatusBlock)(JL_CMDStatus status, JLAVRecordStatus *_Nullable recordStatus);

NS_ASSUME_NONNULL_BEGIN

// ==================== Protocol ====================

@class JLAVControlManager;
@class JLAVCaptureModel;
@class JLAVRecordConfigItem;

/// 音视频控制回调协议
/// 所有方法均为 @optional，按需实现
@protocol JLAVControlProtocol <NSObject>
@optional

#pragma mark - 拍照

/// 收到设备推送的资源信息（拍照或录像完成后触发）
/// @param mgr  管理器实例
/// @param model 资源信息，包含文件路径、簇号、存储句柄等，可用于后续文件读取
-(void)avControlManager:(JLAVControlManager *)mgr didReceiveResourceInfo:(JLAVCaptureModel *)model;

/// 设备端主动发起拍照请求，SDK 需决定是否接受
/// @param mgr       管理器实例
/// @param opSN      命令序列号（回复时需原样传回 replyCaptureResponseWithOpSN:result:）
/// @param sessionId 设备分配的会话 ID
-(void)avControlManager:(JLAVControlManager *)mgr didReceiveCaptureRequestFromDevice:(uint8_t)opSN sessionId:(uint8_t)sessionId;

#pragma mark - 录像

/// 录像状态变化通知（开始 / 暂停 / 停止）
/// @param mgr    管理器实例
/// @param status 状态信息，包含 sessionId、录像状态、已录制时长
-(void)avControlManager:(JLAVControlManager *)mgr videoRecordStatusChanged:(JLAVRecordStatus *)status;

#pragma mark - 录音

/// 录音状态变化通知（开始 / 停止）
/// @param mgr    管理器实例
/// @param status 状态信息，包含 sessionId、录音状态、已录制时长
-(void)avControlManager:(JLAVControlManager *)mgr audioRecordStatusChanged:(JLAVRecordStatus *)status;

#pragma mark - 大文件传输

/// 文件读回进度回调
/// @param mgr      管理器实例
/// @param model    关联的资源信息（与 didReceiveResourceInfo: 中的 model 为同一对象）
/// @param result   读取状态（开始 / 进行中 / 完成 / 失败 / 取消）
/// @param size     文件总大小（字节）
/// @param data     当前分块数据（result 为 End 时是完整的累积数据）
/// @param progress 进度 0.0 ~ 1.0
-(void)avControlManager:(JLAVControlManager *)mgr
 fileReadWithResourceInfo:(JLAVCaptureModel *)model
                  result:(JL_FileContentResult)result
                    size:(uint32_t)size
                    data:(nullable NSData *)data
                progress:(float)progress;

@end

// ==================== Manager ====================

/// 音视频控制管理器
/// 支持拍照、录像配置/控制、录音配置/控制，以及拍照/录像后的大文件回读
///
/// @code
/// JLAVControlManager *av = [[JLAVControlManager alloc] initWithManager:manager];
/// av.delegate = self;
/// [av capturePhotoWithSessionId:1 deviceNumber:nil callBack:^(JL_CMDStatus s, uint8_t sn, NSData *d) { ... }];
/// @endcode
@interface JLAVControlManager : NSObject

/// 回调代理
@property(nonatomic,weak)id<JLAVControlProtocol> delegate;

#pragma mark - 初始化

/// 初始化并绑定设备管理器
/// @param manager 设备的管理器实例（JL_ManagerM），创建后不可更换；如需切换设备需重新创建 JLAVControlManager
-(instancetype)initWithManager:(JL_ManagerM *)manager;

#pragma mark - 拍照

/// SDK 主动触发拍照
/// @param sessionId    会话 ID（0~255），用于关联后续的资源信息通知
/// @param deviceNumber 摄像头编号（nil 表示不指定），多摄像头设备可选
/// @param callBack     命令发送结果回调，仅表示指令是否成功送达，拍照结果通过 didReceiveResourceInfo: 获取
-(void)capturePhotoWithSessionId:(uint8_t)sessionId
                    deviceNumber:(nullable NSNumber *)deviceNumber
                        callBack:(JL_CMD_RESPOND)callBack;

/// 回复设备主动发起的拍照请求
/// @param opSN   设备请求中的命令序列号（从 didReceiveCaptureRequestFromDevice:sessionId: 中获取）
/// @param result 结果码，0x00 表示接受请求
-(void)replyCaptureResponseWithOpSN:(uint8_t)opSN result:(uint8_t)result;

#pragma mark - 录像配置

/// 读取设备当前的录像配置
/// @param callBack 命令结果回调
-(void)getVideoRecordConfigWithCallBack:(JL_CMD_RESPOND)callBack;

/// 设置录像配置
/// @param config 录像配置对象
/// @param callBack 命令结果回调
-(void)setVideoRecordConfig:(JLAVVideoRecordConfig *)config callBack:(JL_CMD_RESPOND)callBack;

#pragma mark - 录像控制

/// 开始录像
/// @param sessionId    会话 ID（0~255），用于关联后续的状态通知和资源信息
/// @param deviceNumber 摄像头编号（nil 表示不指定）
/// @param callBack     命令结果回调
-(void)startVideoRecordWithSessionId:(uint8_t)sessionId deviceNumber:(nullable NSNumber *)deviceNumber callBack:(JL_CMD_RESPOND)callBack;

/// 停止录像
/// @param sessionId 对应开始录像时的会话 ID
/// @param reason    停止原因（主动停止 / 超时 / 存储器下线 / IO 异常）
/// @param callBack  命令结果回调
-(void)stopVideoRecordWithSessionId:(uint8_t)sessionId reason:(JLAVRecordStopReason)reason callBack:(JL_CMD_RESPOND)callBack;

/// 暂停录像
/// @param sessionId 对应开始录像时的会话 ID
/// @param callBack  命令结果回调
-(void)pauseVideoRecordWithSessionId:(uint8_t)sessionId callBack:(JL_CMD_RESPOND)callBack;

/// 同步录像状态
/// @param callBack 回调，成功时携带录像状态
-(void)syncVideoRecordStatusWithCallBack:(JLAVSyncStatusBlock)callBack;

#pragma mark - 录音配置

/// 读取设备当前的录音配置
/// @param callBack 命令结果回调
-(void)getAudioRecordConfigWithCallBack:(JL_CMD_RESPOND)callBack;

/// 设置录音配置
/// @param config 录音配置对象
/// @param callBack 命令结果回调
-(void)setAudioRecordConfig:(JLAVAudioRecordConfig *)config callBack:(JL_CMD_RESPOND)callBack;

#pragma mark - 录音控制

/// 开始设备端录音
/// @param sessionId    会话 ID（0~255），用于关联后续的状态通知
/// @param deviceNumber 麦克风编号（nil 表示不指定）
/// @param callBack     命令结果回调
-(void)startAudioRecordWithSessionId:(uint8_t)sessionId deviceNumber:(nullable NSNumber *)deviceNumber callBack:(JL_CMD_RESPOND)callBack;

/// 停止设备端录音
/// @param sessionId 对应开始录音时的会话 ID
/// @param reason    停止原因（主动停止 / 超时 / 存储器下线 / IO 异常）
/// @param callBack  命令结果回调
-(void)stopAudioRecordWithSessionId:(uint8_t)sessionId reason:(JLAVRecordStopReason)reason callBack:(JL_CMD_RESPOND)callBack;

/// 同步录音状态
/// @param callBack 回调，成功时携带录音状态
-(void)syncAudioRecordStatusWithCallBack:(JLAVSyncStatusBlock)callBack;

#pragma mark - 大文件传输

/// 根据资源信息读回设备文件
/// @discussion 内部自动完成存储句柄匹配 → 设置传输句柄 → 簇号读取的全流程
///             应在收到 didReceiveResourceInfo: 回调后，按需调用此方法
///             进度和结果通过 fileReadWithResourceInfo:result:size:data:progress: 回调
/// @param model  资源信息对象（从 didReceiveResourceInfo: 中获取）
/// @param result 文件读取进度回调
-(void)readFileWithResourceInfo:(JLAVCaptureModel *)model result:(JL_FILE_CONTENT_BK)result;

/// 取消当前正在进行的文件读取
-(void)cancelFileRead;

@end

NS_ASSUME_NONNULL_END
