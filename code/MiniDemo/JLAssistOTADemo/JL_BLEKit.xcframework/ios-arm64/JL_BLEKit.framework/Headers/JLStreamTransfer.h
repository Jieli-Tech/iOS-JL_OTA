//
//  JLStreamTransfer.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/4/10.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_BLEKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JLStreamTransfer;
@class JLStreamDataModel;
@class JLStreamErrorReportModel;
@class JLStreamGetInfoModel;
@class JLStreamGetInfoResponseModel;
@class JLStreamStartTransferModel;
@class JLStreamStartResponseModel;
@class JLStreamStopTransferModel;
@class JLStreamPeripheralRequestModel;

typedef void(^JLStreamTransferErrorBlock)(JL_CMDStatus status);
typedef void(^JLStreamGetInfoBlock)(JL_CMDStatus status, JLStreamGetInfoResponseModel * _Nullable response);
typedef void(^JLStreamStartTransferBlock)(JL_CMDStatus status, JLStreamStartResponseModel * _Nullable response);
typedef void(^JLStreamStopTransferBlock)(JL_CMDStatus status);

@protocol JLStreamTransferDelegate <NSObject>

@optional
/// 接收到完整的流媒体一帧数据
/// - Parameters:
///   - transfer: 传输对象
///   - dataModel: 完整组包后的数据
///   - peripheral: 对应的外设信息模型
- (void)streamTransfer:(JLStreamTransfer *)transfer didRecevieCompleteModel:(JLStreamDataModel *)dataModel peripheral:(JLStreamPeripheralResponseModel *)peripheral;

/// 接收流媒体数据异常
/// - Parameters:
///   - transfer: 传输对象
///   - error: 错误信息
- (void)streamTransfer:(JLStreamTransfer *)transfer didRecevieError:(NSError *)error;

/// 接收到设备端主动发起的开启流媒体传输请求
/// 上层应用收到此回调后，应准备并开始按照请求的要求向设备端推流
/// - Parameters:
///   - transfer: transfer manager
///   - request: 设备端请求模型 (包含期望MTU和请求的外设列表)
- (void)streamTransfer:(JLStreamTransfer *)transfer didReceiveStartTransferRequest:(JLStreamStartTransferModel *)request;

/// 接收到设备端主动发起的停止流媒体传输请求
/// 上层应用收到此回调后，应停止推流。若设备端停止了所有 index，底层的相关缓存也会自动清理
/// - Parameters:
///   - transfer: transfer manager
///   - request: 设备端请求停止的模型 (包含需要停止的 peripheral index)
- (void)streamTransfer:(JLStreamTransfer *)transfer didReceiveStopTransferRequest:(JLStreamStopTransferModel *)request;

/// 接收到设备端主动下发的异常报告
/// 上层应用收到此回调后，必须抛弃当前正在传输的整个流媒体帧，并从下一帧全新数据开始继续传输
/// - Parameters:
///   - transfer: transfer manager
///   - report: 异常报告模型 (包含异常的 index, seq, reason)
- (void)streamTransfer:(JLStreamTransfer *)transfer didReceiveErrorReport:(JLStreamErrorReportModel *)report;

/// 一帧流媒体数据的所有分包已全部发送完毕
/// - Parameters:
///   - transfer: transfer manager
///   - seq: 帧序号
///   - index: 外设自增序号
- (void)streamTransfer:(JLStreamTransfer *)transfer didSendFrameWithSeq:(uint16_t)seq index:(uint8_t)index;

@end

/// 流媒体传输管理
@interface JLStreamTransfer : NSObject

@property(nonatomic,weak)id<JLStreamTransferDelegate> delegate;

/// 当前生效的流媒体传输请求 (包含了协商的MTU、外设等信息)
/// 无论是 App 端主动发起，还是设备端主动发起，只要成功，都会记录在此
@property(nonatomic, strong, readonly, nullable) JLStreamStartTransferModel *currentStartRequest;

/// 是否正在推送流媒体数据到设备端
@property (nonatomic, assign, readonly) BOOL isPushingStream;

/// 当前生效的推送流媒体请求 (dir=1)
@property (nonatomic, strong, readonly, nullable) JLStreamStartTransferModel *currentPushRequest;

-(instancetype)initWithManager:(JL_ManagerM *)manager;

