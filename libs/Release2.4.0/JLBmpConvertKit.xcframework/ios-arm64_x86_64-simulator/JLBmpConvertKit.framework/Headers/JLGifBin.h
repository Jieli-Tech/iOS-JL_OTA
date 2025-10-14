//
//  JLGifBin.h
//  JLGifLib
//
//  Created by EzioChan on 2024/1/18.
//  Copyright © 2024 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Gif 转 Bin 支持的芯片类型
typedef NS_ENUM(NSUInteger, JLGIFBinChipType) {
    /// 701N
    JLGIFBinChipJL_701N,
    /// 707N
    JLGIFBinChipJL_707N,
};

///packet 是否打包
typedef NS_ENUM(NSInteger, JLGIFBinPackageType) {
    /// 不做其他打包使用源数据，适用 LVGL 的公版UI框架
    JLGIFBinPackageTypeLVGL = 0,
    /// 杰理打包格式，适用 JLVGL 的杰理定制版 UI 框架
    JLGIFBinPackageTypeJLVGL = 1,
};

typedef void(^JLGif2BinBlock)(int code,NSData *_Nullable binData);

/// Gif 转 Bin
@interface JLGifBin : NSObject

/// 打印当前SDK的版本
+(void)sdkVersion;

/// 根据 Gif 创建 Bin
/// - Parameters:
///   - gifData: Gif 图片数据
///   - level: 等级
///          1: 低码率
///          2: 中码率
///          3: 高码率
///   - block: 回调内容
+(void)makeDataToBin:(NSData *)gifData Level:(int)level Result:(JLGif2BinBlock)block __attribute__((deprecated("Use makeDataToBin:Level:ChipType:Result: instead.")));


/// 根据 Gif 创建 Bin
/// - Parameters:
///   - gifData: Gif 图片数据
///   - level: 等级
///          1: 低码率
///          2: 中码率 (仅 JLGIFBinChipJL_701N 支持）
///          3: 高码率 (仅 JLGIFBinChipJL_701N 支持）
///   - chip: 芯片类型
///   - block: 回调内容
+(void)makeDataToBin:(NSData *)gifData Level:(int)level ChipType:(JLGIFBinChipType)chip Result:(JLGif2BinBlock)block __attribute__((deprecated("Use makeDataToBin:Level:ChipType:PackageType:Result: instead.")));


/// 根据 Gif 创建 Bin
/// - Parameters:
///   - gifData: Gif 图片数据
///   - level: 等级
///          1: 低码率
///          2: 中码率 (仅 JLGIFBinChipJL_701N 支持）
///          3: 高码率 (仅 JLGIFBinChipJL_701N 支持）
///   - chip: 芯片类型
///   - packageType: 打包类型
///          1: JLUI 杰理 UI 格式
///          0: 无 不打包
///   - block: 回调内容
+(void)makeDataToBin:(NSData *)gifData Level:(int)level ChipType:(JLGIFBinChipType)chip PackageType:(JLGIFBinPackageType)packageType Result:(JLGif2BinBlock)block;


@end

NS_ASSUME_NONNULL_END
