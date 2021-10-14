//
//  JLMainViewController.m
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/12.
//

#import "JLMainViewController.h"
#import "JLUpdateViewController.h"
#import "JLDeviceViewController.h"

@implementation JLMainViewController


+ (UITabBarController *)prepareViewControllers {
    JLUpdateViewController *vc_1 = [JLUpdateViewController new];
    JLDeviceViewController *vc_2 = [JLDeviceViewController new];
    
    UINavigationController *nvc_1 = [[UINavigationController alloc] initWithRootViewController:vc_1];
    UINavigationController *nvc_2 = [[UINavigationController alloc] initWithRootViewController:vc_2];
    
    NSArray *arr_vc = @[nvc_1, nvc_2];
    NSArray *arr_txt = @[@"设备升级", @"设备连接"];
    NSArray *arr_img = @[@"upgrade", @"device"];
    NSArray *arr_img_sel = @[@"upgrade_sel", @"device_sel"];
    
    for (int i = 0; i < arr_vc.count; i++) {
        UINavigationController *nvc = arr_vc[i];
        /*--- TabBarItem的名字 ---*/
        nvc.tabBarItem.title = arr_txt[i];
        
        /*--- 使用原图片作为底部的TabBarItem ---*/
        UIImage *image = [UIImage imageNamed:arr_img[i]];
        UIImage *image_sel = [UIImage imageNamed:arr_img_sel[i]];
        nvc.tabBarItem.image = [self imageAlwaysOriginal:image];
        nvc.tabBarItem.selectedImage = [self imageAlwaysOriginal:image_sel];
        
        [nvc.tabBarController.tabBar setHidden:NO];
        nvc.navigationBarHidden = NO;
        nvc.navigationBar.hidden = YES;
    }
    
    UITabBarController *tabBarVC  = [[UITabBarController alloc] init];
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        appearance.backgroundColor = [UIColor whiteColor];
        appearance.shadowColor = [UIColor clearColor];
        tabBarVC.tabBar.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            tabBarVC.tabBar.scrollEdgeAppearance = appearance;
        }
    }
    tabBarVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    tabBarVC.tabBar.tintColor = [UIColor colorWithRed:((70.0)/255.0) green:((146.0)/255.0) blue:((251.0)/255.0) alpha:(1.0)];
    tabBarVC.tabBar.barTintColor = [UIColor whiteColor];
    tabBarVC.viewControllers = arr_vc;
    return tabBarVC;
}

+ (UIImage *)imageAlwaysOriginal:(UIImage *)image {
    UIImage *img = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}


@end
