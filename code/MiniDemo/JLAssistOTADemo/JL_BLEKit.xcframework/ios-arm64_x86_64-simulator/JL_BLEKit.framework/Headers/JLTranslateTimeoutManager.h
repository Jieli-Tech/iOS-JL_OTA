//
//  JLTranslateTimeoutManager.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/6/18.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLTranslateTimeoutPolicy.h"
#import <JL_BLEKit/JLEcTimerHelper.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JLTranslateTimeoutType) {
    JLTranslateTimeoutTypeConnection = 0,      // 连接超时
    JLTranslateTimeoutTypeAuthentication,      // 认证超时
    JLTranslateTimeoutTypeCommandResponse,     // 命令响应超时
    JLTranslateTimeoutTypeDataTransfer,        // 数据传输超时
    JLTranslateTimeoutTypeModeSwitch,          // 模式切换超时
    JLTranslateTimeoutTypeTWSSync,             // TWS同步超时
    JLTranslateTimeoutTypeScanSlave,           // 扫描从机超时
    JLTranslateTimeoutTypeRecoverTWS           // TWS恢复超时（退出同声翻译后等待设备重建TWS）
};

@interface JLTranslateTimeoutManager : NSObject

/// 当前超时策略
@property (nonatomic, strong) JLTranslateTimeoutPolicy *policy;

+ (instancetype)sharedManager;

/// 使用自定义策略初始化
- (instancetype)initWithPolicy:(JLTranslateTimeoutPolicy *)policy;

/// 开始超时任务，返回 timerID
- (NSString *)startTimeoutTask:(JLTranslateTimeoutType)type
                    identifier:(NSString *)identifier
                      callback:(void(^)(NSString *timerID))callback;

/// 取消超时任务
- (void)cancelTimeoutTask:(NSString *)timerID;

/// 取消指定标识的所有超时任务
- (void)cancelTasksWithIdentifier:(NSString *)identifier;

/// 重置超时任务（重新开始计时）
- (void)resetTimeoutTask:(NSString *)timerID;

/// 取消所有超时任务
- (void)cancelAllTasks;

@end

NS_ASSUME_NONNULL_END
