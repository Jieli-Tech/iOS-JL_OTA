//
//  JLModel_Ring.h
//  JL_BLEKit
//
//  Created by 杰理科技 on 2021/10/15.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLModel_Ring : NSObject

/// 默认铃声序号
/// alarm default rings index
@property(assign,nonatomic) uint8_t         index;

/// 默认铃声名称
/// alarm default rings name
@property(strong,nonatomic) NSString        *name;
@end

NS_ASSUME_NONNULL_END
