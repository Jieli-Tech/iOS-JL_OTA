//
//  AppDelegate.m
//  OTA_Update
//
//  Created by DFung on 2019/8/21.
//  Copyright © 2019 DFung. All rights reserved.
//

#import "AppDelegate.h"
#import "JL_RunSDK.h"
#import "UpdateVC.h"
#import "DeviceVC.h"

@interface AppDelegate (){
    UITabBarController  *mainVC;
    JL_RunSDK           *runSdk;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*--- 记录NSLOG ---*/
    [self recordNSlog];
    
    /*--- 设置屏幕常亮 ---*/
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    /*--- 检测当前语言 ---*/
    if (![kJL_GET hasPrefix:@"zh-Hans"]) {
        kJL_SET("en");
    }else{
        kJL_SET("zh-Hans");
    }
    
    /*--- 初始化UI ---*/
    [self setupUI];
    
    runSdk = [[JL_RunSDK alloc] init];
    [JL_Tools add:@"UI_CHANEG_VC" Action:@selector(noteChangeVC:) Own:self];
    
    return YES;
}

#pragma mark - 日志收集
- (void)recordNSlog
{
    //如果已经连接Xcode调试则不输出到文件
    if(isatty(STDOUT_FILENO)) {
        return;
    }
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
 
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *fileName = [NSString stringWithFormat:@"LOG-%@.txt",[dateformat stringFromDate:[NSDate date]]];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
 
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    for (NSString *lastLog in [DFFile subPaths:documentDirectory]) {
        if ([lastLog hasPrefix:@"LOG-"]) {
            NSString *lastLogPath = [documentDirectory stringByAppendingPathComponent:lastLog];
            [defaultManager removeItemAtPath:lastLogPath error:nil];
        }
    }

    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
 
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

-(void)setupUI{
    self.window =[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    mainVC = [self prepareViewControllers];
    self.window.rootViewController = mainVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

-(UITabBarController*)prepareViewControllers{
    UpdateVC *vc_1 = [UpdateVC new];
    DeviceVC *vc_2 = [DeviceVC new];
    
    UINavigationController *nvc_1 = [[UINavigationController alloc] initWithRootViewController:vc_1];
    UINavigationController *nvc_2 = [[UINavigationController alloc] initWithRootViewController:vc_2];
    
    NSArray *arr_vc  = @[nvc_1,nvc_2];
    NSArray *arr_txt = @[kJL_TXT("设备升级"),kJL_TXT("设备连接")];
    NSArray *arr_img = @[@"shengji",@"lianjie  wei"];
    NSArray *arr_img_sel = @[@"shenji  C",@"lianjie"];
    
    for (int i = 0 ; i < arr_vc.count; i++) {
        UINavigationController *nvc = arr_vc[i];
        /*--- TabBarItem的名字 ---*/
        nvc.tabBarItem.title = arr_txt[i];
        
        /*--- 使用原图片作为底部的TabBarItem ---*/
        UIImage *image     = [UIImage imageNamed:arr_img[i]];
        UIImage *image_sel = [UIImage imageNamed:arr_img_sel[i]];
        nvc.tabBarItem.image         = [self imageAlwaysOriginal:image];
        nvc.tabBarItem.selectedImage = [self imageAlwaysOriginal:image_sel];
        
        /*--- 隐藏底部 ---*/
        [nvc.tabBarController.tabBar setHidden:NO];
        
        /*--- 同时支持又滑返回功能的解决办法(隐藏顶部) ---*/
        nvc.navigationBarHidden = NO;
        nvc.navigationBar.hidden= YES;
    }
    
    UITabBarController *tabBarVC  = [[UITabBarController alloc] init];
    tabBarVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    tabBarVC.tabBar.tintColor     = kDF_RGBA(70.0, 146.0, 251.0, 1.0);
    tabBarVC.tabBar.barTintColor  = [UIColor whiteColor];
    tabBarVC.viewControllers      = arr_vc;
    return tabBarVC;
}

-(void)noteChangeVC:(NSNotification*)note{
    NSInteger index = [[note object] intValue];
    mainVC.selectedIndex = index;
}


- (UIImage *)imageAlwaysOriginal:(UIImage *)image{
    UIImage *img = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
