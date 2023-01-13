//
//  JLMainViewController.m
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/12.
//

#import "JLMainViewController.h"
#import "JLUpgradeViewController.h"
#import "JLDeviceViewController.h"
#import "JLSettingViewController.h"
#import "NavViewController.h"

@implementation JLMainViewController


+ (UITabBarController *)prepareViewControllers {
    JLUpgradeViewController *vc_1 = [JLUpgradeViewController new];
    JLDeviceViewController *vc_2 = [[JLDeviceViewController alloc] init];
    JLSettingViewController *vc_3 = [JLSettingViewController new];
    
    NavViewController *nvc_1 = [[NavViewController alloc] initWithRootViewController:vc_1];
    NavViewController *nvc_0 = [[NavViewController alloc] initWithRootViewController:vc_2];
    NavViewController *nvc_2 = [[NavViewController alloc] initWithRootViewController:vc_3];
    
    NSArray *arr_vc = @[nvc_0, nvc_1,nvc_2];
    NSArray *arr_txt = @[ kJL_TXT("device"),kJL_TXT("update"),kJL_TXT("setting")];
    NSArray *arr_img = @[@"tab_icon_bt_nol", @"tab_icon_update_nol",@"tab_icon_settle_nol"];
    NSArray *arr_img_sel = @[@"tab_icon_bt_sel", @"tab_icon_update_sel",@"tab_icon_settle_sel"];
    
    for (int i = 0; i < arr_vc.count; i++) {
        NavViewController *nvc = arr_vc[i];
        /*--- TabBarItem的名字 ---*/
        nvc.tabBarItem.title = arr_txt[i];
        
        /*--- 使用原图片作为底部的TabBarItem ---*/
        UIImage *image = [UIImage imageNamed:arr_img[i]];
        UIImage *image_sel = [UIImage imageNamed:arr_img_sel[i]];
        nvc.tabBarItem.image = [self imageAlwaysOriginal:image];
        nvc.tabBarItem.selectedImage = [self imageAlwaysOriginal:image_sel];
        [nvc.tabBarController.tabBar setHidden:NO];
        nvc.navigationBarHidden = NO;

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
