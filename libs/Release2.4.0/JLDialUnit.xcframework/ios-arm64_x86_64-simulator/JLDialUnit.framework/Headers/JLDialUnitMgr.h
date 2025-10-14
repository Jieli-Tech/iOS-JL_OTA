//
//  JLDialUnitMgr.h
//  JLDialUnit
//
//  Created by EzioChan on 2025/3/18.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_HashPair/JL_HashPair.h>
#import <JLLogHelper/JLLogHelper.h>
#import <JL_BLEKit/JL_BLEKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JLDialSourceModel;
@interface JLDialUnitMgr : NSObject

/// 设备文件列表
@property (nonatomic,strong)NSMutableArray <JLDialSourceModel *> *fileArray;

/// 当前 Flash 操控句柄
@property (nonatomic, strong) JLFlashOpMgr *currentFlaghOpMgr;

/// 当前使用的表盘文件
@property (nonatomic,strong)JLDialSourceModel *currentFileSource;

/// 当前使用的表盘背景
@property (nonatomic,strong)JLDialSourceModel *_Nullable currentBackground;

/// 初始化
/// - Parameters:
///   - mgr: 蓝牙管理对象
///   - completion: 回调
-(instancetype)initWithManager:(JL_ManagerM*)mgr completion:(void (^)(NSError * _Nullable))completion;

/// 获取文件列表
/// - Parameters:
///   - cardType: 设备存储的类型
///   - count: 请求的数目
///   - completion: 回调
///   返回时，是返回累计数目
-(void)getFileList:(JL_CardType)cardType count:(NSInteger)count completion:(void (^)(NSArray <JLDialSourceModel *> * _Nullable,NSError * _Nullable))completion;

/// 清空文件列表
/// - Parameter cardType: 设备存储的类型
-(void)cleanFileList;

/// 更新文件列表信息
/// - Parameters:
///   - fileSources: NSArray<JLModel_File *>
///   - completion: 回调
-(void)updateFileSources:(NSArray<JLModel_File *> *)fileSources completion:(void (^)(NSArray<JLDialSourceModel *> * _Nullable,NSError * _Nullable))completion;

/// 更新文件到设备
/// - Parameters:
///   - fileHandleType: 设备目标存储句柄
///   - fileData: 文件数据
///   - filePath: 文件存储路径
///   - resultCompletion: 回调
///   state: 0:成功 1:传输中 -1:失败
///   progress: 传输进度
///   error: 错误
-(void)updateFileToDevice:(JL_FileHandleType)fileHandleType Data:(NSData *)fileData FilePath:(NSString *)filePath completion:(void (^)(int,double,NSError * _Nullable))resultCompletion;

/// 删除文件
/// - Parameters:
///   - filePath: 文件路径
///   - resultCompletion: 回调
-(void)deleteFile:(NSString *)filePath getFileList:(BOOL)isGet Completion:(void (^)(BOOL state, NSError * _Nullable error))resultCompletion;

/// 删除多个文件
/// - Parameters:
///   - filePathList: 文件路径
///   - resultCompletion: 回调
-(void)deleteFiles:(NSArray <NSString*>*) filePathList Completion:(void (^)(BOOL state, NSError * _Nullable error))resultCompletion;

/// 获取剩余空间
/// - Parameter completion: 回调
-(void)getRemainingSpace:(void(^)(int freeSize, NSError * _Nullable error))completion;

/// 获取剩余空间 V1
/// - Parameter completion: 回调
-(void)getFlashRemainingSpace:(void(^)(int freeSize, NSError * _Nullable error))completion;

//MARK: 表盘操作

/// 获取当前正在使用的表盘
/// - Parameter completion: 回调
-(void)dialGetCurrent:(void (^)(JLDialSourceModel * _Nullable))completion;

/// 设置当前表盘
/// - Parameters:
///   - model: 表盘
///   - resultCompletion: 回调
-(void)dialSetCurrent:(JLDialSourceModel *)model Completion:(void (^)(BOOL state, NSError * _Nullable error))resultCompletion;

/// 激活自定义表盘背景
/// - Parameters:
///   - model: 表盘背景对象
///   - resultCompletion: 回调
-(void)dialActiveCustomBackground:(JLDialSourceModel *)model Completion:(void (^)(BOOL state, NSError * _Nullable error))resultCompletion;

/// 重置自定义表盘背景
/// - Parameter resultCompletion: 回调
-(void)dialResetCustomBackground:(void (^)(BOOL state, NSError * _Nullable error))resultCompletion;

/// 获取当前表盘背景
/// - Parameter resultCompletion: 回调
-(void)dialGetCurrentBackground:(void (^)(JLDialSourceModel * _Nullable model, NSError * _Nullable error))resultCompletion;

@end

NS_ASSUME_NONNULL_END
