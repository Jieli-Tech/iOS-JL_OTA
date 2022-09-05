//
//  AppDelegate.m
//  JL_OTA_InnerBle
//
//  Created by 凌煊峰 on 2021/10/9.
//

#import "AppDelegate.h"
//#import "JLOtaFileManager.h"
#import "JLMainViewController.h"

/*--- 多语言 ---*/
#define kJL_GET         [DFUITools systemLanguage]                              //获取系统语言
#define kJL_SET(lan)    [DFUITools languageSet:@(lan)]                          //设置系统语言
#define kJL_TXT(key)    [DFUITools languageText:@(key) Table:@"Localizable"]    //多语言转换,"Localizable"根据项目的多语言包填写。

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*--- 设置屏幕常亮 ---*/
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    /*--- 记录NSLOG ---*/
    [JL_Tools openLogTextFile];
    
    // 初始化本地OTA升级文件，取消注释后可转移安装本地项目目录的ota升级文件到APP沙盒
//    [JLOtaFileManager initializeOtaFile];
    
    /*--- 检测当前语言 ---*/
    if (![kJL_GET hasPrefix:@"zh-Hans"]) {
        kJL_SET("en");// set APP's language to English
    } else {
        kJL_SET("zh-Hans");// 设置APP语言为中文
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UITabBarController *mainVC = [JLMainViewController prepareViewControllers];
    self.window.rootViewController = mainVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    

    
    return YES;
}

@end
