//
//  JLLanguageManager.m
//  JL_OTA
//
//  Created by JL_OTA on 2026/9/3.
//

#import "JLLanguageManager.h"

static NSString *const kJL_AppLanguageKey = @"JL_AppLanguage";

@implementation JLLanguageManager

+ (NSString *)systemLanguage {
    NSArray<NSString *> *preferred = [NSLocale preferredLanguages];
    if (preferred.count > 0) {
        return preferred.firstObject;
    }
    return @"en";
}

+ (NSString *)appLanguage {
    NSString *lan = [[NSUserDefaults standardUserDefaults] objectForKey:kJL_AppLanguageKey];
    if (lan.length == 0) {
        lan = [self systemLanguage];
    }
    // 归一化：兼容 "zh-Hans-CN" 这类带地区后缀的系统值，映射到工程内语言目录 zh-Hans / en / ko
    NSArray *parts = [lan componentsSeparatedByString:@"-"];
    if (parts.count >= 2 && [parts[0] isEqualToString:@"zh"]) {
        return [NSString stringWithFormat:@"%@-%@", parts[0], parts[1]]; // zh-Hans / zh-Hant
    }
    return parts.firstObject;
}

+ (void)setAppLanguage:(NSString *)lan {
    [[NSUserDefaults standardUserDefaults] setObject:lan forKey:kJL_AppLanguageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)textForKey:(NSString *)key table:(NSString *)table {
    if (key.length == 0) return @"";
    NSString *lan = [self appLanguage];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:lan ofType:@"lproj"];
    if (path.length > 0) {
        NSBundle *lanBundle = [NSBundle bundleWithPath:path];
        if (lanBundle) {
            return [lanBundle localizedStringForKey:key value:key table:table];
        }
    }
    // 语言包缺失时回退主 bundle，找不到回退 key 本身（与原 DFUITools 行为一致）
    return [bundle localizedStringForKey:key value:key table:table];
}

@end