/// 发送流数据异常报告
/// - Parameters:
///   - model: 异常报告数据模型 (包含 index, seq, reason 等信息)
///   - Result: 回复
- (void)reportErrorWithModel:(JLStreamErrorReportModel *)model Result:(JLStreamTransferErrorBlock)Result;

/// 获取设备在线外设信息
/// - Parameters:
///   - Result: 回复外设信息列表
- (void)getInfoWithResult:(JLStreamGetInfoBlock)Result;

/// 开始传输流媒体数据 (接收方向，dir=0)
/// - Parameters:
///   - model: 开始传输请求模型 (包含期望MTU及请求的外设列表)
///   - Result: 回复协商的MTU及开启状态
- (void)startTransferWithModel:(JLStreamStartTransferModel *)model Result:(JLStreamStartTransferBlock)Result;

/// 开始推送流媒体数据到设备端 (推送方向，dir=1)
/// 内部会将 model.dir 自动设置为 1
/// - Parameters:
///   - model: 推送请求模型 (包含期望MTU及请求的外设列表)
///   - Result: 回复协商的MTU及开启状态
- (void)startPushStreamWithModel:(JLStreamStartTransferModel *)model Result:(JLStreamStartTransferBlock)Result;

/// 停止传输流媒体数据
/// - Parameters:
///   - model: 停止传输请求模型 (包含需要停止的外设index列表)
///   - Result: 回复状态
- (void)stopTransferWithModels:(NSArray <JLStreamPeripheralRequestModel*>*)models Result:(JLStreamStopTransferBlock)Result;

/// 停止推送流媒体数据
/// - Parameters:
///   - indices: 需要停止推送的外设 index 列表
///   - Result: 回复状态
- (void)stopPushStreamWithIndices:(NSArray<NSNumber *> *)indices Result:(JLStreamStopTransferBlock)Result;

/// 推送一帧流媒体数据到设备端 (使用默认外设)
/// 调用前需确保已通过 startPushStreamWithModel: 成功建立推送会话
/// 内部会自动构建 JLStreamDataModel 并管理 seq、index、timestamp、dataType 等字段
/// 对于 JPEG 数据，内部会自动管理 header 的发送状态（第一帧带头，后续帧只发主体）
/// 使用当前推送会话中的第一个外设作为目标
/// - Parameters:
///   - streamData: 流媒体数据 (如 JPEG、H264 等)
///   - error: 错误信息 (当前无推送会话时返回错误)
/// - Returns: YES 成功入队，NO 失败
- (BOOL)pushStreamData:(NSData *)streamData error:(NSError **)error;

/// 推送一帧流媒体数据到设备端 (指定外设)
/// 调用前需确保已通过 startPushStreamWithModel: 成功建立推送会话
/// 内部会自动构建 JLStreamDataModel 并管理 seq、timestamp、dataType 等字段
/// 对于 JPEG 数据，内部会自动管理 header 的发送状态（第一帧带头，后续帧只发主体）
/// 这里要注意如果第一帧发送完之前出现丢帧重发的情况要注意带上头
/// - Parameters:
///   - streamData: 流媒体数据 (如 JPEG、H264 等)
///   - index: 外设自增序号 (标识推送到哪个外设，与 startPushStreamWithModel: 中设置的 index 对应)
///   - error: 错误信息 (当前无推送会话时返回错误)
/// - Returns: YES 成功入队，NO 失败
- (BOOL)pushStreamData:(NSData *)streamData index:(uint8_t)index error:(NSError **)error;

/// 设置指定外设的 JPEG 头数据（用于 JPEG 分帧发送优化）
/// 设置后，第一帧会发送完整 JPEG（头+主体），后续帧只发送主体（跳过 header）
/// 收到设备异常报告或停止推送后，会自动重置状态，下一帧会重新发送 header
/// 注意：header 数据需要上层提供，SDK 不负责从 JPEG 数据中提取
/// - Parameters:
///   - headerData: JPEG 头数据（从 SOI 0xFFD8 到 SOS 0xFFDA 之间的数据，包含 SOS 段）
///   - index: 外设自增序号
- (void)setJPEGHeaderData:(NSData *)headerData forIndex:(uint8_t)index;

@end

NS_ASSUME_NONNULL_END
