//
//  GCDWebKit.h
//  GCDWebServerDemo
//
//  Created by 杰理科技 on 2021/11/8.
//  Copyright © 2021 shapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDWebUploader.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(UInt8, GCDWebKitStatus) {
    GCDWebKitStatusStart        = 0x00, //开始
    GCDWebKitStatusFail         = 0x01, //失败
    GCDWebKitStatusUpload       = 0x02, //上传
    GCDWebKitStatusMove         = 0x03, //移动
    GCDWebKitStatusDelete       = 0x04, //删除
    GCDWebKitStatusCreate       = 0x05, //创建
    GCDWebKitStatusWifiDisable  = 0x06, //WiFi关闭
};
typedef void(^GCDWebKit_BK)(GCDWebKitStatus status,
                            NSString *__nullable ipAdress,
                            NSInteger port);

@interface GCDWebKit: NSObject

+(void)startWithResult:(GCDWebKit_BK __nullable)result;

+(void)stop;

@end

NS_ASSUME_NONNULL_END
