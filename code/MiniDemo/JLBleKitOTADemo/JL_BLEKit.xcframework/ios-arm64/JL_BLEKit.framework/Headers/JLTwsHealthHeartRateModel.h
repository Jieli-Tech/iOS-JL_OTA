//
//  JLTwsHealthHeartRateModel.h
//  JL_BLEKit
//
//  Created by EzioChan on 2025/12/9.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLTwsHealthHeartRateModel : NSObject

/// 全天心率数组，需要使用小文件格式解析进行解读
@property (strong, nonatomic) NSArray <NSData *> *heartRateList;

-(JLTwsHealthHeartRateModel *)initWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
