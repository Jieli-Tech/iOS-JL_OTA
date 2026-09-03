//
//  JLBDTAIPayload.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/9/2.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/ECBDTManager.h>

NS_ASSUME_NONNULL_BEGIN

/// AI 云数据的文本类型
typedef NS_ENUM(UInt8, JLBDTTextType) {
    /// 语音识别文本
    JLBDTTextTypeAsr     = 0,
    /// AI 应答文本
    JLBDTTextTypeAnswer  = 1,
    /// AI 错误提示
    JLBDTTextTypeError   = 2,
};

/// AI 云服务供应商
typedef NS_ENUM(UInt8, JLBDTSupplier) {
    /// 杰理
    JLBDTSupplierJieli   = 0,
    /// 科大讯飞
    JLBDTSupplierXunFei  = 1,
    /// 豆包
    JLBDTSupplierDoubao  = 2,
};

/// AI 云数据与语音播报数据的载荷封装
/// 配合 ECBDTManager 的对应数据类型写入/解析使用
@interface JLBDTAIPayload : NSObject

/// 封装 AI 云数据
/// @param textType 文本类型
/// @param supplier 供应商
/// @param text 文本内容（UTF-8）
+ (NSData *)packAITextType:(JLBDTTextType)textType
                  supplier:(JLBDTSupplier)supplier
                      text:(NSString *)text;

/// 解析 AI 云数据
/// @param data 载荷数据
/// @return textType / supplier / text 组成的字典，解析失败返回 nil
+ (nullable NSDictionary<NSString *, id> *)parseAIData:(NSData *)data;

/// 封装语音播报数据
/// @param audio 音频内容
+ (NSData *)packTTSAudio:(NSData *)audio;

/// 解析语音播报数据
/// @param data 载荷数据
/// @return 音频内容，解析失败返回 nil
+ (nullable NSData *)parseTTSData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
