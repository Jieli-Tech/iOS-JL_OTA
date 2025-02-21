//
//  JLeSimManager.h
//  JL_BLEKit
//
//  Created by EzioChan on 2023/12/4.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JL_ManagerM;

@protocol JLEsimFinishDelegate <NSObject>

/// 设备推送esim 信息内容
/// - Parameters:
///   - version: 版本
///   - data: 内容
-(void)jlEsimDidGetData:(uint8_t)version ESimData:(NSData *)data;

@end

typedef void(^JLESimFinishBlock)(NSError * _Nullable err);

/// esim 信息交互类
@interface JLeSimManager : NSObject

@property(nonatomic,assign)id<JLEsimFinishDelegate> delegate;

/// 下发 esim 信息到设备
/// - Parameters:
///   - mgr: 设备
///   - data: esim 信息
///   - block: 完成回调
-(void)sendToDev:(JL_ManagerM *)mgr Data:(NSData *)data Result:(JLESimFinishBlock)block;

@end

NS_ASSUME_NONNULL_END
