//
//  DFHttp1.h
//  DFUnits
//
//  Created by 杰理科技 on 2021/4/1.
//  Copyright © 2021 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(UInt8, DF_HTTP1_Result) {
    DF_HTTP1_ResultFail         = 0x00, //下载失败
    DF_HTTP1_ResultSuccess      = 0x01, //下载成功
    DF_HTTP1_ResultStart        = 0x02, //开始下载
    DF_HTTP1_ResultDownload     = 0x03, //正在下载
    DF_HTTP1_ResultCancel       = 0x04, //正在取消

};

typedef void(^DF_HTTP1_BK)(float progress,NSData *__nullable data, DF_HTTP1_Result result);

@interface DFHttp1 : NSObject
-(void)httpDownload:(NSString*)url Result:(DF_HTTP1_BK __nullable)result;
-(void)httpCancelTask;
@end

NS_ASSUME_NONNULL_END
