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

/// 搜索状态
typedef NS_ENUM(NSUInteger, JLAuracastScanState) {
    ///操作成功/不在搜索状态
    JLAuracastScanStateSuccess = 0,
    ///正在搜索，请勿重复操作
    JLAuracastScanStateScanning = 1,
    ///收听广播过程不允许扫描
    JLAuracastScanStateForbidden = 2,
    ///设备繁忙
    JLAuracastScanStateBusy = 3,
};

/// 扫描类型
typedef NS_ENUM(NSUInteger, JLAuracastScanType) {
    /// 停止
    JLAuracastScanTypeStop = 0,
    /// 开始
    JLAuracastScanTypeStart = 1,
    /// 查询
    JLAuracastScanTypeQuery = 2,
};

@protocol JLAuracastManagerDelegate <NSObject>
@optional

/// 搜索状态
/// - Parameters:
///   - mgr: 管理器
///   - state: 搜索状态
///   - error: 错误
-(void)auracastManager:(JLAuracastManager *)mgr didUpdateSearchState:(BOOL)state Error:(NSError * _Nullable)error;


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

typedef void(^JLAuracastManagerResultBlock)(JL_CMDStatus status, NSError * _Nullable error);

@interface JLAuracastManager : NSObject

/// 扫描状态
@property(nonatomic, assign)BOOL isScanning;

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
/// - Parameter type: 扫描类型
-(void)auracastScanBroadcast:(JLAuracastScanType)type;

/// 获取Auracast设备状态
-(void)auracastGetDevState;


/// 设置Auracast当前播放源
/// - Parameter model: 播放源
/// - Parameter block: 回调
/// 这里的回调仅仅是命令收发的一个回复，设备回复成功不代表添加成功
/// 只说明了此命令交互成功，开发者仍需监听
/// -(void)auracastManager:(JLAuracastManager *)mgr didUpdateCurrentSource:(JLBroadcastDataModel * _Nullable)source 作为判断是否成功收听的重要指标
-(void)addSourceToDev:(JLBroadcastDataModel *)model result:(JLAuracastManagerResultBlock _Nullable)block;

/// 移除Auracast当前播放源
/// - Parameter block: 回调
-(void)removeDevCurrentSource:(JLAuracastManagerResultBlock _Nullable)block;

/// 获取Auracast当前播放源
/// - Parameter block: 回调
-(void)getCurrentOperationSource:(void(^)(JLBroadcastDataModel *model))block;

/// 销毁
-(void)onDestory;



@end

NS_ASSUME_NONNULL_END
