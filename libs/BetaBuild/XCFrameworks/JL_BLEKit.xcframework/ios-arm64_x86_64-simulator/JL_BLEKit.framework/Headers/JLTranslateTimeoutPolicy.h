//
//  JLTranslateTimeoutPolicy.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/6/18.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 同声翻译超时策略配置
@interface JLTranslateTimeoutPolicy : NSObject

/// 连接超时时间（默认10秒）
@property (nonatomic, assign) NSTimeInterval connectionTimeout;

/// 认证超时时间（默认5秒）
@property (nonatomic, assign) NSTimeInterval authenticationTimeout;

/// 命令响应超时时间（默认5秒）
@property (nonatomic, assign) NSTimeInterval commandResponseTimeout;

/// 数据传输超时时间（默认30秒）
@property (nonatomic, assign) NSTimeInterval dataTransferTimeout;

/// 模式切换超时时间（默认10秒）
@property (nonatomic, assign) NSTimeInterval modeSwitchTimeout;

/// TWS同步超时时间（默认5秒）
@property (nonatomic, assign) NSTimeInterval twsSyncTimeout;

/// 扫描从机超时时间（默认30秒）
@property (nonatomic, assign) NSTimeInterval scanSlaveTimeout;

/// TWS 恢复超时时间（默认10秒，退出同声翻译后等待设备重建TWS连接）
@property (nonatomic, assign) NSTimeInterval recoverTWSTimeout;

/// 重试次数（默认3次）
@property (nonatomic, assign) NSInteger retryCount;

/// 重试间隔（默认1秒）
@property (nonatomic, assign) NSTimeInterval retryInterval;

/// 默认策略
+ (instancetype)defaultPolicy;

/// 根据类型获取超时时间
- (NSTimeInterval)timeoutForType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
