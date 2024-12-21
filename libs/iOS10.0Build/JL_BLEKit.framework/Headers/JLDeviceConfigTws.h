//
//  JLDeviceConfigTws.h
//  JL_BLEKit
//
//  Created by EzioChan on 2024/1/23.
//  Copyright © 2024 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLDeviceConfigFuncModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLDeviceConfigTws : JLDeviceConfigBasic

/// 是否支持替换提示音
@property(nonatomic, assign)BOOL isSupportReplaceTipsVoice;

@end

NS_ASSUME_NONNULL_END
