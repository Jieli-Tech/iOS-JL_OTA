//
//  AppDelegate.m
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/9.
//

#import "AppDelegate.h"
#import "JLOtaFileManager.h"
#import "JLMainViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 初始化OTA升级文件，取消注释后可转移安装本地项目目录的ota升级文件到APP沙盒
//    [JLOtaFileManager initializeOtaFile];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UITabBarController *mainVC = [JLMainViewController prepareViewControllers];
    self.window.rootViewController = mainVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
