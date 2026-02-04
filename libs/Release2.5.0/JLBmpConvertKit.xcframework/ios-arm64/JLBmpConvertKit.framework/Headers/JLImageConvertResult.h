//
//  JLImageConvertResult.h
//  JLBmpConvertKit
//
//  Created by EzioChan on 2025/3/6.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 图像转换结果
@interface JLImageConvertResult : NSObject
/// 结果码
@property (nonatomic, assign) int result;
/// 数据大小
@property (nonatomic, assign) int buf_size;
/// 图像格式
@property (nonatomic, assign) int pixel_format;
/// 压缩模式
@property (nonatomic, assign) int compress_mode;

#if TARGET_OS_IOS || TARGET_OS_MACCATALYST
/// 输出文件路径
@property (nullable, nonatomic, copy) NSString *outFilePath;
#endif

/// 输出文件内容
@property (nullable, nonatomic, copy) NSData *outFileData;

@end

NS_ASSUME_NONNULL_END
