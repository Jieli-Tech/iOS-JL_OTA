//
//  JLLanguageManager.h
//  JL_OTA
//
//  Created by JL_OTA on 2026/9/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 多语言管理（替代原 DFUITools 语言相关接口）
/// 存储"App 显示语言"，按语言从对应 xx.lproj/Localizable.strings 取文案
@interface JLLanguageManager : NSObject

/// 系统语言（如 zh-Hans / en / ko）
+ (NSString *)systemLanguage;

/// 设置 App 显示语言（持久化到 NSUserDefaults）
+ (void)setAppLanguage:(NSString *)lan;

/// 取翻译文案
/// @param key   文案 key
/// @param table strings 表名（如 @"Localizable"）
+ (NSString *)textForKey:(NSString *)key table:(NSString *)table;

@end

NS_ASSUME_NONNULL_END
