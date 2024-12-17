//
//  RTC_RingInfo.h
//  JL_BLEKit
//
//  Created by 杰理科技 on 2021/10/15.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 闹铃信息
@interface RTC_RingInfo : NSObject

/// 铃声类型
/// 0x00 设备默认
/// 0x01 多媒体选取
@property (assign,nonatomic) uint8_t        type;

/// 设备索引
/// 当type = 0时，dev保留
/// 当type = 1时，dev为选取的设备
@property (assign,nonatomic) uint8_t        dev;

/// 闹铃文件簇号
/// 当type = 0时，clust 为对应 JLModel_Ring 的 index
/// 当type = 1时，clust为选取的闹铃文件簇号
@property (assign,nonatomic) uint32_t       clust;

/// 铃声名称长度
@property (assign,nonatomic) uint8_t        len;

/// 铃声名称
@property (strong,nonatomic) NSData         *data;

@end

NS_ASSUME_NONNULL_END
