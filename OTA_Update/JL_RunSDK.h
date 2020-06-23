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

NS_ASSUME_NONNULL_BEGIN
extern NSString *kUI_JL_BLE_STATUS_DEVICE;
extern NSString *kUI_JL_BLE_PAIR_ERR;
extern NSString *kUI_JL_UPDATE_STATUS;

@interface JL_RunSDK : NSObject
@end
NS_ASSUME_NONNULL_END
