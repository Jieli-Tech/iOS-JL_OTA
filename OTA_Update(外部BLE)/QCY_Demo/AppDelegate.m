//
//  AppDelegate.m
//  QCY_Demo
//
//  Created by 杰理科技 on 2020/3/17.
//  Copyright © 2020 杰理科技. All rights reserved.
//

#import "AppDelegate.h"
#import "OneVC.h"
#import "TwoVC.h"

@interface AppDelegate (){
    UITabBarController  *mainVC;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*--- 设置屏幕常亮 ---*/
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    /*--- 初始化UI ---*/
    [self setupUI];

    return YES;
}

-(void)setupUI{
    self.window =[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    mainVC = [self prepareViewControllers];
    self.window.rootViewController = mainVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

-(UITabBarController*)prepareViewControllers{
    OneVC   *vc_1 = [OneVC new];
    TwoVC   *vc_2 = [TwoVC new];

    
    UINavigationController *nvc_1 = [[UINavigationController alloc] initWithRootViewController:vc_1];
    UINavigationController *nvc_2 = [[UINavigationController alloc] initWithRootViewController:vc_2];

//    NSArray *arr_vc  = @[nvc_1,nvc_2];
//    NSArray *arr_txt = @[@"连接",@"音效"];
//    NSArray *arr_img = @[@"ic_home",@"ic_control2"];
//    NSArray *arr_img_sel = @[@"ic_home_sel",@"ic_control2_sel"];
    NSArray *arr_vc  = @[nvc_1];
    NSArray *arr_txt = @[@"连接"];
    NSArray *arr_img = @[@"ic_home"];
    NSArray *arr_img_sel = @[@"ic_home_sel"];
    
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
        [nvc.tabBarController.tabBar setHidden:YES];
        
        /*--- 同时支持又滑返回功能的解决办法(隐藏顶部) ---*/
        nvc.navigationBarHidden = NO;
        nvc.navigationBar.hidden = YES;
    }
    
    UITabBarController *tabBarVC  = [[UITabBarController alloc] init];
    tabBarVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    tabBarVC.tabBar.tintColor     = kDF_RGBA(255.0, 198.0, 96.0, 1.0);
    tabBarVC.tabBar.barTintColor  = [UIColor whiteColor];
    tabBarVC.viewControllers      = arr_vc;
    return tabBarVC;
}


- (UIImage *)imageAlwaysOriginal:(UIImage *)image{
    UIImage *img = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}


@end
