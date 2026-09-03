//
//  JLStreamDataPusher.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/5/27.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JLStreamDataModel.h>

NS_ASSUME_NONNULL_BEGIN

@class JL_ManagerM;
@class JLStreamDataPusher;

@protocol JLStreamDataPusherDelegate <NSObject>
/// 一帧数据的所有分包已全部发送完毕
/// 对于 JPEG 数据，如果 header 已发送完成，会返回 headerLength > 0
- (void)pusher:(JLStreamDataPusher *)pusher didSendFrameWithSeq:(uint16_t)seq index:(uint8_t)index headerLength:(uint32_t)headerLength;

@end

/// JPEG 分帧发送状态
@interface JLStreamJPEGState : NSObject
@property (nonatomic, assign) uint8_t index;                    // 外设序号
@property (nonatomic, assign) BOOL headerSent;                  // 是否已经发送过 JPEG 头
@property (nonatomic, assign) uint32_t headerLength;            // JPEG 头长度
@property (nonatomic, strong) NSData *headerData;               // JPEG 头数据缓存
@end

/// 流媒体数据推送管理器
/// 负责将完整数据帧按协商 MTU 分包，并通过 AE03 通道发送到设备端
/// 支持 JPEG 分帧发送：第一帧带头，后续帧只发主体（直到收到异常或停止）
@interface JLStreamDataPusher : NSObject

@property (nonatomic, weak) id<JLStreamDataPusherDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isPushing;
@property (nonatomic, assign, readonly) uint16_t negotiatedMtu;
@property (nonatomic, assign, readonly) uint8_t currentIndex;
@property (nonatomic, assign, readonly) uint16_t currentSeq;

- (instancetype)initWithManager:(JL_ManagerM *)manager mtu:(uint16_t)mtu;

/// 推送一帧流媒体数据 (非阻塞，在后台串行队列发送分包)
/// 对于 JPEG 数据，内部会自动管理 header 的发送状态
- (void)pushFrame:(JLStreamDataModel *)frame;

/// 设置指定外设的 JPEG 头数据（用于分帧发送）
/// 应在开始推送前调用，或在收到异常后重新设置
/// - Parameters:
///   - headerData: JPEG 头数据（通常是 SOI 到 SOS 之间的数据）
///   - index: 外设序号
- (void)setJPEGHeaderData:(NSData *)headerData forIndex:(uint8_t)index;

/// 设备端上报异常，抛弃当前正在发送的帧，从下一帧重新开始
/// 对于 JPEG 数据，会重置对应外设的 headerSent 状态，下一帧会重新发送 header
- (void)handleErrorReport:(JLStreamErrorReportModel *)report;

/// 停止推送并清理状态
- (void)stop;

/// 重置所有状态 (不清除队列中已入队的帧)
- (void)reset;

/// 重置指定外设的 JPEG 发送状态（收到异常或需要重新发送 header 时调用）
- (void)resetJPEGStateForIndex:(uint8_t)index;

@end

NS_ASSUME_NONNULL_END
