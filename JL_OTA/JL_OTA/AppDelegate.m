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

    /*--- 设置屏幕常亮 ---*/
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    /*--- 记录NSLOG ---*/
    [JL_Tools openLogTextFile];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UITabBarController *mainVC = [JLMainViewController prepareViewControllers];
    self.window.rootViewController = mainVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

@end
