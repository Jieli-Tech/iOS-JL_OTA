//
//  AppDelegate.m
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/9.
//

#import "AppDelegate.h"
#import "JLAutoViewsController.h"
#import "ToolsHelper.h"
#import "JLMainViewController.h"
#import "BroadcastMainViewController.h"
#import <Bugly/Bugly.h>

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
//    [[ToolsHelper share] openLogTextFile:1*1024*1024];
    [Bugly startWithAppId:@"292cbf624f"];
    
    // 初始化本地OTA升级文件，取消注释后可转移安装本地项目目录的ota升级文件到APP沙盒
//    [JLOtaFileManager initializeOtaFile];
    
    /*--- 检测当前语言 ---*/
    if ([kJL_GET hasPrefix:@"zh-Hans"]) {
        kJL_SET("zh-Hans");// 设置APP语言为中文
    } else if([kJL_GET hasPrefix:@"ko"]) {
        kJL_SET("ko");// set APP's language to ko-cn
    }else{
        kJL_SET("en");// set APP's language to English
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController *mainVC = [JLMainViewController prepareViewControllers];
    if([ToolsHelper isAutoTestOta]){
        mainVC = [JLAutoViewsController prepareViewControllers];
    }
    if([ToolsHelper isBroadcast]){
        mainVC = [BroadcastMainViewController prepareViewControllers];
    }
    self.window.rootViewController = mainVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    

    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *fname = url.path.lastPathComponent;
    NSString *basicPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    basicPath = [basicPath stringByAppendingPathComponent:@"upgrade"];
    NSFileManager *fm = [NSFileManager new];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fm fileExistsAtPath:basicPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        
        BOOL bCreateDir = [fm createDirectoryAtPath:basicPath
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:nil];
        if(!bCreateDir){
            NSLog(@"Create upgrade Directory Failed.");
        }
    }
    NSString *docPath = [basicPath stringByAppendingPathComponent:fname];
    if ([fm fileExistsAtPath:docPath]) {
        NSArray *arr = [fname componentsSeparatedByString:@"."];
        NSDateFormatter *dfm = [NSDateFormatter new];
        dfm.dateFormat = @"yyyyMMddHHmmss";
        NSString *newDateStr = [dfm stringFromDate:[NSDate new]];
        fname = [NSString stringWithFormat:@"%@_%@.%@",arr[0],newDateStr,arr[1]];
    }
    docPath = [basicPath stringByAppendingPathComponent:fname];
    [fm createFileAtPath:docPath contents:data attributes:nil];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_FILE" object:nil];
    return YES;
}




@end
