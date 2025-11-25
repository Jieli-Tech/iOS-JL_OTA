//
//  JLAuracastManager.h
//  JL_BLEKit
//
//  Created by EzioChan on 2025/11/17.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_BLEKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JLBroadcastDataModel;
@class JLAuracastDevStateModel;
@class JLAuracastManager;

@protocol JLAuracastManagerDelegate <NSObject>
@optional

/// 搜索状态
/// - Parameters:
///   - mgr: 管理器
///   - state: 搜索状态
-(void)auracastManager:(JLAuracastManager *)mgr didUpdateSearchState:(BOOL)state;


/// 广播列表更新
/// - Parameters:
///   - mgr: 管理器
///   - list: 最新的广播数据列表
-(void)auracastManager:(JLAuracastManager *)mgr didUpdateBroadcastList:(NSArray<JLBroadcastDataModel *> *)list;

/// 设备状态更新
/// - Parameters:
///   - mgr: 管理器
///   - state: 最新设备状态
-(void)auracastManager:(JLAuracastManager *)mgr didUpdateDeviceState:(JLAuracastDevStateModel *)state;

/// 当前播放源更新
/// - Parameters:
///   - mgr: 管理器
///   - source: 当前播放源（可空）
-(void)auracastManager:(JLAuracastManager *)mgr didUpdateCurrentSource:(JLBroadcastDataModel * _Nullable)source;
@end

@interface JLAuracastManager : NSObject

/// 若干个搜索到的对象
@property(nonatomic,strong)NSMutableArray <JLBroadcastDataModel *>* broadcastDataModels;

/// 设备状态
@property(nonatomic,strong)JLAuracastDevStateModel *devState;

/// 当前播放源
@property(nonatomic,strong)JLBroadcastDataModel *__nullable currentSource;

/// 回调代理
@property(nonatomic,weak)id<JLAuracastManagerDelegate> delegate;

/// 初始化
-(instancetype)initWithManager:(JL_ManagerM *)manager;


/// 扫描Auracast广播
/// - Parameter state: 是否开启
-(void)auracastScanBroadcast:(BOOL)state;


/// 获取Auracast设备状态
/// - Parameter state:
/// 0x01 == 电量
/// 0x02 == 音量
/// 0x03 == 通话
/// 0x04 == 工作模式
/// 0x06 == 登录状态
-(void)auracastGetDevState:(uint8_t)state;

/// 获取Auracast设备状态
-(void)auracastGetDevState;


/// 设置Auracast当前播放源
/// - Parameter model: 播放源
-(void)addSourceToDev:(JLBroadcastDataModel *)model;

/// 移除Auracast当前播放源
-(void)removeDevCurrentSource;

/// 获取Auracast当前播放源
/// - Parameter block: 回调
-(void)getCurrentOperationSource:(void(^)(JLBroadcastDataModel *model))block;

/// 销毁
-(void)onDestory;



@end

NS_ASSUME_NONNULL_END
