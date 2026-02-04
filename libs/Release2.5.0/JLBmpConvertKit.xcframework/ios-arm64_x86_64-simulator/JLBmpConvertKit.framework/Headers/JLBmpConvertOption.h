//
//  JLBmpConvertOption.h
//  JLBmpConvertKit
//
//  Created by EzioChan on 2025/5/23.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 图像转换类型
typedef NS_ENUM(NSUInteger, JLBmpConvertType) {
    /// 695N 图像转换 RGB 转换成 695N 芯片对应的图像资源
    /// 对应原 BR23 转换算法
    JLBmpConvertType695N_RBG = 0,
    /// 701N 图像转换 RGB 转换成 701N 芯片对应的图像资源
    /// 对应原 BR28 转换的算法
    JLBmpConvertType701N_RBG = 1,
    /// 701N 图像转换 ARGB 转换成 701N 芯片对应的图像资源
    /// 对应原 BR28_ARBG 转换的算法
    JLBmpConvertType701N_ARBG = 2,
    /// 701N 图像转换 RGB 转换成 701N 芯片对应的图像资源(不打包封装）
    /// 对应原 BR28_RGB_NO_PACK 转换的算法(不打包封装)
    JLBmpConvertType701N_RBG_NO_PACK = 3,
    /// 701N 图像转换 ARGB 转换成 701N 芯片对应的图像资源(不打包封装)
    /// 对应原 BR28_ARGB_NO_PACK 转换的算法(不打包封装)
    JLBmpConvertType701N_ARGB_NO_PACK = 4,
    /// 707N 图像转换 RGB 转换成 707N 芯片对应的图像资源
    /// 对应 BR35 转换的算法
    JLBmpConvertType707N_RBG = 5,
    /// 707N 图像转换 ARGB 转换成 707N 芯片对应的图像资源
    /// 对应 BR35_ARGB 转换的算法
    JLBmpConvertType707N_ARGB = 6,
    /// 707N 图像转换 RGB 转换成 707N 芯片对应的图像资源(不打包封装)
    /// 对应 BR35_RGB_NO_PACK 转换的算法(不打包封装)
    JLBmpConvertType707N_ARGB_NO_PACK = 7,
    /// 707N 图像转换 RGB 转换成 707N 芯片对应的图像资源(不打包封装)
    /// 对应 BR35_RGB_NO_PACK 转换的算法(不打包封装)
    JLBmpConvertType707N_RBG_NO_PACK = 8,
    /// 701N 图像转换 JPEG
    /// 仅仅支持 JPEG 类型
    JLBmpConvertType701N_JPEG = 9
};

/// 图像格式
/// 仅（707N 系列芯片支持）
typedef NS_ENUM(NSUInteger, JLBmpPixelformat) {
    /// ARBG8888/RBG888 格式
    JLBmpPixelformat_888,
    /// ARBG8565/RBG565 格式
    JLBmpPixelformat_565,
    /// 自动选择最小的格式
    JLBmpPixelformat_Auto,
};

/// LVGL 打包格式
typedef NS_ENUM(NSUInteger, JLBmpPacketFormat) {
    JLBmpPacketFormatNone = 0,
    JLBmpPacketFormatJLUI = 1,
    JLBmpPacketFormatLVGL = 2
};

/// 图像转换选项
@interface JLBmpConvertOption : NSObject

/// 图像转换类型
@property (nonatomic, assign) JLBmpConvertType convertType;

/// 图像格式
/// 默认为 auto
/// 仅（707N 系列芯片支持）
@property (nonatomic, assign) JLBmpPixelformat pixelformat;

/// LVGL 打包格式
/// 默认为 JLUI
/// 仅（707N 系列芯片支持）
@property (nonatomic, assign) JLBmpPacketFormat packetFormat;

/// 是否转换成 BGRA
/// 当使用的是 JL 的 UI 框架时需要使用
/// 使用其他第三方框架时，需要根据固件端框架进行调整
/// default YES
@property (nonatomic, assign) BOOL convertToBGRA;

@end

NS_ASSUME_NONNULL_END
