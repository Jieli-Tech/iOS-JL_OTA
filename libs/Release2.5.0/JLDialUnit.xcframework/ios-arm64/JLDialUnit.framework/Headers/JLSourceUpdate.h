//
//  JLSourceUpdate.h
//  JLDialUnit
//
//  Created by EzioChan on 2025/3/18.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_BLEKit.h>
#import <JLLogHelper/JLLogHelper.h>

NS_ASSUME_NONNULL_BEGIN
@class JLDialUnitMgr;

typedef NS_ENUM(NSInteger, JLSourceUpdateType) {
    /// 更新资源完成
    JLSourceUpdateTypeFinished = 0,
    /// 资源已最新
    JLSourceUpdateTypeNewest = 1,
    /// 资源无效
    JLSourceUpdateTypeInvalid = 2,
    /// 资源为空
    JLSourceUpdateTypeEmpty = 3,
    /// 资源更新错误
    JLSourceUpdateTypeSrcError = 4,
    /// 资源更新中
    JLSourceUpdateTypeUpdateing = 5,
    /// 空间不足
    JLSourceUpdateTypeNoSpace = 6,
    /// ZIP 资源文件错误
    JLSourceUpdateTypeZipError = 7,
    /// 表盘资源对比失败
    JLSourceUpdateTypeCompareFail = 8,
    /// 更新固件 ufw
    JLSourceUpdateTypeUpdateUfw = 9,
    /// 不支持
    JLSourceUpdateTypeUpdateNotSupport = 10,
};


@interface JLSourceInfo : NSObject

@property(nonatomic,strong)NSString *filePath;
@property(nonatomic,strong,readonly)NSData * _Nullable fileData;
@property(nonatomic,strong,readonly)NSString *fileName;
@property(nonatomic,assign)NSInteger index;

@end

@protocol JLSourceUpdateDelegate <NSObject>

- (void)updateProgress:(double)progress type:(JLSourceUpdateType)type source:(JLSourceInfo *_Nullable)source error:(NSError* _Nullable)error;

- (void)updateUfwFirst:(NSString *)filePath ThenUpdateSrc:(NSArray <JLSourceInfo *>*) filePaths;

@end

/// 资源更新
@interface JLSourceUpdate : NSObject

@property(nonatomic,weak)id<JLSourceUpdateDelegate> delegate;

/// 初始化
/// - Parameters:
///   - mgr: 蓝牙管理对象
///   - fileType: 文件句柄
///   - dialMgr: JLDialUnitMgr
///   - delegate: 代理
-(instancetype)initWithManager:(JL_ManagerM*)mgr HandleType:(JL_FileHandleType) fileType DialMgr:(JLDialUnitMgr *)dialMgr delegate:(id<JLSourceUpdateDelegate>)delegate;


/// 更新资源
/// - Parameters:
///   - path: zip包路径
///   - mgr: JLDialUnitMgr
-(void)updateSources:(NSString*)path DialUnitMgr:(JLDialUnitMgr *)mgr;


/// 更新资源 AC707N 手表特殊升级流程
/// - Parameters:
///   - path: zip 包路径
///   - mgr: JLDialUnitMgr
-(void)updateSourcesV2:(NSString*)path DialUnitMgr:(JLDialUnitMgr *)mgr;


/// 更新资源任务
/// @param targetUpdateList 需要更新的文件列表
/// @param updateResult 更新结果
-(void)updateAciton:(NSArray *)targetUpdateList Result:(void (^)(BOOL isFinish, NSError * _Nullable))updateResult;

@end

NS_ASSUME_NONNULL_END
