//
//  JLFileTool.h
//  JL_OTA
//
//  Created by JL_OTA on 2026/9/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 沙盒路径与文件工具（替代原 DFFile 中被使用的接口）
@interface JLFileTool : NSObject

/// 生成系统目录下的文件路径：Documents/mPath/file
/// @param sPath  系统目录（如 NSDocumentDirectory）
/// @param mPath  中间目录（如 @"upgrade"，可为 nil）
/// @param file   文件名（可为 nil，仅取目录路径）
+ (NSString *)listPath:(NSSearchPathDirectory)sPath
            MiddlePath:(nullable NSString *)mPath
                  File:(nullable NSString *)file;

/// 返回目录下所有元素名（目录不存在时返回空数组）
+ (NSArray *)subPaths:(NSString *)path;

/// 删除文件/目录
+ (BOOL)removePath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
