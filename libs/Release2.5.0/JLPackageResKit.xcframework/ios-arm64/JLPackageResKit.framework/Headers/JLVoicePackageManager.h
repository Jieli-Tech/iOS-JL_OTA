//
//  JLVoicePackageManager.h
//  JL_BLEKit
//
//  Created by EzioChan on 2024/1/16.
//  Copyright © 2024 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class JLToneCfgModel;
@class JLVoiceReplaceInfo;



/// 提示音替换类
@interface JLVoicePackageManager : NSObject

/// 打包多个 .wts 文件成 tone.cfg 数据
/// - Parameters:
///   - paths: 文件存放路径
///   - names: 文件在设备端使用时的名称
///   - info: 设备限制的信息
+(NSData *)makePks:(NSArray *)paths FileNames:(NSArray *)names Info:(JLVoiceReplaceInfo*)info;

/// 解包 tone.cfg 数据
/// - Parameter data: tone.cfg 数据
+(NSArray<JLToneCfgModel*> *)parsePks:(NSData *)data; 

/// 当前 SDK 版本
+(NSString *)getVersion;

@end

NS_ASSUME_NONNULL_END
