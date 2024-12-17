//
//  WebViewController.h
//  JL_OTA
//
//  Created by 李放 on 2024/11/28.
//  Copyright © 2024 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "JL_RunSDK.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WebType) {
    PrivacyPolicyType, // 隐私政策
    UserProfileType,   // 用户协议
    ICPType            // ICP官网
};

@interface WebViewController : UIViewController

@property (assign, nonatomic)  int webType; // PrivacyPolicyType(隐私政策)、UserProfileType(用户协议)、ICPType(ICP官网)

@property (strong, nonatomic) NSString *icpTitleName; // ICP页面标题名称

@end

NS_ASSUME_NONNULL_END
