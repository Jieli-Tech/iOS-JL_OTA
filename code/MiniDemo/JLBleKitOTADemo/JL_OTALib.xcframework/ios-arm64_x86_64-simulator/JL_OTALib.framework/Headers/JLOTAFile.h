//
//  JLOTAFile.h
//  JL_OTALib
//
//  Created by EzioChan on 2024/7/26.
//  Copyright © 2024 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(UInt8, JL_OTAUrlResult) {
    JL_OTAUrlResultSuccess          = 0x00, //OTA文件获取成功
    JL_OTAUrlResultFail             = 0x01, //OTA文件获取失败
    JL_OTAUrlResultDownloadFail     = 0x02, //OTA文件下载失败
};

typedef void(^JL_OTA_URL)(JL_OTAUrlResult result,
                          NSString* __nullable version,
                          NSString* __nullable url,
                          NSString* __nullable explain);

@interface JLOTAFile : NSObject


#pragma mark -文件下载
/**
 文件下载
 @param key 授权key
 @param code 授权code
 @param result 回复
 */
-(void)cmdGetOtaFileKey:(NSString*)key
                   Code:(NSString*)code
                 Result:(JL_OTA_URL __nullable)result;

/**
 OTA升级文件下载【MD5】
@param key 授权key
@param code 授权code
@param hash  MD5值
@param result 回复
*/
-(void)cmdGetOtaFileKey:(NSString*)key
                   Code:(NSString*)code
                   hash:(NSString*)hash
                 Result:(JL_OTA_URL __nullable)result;

@end

NS_ASSUME_NONNULL_END
