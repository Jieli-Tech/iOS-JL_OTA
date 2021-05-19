//
//  JL_Handle.h
//  JL_BLEKit
//
//  Created by zhihui liang on 2018/11/10.
//  Copyright © 2018 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JL_BLEApple.h"
#import "JL_RCSP.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  收到设备返回的XM_PKG的回调。
 */
extern NSString *kJL_CMD_RECEIVE;       //XM_RCSP【接收】

@interface JL_Handle : NSObject

+(id)sharedMe;

/**
 向设备发送JL_PKG数据包。
 
 @param pkg JL_PKG数据模型
 */
+(void)handleSendPackage:(JL_PKG*)pkg;

/**
 整理JL_PKG

 @param pkg JL_PKG数据模型
 @return 数据
 */
+(NSData*)handlePackage:(JL_PKG*)pkg;
@end

NS_ASSUME_NONNULL_END
