//
//  JL_SDM_Chart.h
//  JL_BLEKit
//
//  Created by EzioChan on 2021/4/16.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JL_SDM_TimeData : NSObject
/// 数值
@property(nonatomic,assign)NSInteger num;
/// 时间
@property(nonatomic,strong)NSDate * _Nonnull date;

@end

NS_ASSUME_NONNULL_BEGIN

@interface JL_SDM_Chart : NSObject

/// 开始时间戳
@property(nonatomic,strong)NSDate *startDate;

/// 间隔
@property(nonatomic,assign)UInt8 interval;

/// 版本
@property(nonatomic,assign)UInt8 version;

/// 数据数组
@property(nonatomic,strong)NSMutableArray<JL_SDM_TimeData *> *dataArray;

///源数据
@property(nonatomic,strong)NSData *dt;

/// 创造一个图表对象
/// @param dt 裸数据
/// @param interval 间隔
/// @param array 数组内容
+(JL_SDM_Chart*)initDate:(NSDate*)dt interval:(UInt8)interval Datas:(NSMutableArray *)array;

/// 根据数据来解析一个图表对象
/// @param data 数据块
/// @param format 数据格式
+(JL_SDM_Chart *)initByData:(NSData *)data dataByte:(NSInteger)format;

@end

NS_ASSUME_NONNULL_END
