//
//  JLBroadcastDataModel.h
//  JL_BLEKit
//
//  Created by EzioChan on 2025/11/17.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Auracast 广播数据模型
@interface JLBroadcastDataModel : NSObject

/// 广播名称
@property(nonatomic, copy) NSString *broadcastName;
/// 广播ID
@property(nonatomic, copy) NSData *broadcastID;
/// 广播特性
@property(nonatomic, assign) uint8_t features;
/// 是否加密
@property(nonatomic, assign) BOOL encrypted;
/// 广播地址
@property(nonatomic, copy) NSData *advertiserAddress;
/// 广播地址
@property(nonatomic, copy) NSString *advertiserAddressString;

/// 广播密钥
@property(nonatomic, copy) NSData *broadcastKey;

typedef NS_ENUM(uint8_t, JLBroadcastSyncState) {
    JLBroadcastSyncStateIdle = 0,
    JLBroadcastSyncStateSyncing = 1,
    JLBroadcastSyncStateSuccess = 2,
};
/// 同步状态
/// Broadcast sync state
/// 当此状态为空闲时，需要查看错误码检查是否存在错误
@property(nonatomic, assign) JLBroadcastSyncState syncState;

typedef NS_ENUM(uint8_t, JLBroadcastErrorCode) {
    JLBroadcastErrorCodeNone = 0x00,
    JLBroadcastErrorCodeName = 0x01,
    JLBroadcastErrorCodeAddress = 0x02,
    JLBroadcastErrorCodeID = 0x03,
    JLBroadcastErrorCodeKey = 0x04,
    JLBroadcastErrorCodeSyncFailed = 0x05,
    JLBroadcastErrorCodeSyncTimeout = 0x06,
    JLBroadcastErrorCodeSyncLost = 0x07,
};
/// 错误码
@property(nonatomic, assign) JLBroadcastErrorCode errorCode;


- (instancetype)initParseData:(NSData *)data;

- (void)updateParseData:(NSData *)data;

/// 将当前模型内容按 LTV 规则编码为数据
- (NSData *)toLTVData;

@end

NS_ASSUME_NONNULL_END
