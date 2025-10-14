//
//  DialManager.h
//  JLDialUnit
//
//  Created by 杰理科技 on 2021/7/20.
//

#import <Foundation/Foundation.h>
#import <JLDialUnit/FatfsObject.h>
#import <JLLogHelper/JLLogHelper.h>

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSInteger, DialOperateType) {
    DialOperateTypeNoSpace     = 0,     //空间不足
    DialOperateTypeDoing       = 1,     //正在操作
    DialOperateTypeFail        = 2,     //操作失败
    DialOperateTypeSuccess     = 3,     //操作成功
    DialOperateTypeUnnecessary = 4,     //无需重复打开文件系统
    DialOperateTypeResetFial   = 5,     //重置文件系统失败
    DialOperateTypeNormal      = 6,     //文件系统正常
    DialOperateTypeCmdFail     = 7,     //流程命令执行失败
};
typedef NS_ENUM(NSInteger, DialUpdateResult) {
    DialUpdateResultFinished    = 0,    //更新资源完成
    DialUpdateResultNewest      = 1,    //资源已最新
    DialUpdateResultInvalid     = 2,    //资源无效
    DialUpdateResultEmpty       = 3,    //资源为空
    DialUpdateResultReplace     = 4,    //资源替换
    DialUpdateResultAdd         = 5,    //资源新增
    DialUpdateResultNoSpace     = 6,    //空间不足
    DialUpdateResultZipError    = 7,    //ZIP资源文件错误
    DialUpdateResultCompareFail = 8,    //表盘资源对比失败
    DialUpdateResultUpdateUfw   = 9,    //更新固件 ufw
};
typedef void(^DialOperateBK)(DialOperateType type, float progress);
typedef void(^DialListBK)(DialOperateType type, NSArray* __nullable array);
typedef void(^DialUpdateBK)(DialUpdateResult updateResult,
                            NSArray* __nullable array,
                            NSString * _Nullable filePath,
                            NSInteger index ,float progress);

typedef void(^FatfsFreeBlock)(uint32_t freeSize);

/// 表盘管理类
@interface DialManager : NSObject

#pragma mark - 连接成功后，必须调用一次！
+(void)openDialFileSystemWithCmdManager:(JL_ManagerM *)manager withResult:(DialOperateBK)result;

#pragma mark - 重置表盘系统
+(void)resetDialFileSystemWithCmdManager:(JL_ManagerM *)manager withResult:(DialOperateBK)result;

#pragma mark - 查询文件
/// 查询文件
/// @param result 操作回调
+(void)listFile:(DialListBK __nullable)result;

#pragma mark - 添加文件
/// 添加文件
/// @param file 文件名需要加斜杠，类似@“/WACTH1”。
/// @param content 文件数据
/// @param result 操作回调
+(void)addFile:(NSString*)file
       Content:(NSData*)content
        Result:(DialOperateBK)result;

#pragma mark - 删除文件
/// 删除文件（第一种）
/// @param file  文件名需要加斜杠，类似@“/WACTH1”。
/// @param result 操作回调
+(void)deleteFile:(NSString*)file
           Result:(DialOperateBK)result;

/// 删除文件（第二种）
/// @param fileModel JLModel_File类型
/// @param result 操作回调
+(void)deleteDialResourceWithFileModel:(JLModel_File*)fileModel Result:(DialOperateBK)result;

#pragma mark - 替换文件
/// 替换文件
/// @param file  文件名需要加斜杠，类似@“/WACTH1”。
/// @param content 文件数据
/// @param result 操作回调
+(void)repaceFile:(NSString*)file
          Content:(NSData*)content
           Result:(DialOperateBK)result;

#pragma mark - 格式化外部Flash
/// 格式化外部Flash操作
/// @param handle   设备句柄
/// @param result   操作回调
+(void)formatFlash:(NSString*)handle Result:(DialOperateBK)result;

#pragma mark - 更新设备的表盘资源（异步调用）
/// 更新设备的表盘资源（异步调用）
/// @param path     资源文件
/// @param array   表盘列表(当前)
/// @param result   更新结果
+(void)updateResourcePath:(NSString*)path
                     List:(NSArray*)array
                   Result:(DialUpdateBK)result;

/// 获取 fatfs 系统的剩余空间(仅仅fatfs 系统可用）
/// 需要异步执行
+(uint32_t)getFatfsFree;

/// 获取 fatfs 系统的剩余空间(仅仅fatfs 系统可用）
/// @param block 回调空间
+(void)getFatfsFree:(FatfsFreeBlock) block;

/// 获取某文件的文件大小
/// @param fileName 文件名
+(uint32_t)getSizeOfFileName:(NSString*)fileName;


/// 记录文件大小(私有接口）
/// @param size 文件大小
/// @param fileName 文件名
+(void)setFileSize:(uint32_t)size FileName:(NSString*)fileName;


@end

NS_ASSUME_NONNULL_END
