//
//  JLToneCfgModel.h
//  JLWtsToCfgLib
//
//  Created by EzioChan on 2024/1/22.
//  Copyright © 2024 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLToneCfgModel : NSObject

/// 提示音文件名称
@property(nonatomic, copy) NSString *fileName;

/// 提示音文件内容
@property(nonatomic, copy) NSData *data;

@end

NS_ASSUME_NONNULL_END
