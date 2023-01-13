//
//  BroadcastMainViewController.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/28.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "BroadcastMainViewController.h"
#import "UpdateViewController.h"
#import "BroadcastViewController.h"
#import "FileViewController.h"
#import "NavViewController.h"

@implementation BroadcastMainViewController


+ (UITabBarController *)prepareViewControllers {
    BroadcastViewController *vc_1 = [BroadcastViewController new];
    FileViewController *vc_2 = [[FileViewController alloc] init];
    UpdateViewController *vc_3 = [UpdateViewController new];
    
    NavViewController *nvc_0 = [[NavViewController alloc] initWithRootViewController:vc_1];
    NavViewController *nvc_1 = [[NavViewController alloc] initWithRootViewController:vc_2];
    NavViewController *nvc_2 = [[NavViewController alloc] initWithRootViewController:vc_3];
    
    NSArray *arr_vc = @[nvc_0, nvc_1,nvc_2];
    NSArray *arr_txt = @[ kJL_TXT("connect"),kJL_TXT("file"),kJL_TXT("update")];
    NSArray *arr_img = @[@"tab_icon_bt_nol",@"tab_icon_file_nol", @"tab_icon_update_nol"];
    NSArray *arr_img_sel = @[@"tab_icon_bt_sel",@"tab_icon_file_sel", @"tab_icon_update_sel"];
    
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
