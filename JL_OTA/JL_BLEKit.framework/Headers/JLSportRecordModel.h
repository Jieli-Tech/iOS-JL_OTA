//
//  JLSportRecordModel.h
//  JL_BLEKit
//
//  Created by EzioChan on 2021/4/29.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum :uint8_t {
    SRM_OutSide = 0x01,//室内运动
    SRM_InSide = 0x02,//户外运动
} SportRecordModelType;

typedef enum:uint8_t{
    ///开始包
    SRM_Start = 0x00,
    ///基础包
    SRM_Basic = 0x01,
    ///暂停包
    SRM_Pause = 0x02,
    ///结束包
    SRM_End = 0xff,
} SRMDataType;

//MARK:- JL_SRM_DataFormat
@interface JL_SRM_DataFormat : NSObject
/// 数据包类型
@property(nonatomic,assign)SRMDataType type;
/// 开始运动时间
@property(nonatomic,strong)NSDate *startDate;
/// 暂停时间包
@property(nonatomic,strong)NSDate *pauseDate;
/// 结束时间包
@property(nonatomic,strong)NSDate *endDate;
/// 心率
@property(nonatomic,assign)NSInteger heartRate;
/// 速度
@property(nonatomic,assign)NSInteger speed;
/// 血氧浓度
@property(nonatomic,assign)NSInteger oxy;
///原始数据长度
@property(nonatomic,assign)NSInteger length;
@end


//MARK:- JLSportRecordModel
@interface JLSportRecordModel : NSObject

/// 运动模式
@property(nonatomic,assign)SportRecordModelType modelType;
/// 版本号
@property(nonatomic,assign)UInt8 version;

///保留位2
@property(nonatomic,strong)NSData *reservedBit2;
///间隔
///有效范围:1~180 , 单位是秒
@property(nonatomic,assign)NSInteger interval;

/// 保留位
@property(nonatomic,strong)NSData *reservedBit;

///运动数据列表
@property(nonatomic,strong)NSArray<JL_SRM_DataFormat*> *dataArray;

/// 运动时长
///有效范围: 1-28800，单位是秒
@property(nonatomic,assign)NSInteger duration;

/// 距离
/// 有效范围: 1- 65535，单位是0.01公里（10米）
@property(nonatomic,assign)NSInteger distance;

/// 热量
///有效范围: 1- 65535 ,  单位是千卡，Kcal
@property(nonatomic,assign)NSInteger calories;

///步数
///有效范围: 0 - 200000, 单位是步
@property(nonatomic,assign)NSInteger step;

/// 恢复时间
/// 时间格式是：HH:mm
@property(nonatomic,strong)NSString *recoveryTime;


/// 初始化一个运动记录数据
/// @param data 数据内容
+(JLSportRecordModel *)initWithData:(NSData *)data;


@end

NS_ASSUME_NONNULL_END
