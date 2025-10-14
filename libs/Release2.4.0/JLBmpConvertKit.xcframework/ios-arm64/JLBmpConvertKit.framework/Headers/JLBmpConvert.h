//
//  JLBmpCovert.h
//  JLBmpCovertKit
//
//  Created by EzioChan on 2024/9/9.
//  Copyright © 2024 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IOS || TARGET_OS_MACCATALYST
#import <UIKit/UIKit.h>
#elif TARGET_OS_OSX
#import <AppKit/AppKit.h>
#endif


NS_ASSUME_NONNULL_BEGIN
@class JLBmpConvertOption;
@class JLImageConvertResult;
/// 图像转换
@interface JLBmpConvert : NSObject
#if TARGET_OS_IOS || TARGET_OS_MACCATALYST

/// 图片转换
/// - Parameters:
///   - option: 类型
///   当前仅仅 707N 系列芯片可指定图像格式
///   - inFilePath: 输入文件
///   - outFilePath: 输出文件
/// 文件路径转换入口
+ (JLImageConvertResult *)convert:(JLBmpConvertOption *)option
                      inFilePath:(NSString *)inFilePath
                     outFilePath:(NSString * __nullable)outFilePath;

/// UIImage 转换
/// 当前仅仅 707N 系列芯片可指定图像格式
/// - Parameters:
///   - option: 类型
///   - imgData: 图片的原始数据
+(JLImageConvertResult *)convert:(JLBmpConvertOption *)option ImageData:(NSData *)imgData;


/// UIImage 转换成 BGRA
/// - Parameter image: 图片
+(NSData*)convertImageToBGRABytes:(UIImage *)image;

/// UIImage 转换成 RGBA
/// - Parameter image: 图片
+(NSData*)convertImageToRGBABytes:(UIImage *)image;


/// 图片缩放
/// - Parameters:
///   - image: 图片
///   - newSize: 缩放大小
/// - Returns: 缩放后的图片
+(NSData *)resizeImage:(UIImage*)image andResizeTo:(CGSize)newSize;

#elif TARGET_OS_OSX
/// 图片转换
/// - Parameters:
///   - option: 转换类型
///   - inImage: 输入图片
+(JLImageConvertResult *)convert:(JLBmpConvertOption *)option Image:(NSImage *)image;

#endif
@end

NS_ASSUME_NONNULL_END
