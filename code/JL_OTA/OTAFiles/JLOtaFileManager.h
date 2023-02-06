//
//  JLOtaFileManager.h
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/11.
//

#import <Foundation/Foundation.h>
#import "GCDWebKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLOtaFileManager : NSObject

/**
 *  初始化沙盒的ota升级文件
 *  转移NSBundle的文件到沙盒
 */
+ (void)initializeOtaFile;


@end

NS_ASSUME_NONNULL_END
