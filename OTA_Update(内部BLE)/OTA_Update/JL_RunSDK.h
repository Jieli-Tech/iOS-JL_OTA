//
//  JL_RunSDK.h
//  JL_BLE_TEST
//
//  Created by DFung on 2018/11/26.
//  Copyright © 2018 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_BLEKit.h>
#import <DFUnits/DFUnits.h>

/*--- 多语言 ---*/
#define kJL_GET         [DFUITools systemLanguage]          //获取系统语言
#define kJL_SET(lan)    [DFUITools languageSet:@(lan)]      //设置系统语言
//多语言转换,"Localizable"根据项目的多语言包填写。
#define kJL_TXT(key)    [DFUITools languageText:@(key) Table:@"Localizable"]

//iPhoneX系列
//判断是否是ipad
#define kJL_IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kJL_IS_IPHONE_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !kJL_IS_IPAD : NO)
//判断iPhone5系列
#define kJL_IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !kJL_IS_IPAD : NO)
//判断iPhone6系列
#define kJL_IS_IPHONE_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !kJL_IS_IPAD : NO)
//判断iphone6+系列
#define kJL_IS_IPHONE_6_PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !kJL_IS_IPAD : NO)
//判断iPhoneX
#define kJL_IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !kJL_IS_IPAD : NO)
//判断iPHoneXr
#define kJL_IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !kJL_IS_IPAD : NO)
//判断iPhoneXs
#define kJL_IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !kJL_IS_IPAD : NO)
//判断iPhoneXs Max
#define kJL_IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !kJL_IS_IPAD : NO)

#define kJL_BarStatus ((kJL_IS_IPHONE_X==YES || kJL_IS_IPHONE_Xr ==YES || kJL_IS_IPHONE_Xs== YES || kJL_IS_IPHONE_Xs_Max== YES) ? 44.0 : 20.0)
#define kJL_BarHead   ((kJL_IS_IPHONE_X==YES || kJL_IS_IPHONE_Xr ==YES || kJL_IS_IPHONE_Xs== YES || kJL_IS_IPHONE_Xs_Max== YES) ? 88.0 : 64.0)
#define kJL_BarFoot   ((kJL_IS_IPHONE_X==YES || kJL_IS_IPHONE_Xr ==YES || kJL_IS_IPHONE_Xs== YES || kJL_IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)

NS_ASSUME_NONNULL_BEGIN
extern NSString *kUI_JL_BLE_STATUS_DEVICE;
extern NSString *kUI_JL_BLE_PAIR_ERR;
extern NSString *kUI_JL_UPDATE_STATUS;
extern NSString *kUI_JL_OTA_UPDATE;

@interface JL_RunSDK : NSObject
@end
NS_ASSUME_NONNULL_END
