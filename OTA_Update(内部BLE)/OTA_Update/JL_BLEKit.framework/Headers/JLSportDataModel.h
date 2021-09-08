//
//  JLSportDataModel.h
//  Test
//
//  Created by EzioChan on 2021/4/6.
//  Copyright © 2021 Zhuhai Jieli Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JL_SDM_Chart.h"


typedef enum : NSInteger{
    ///心率
    Sp_Heartbeat = 0,
    ///空气压强
    Sp_Air_Pressure ,
    ///海拔高度
    Sp_Altitude,
    ///运动步数
    Sp_Movement_Steps,
    ///压力测试
    Sp_Stress,
    ///血氧饱和度
    Sp_Oxygen_Saturation ,
    ///训练负荷
    Sp_Training_Load,
    ///最大摄氧量
    Sp_Max_Oxygen_Uptake ,
    ///运动恢复时间
    Sp_Recovery_Time,
    ///运动信息
    Sp_Sport_Message,
} SportDataModel;

typedef enum : NSUInteger {
    ///跑步
    Sp_Model_Run,
    ///爬山
    Sp_Model_Climb,
    ///游泳
    Sp_Model_Swim,
} SportPatternModel;

NS_ASSUME_NONNULL_BEGIN

@interface JLSportDataModel : NSObject

/// 设备的UUID
@property(nonatomic,strong)NSString *dev_uuid;

/// 请求内容数据
@property(nonatomic,strong)NSData *rqData;


/// 图表的数据模型
@property(nonatomic,strong)JL_SDM_Chart *chartModel;



@end

NS_ASSUME_NONNULL_END
