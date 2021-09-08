//
//  JL_SDM_Header.h
//  JL_BLEKit
//
//  Created by EzioChan on 2021/4/8.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#ifndef JL_SDM_Header_h
#define JL_SDM_Header_h

#import <Foundation/Foundation.h>
#import "JL_SDM_Stress.h"
#import "JL_SDM_Altitude.h"
#import "JL_SDM_MaxOxg.h"
#import "JL_SDM_RecTime.h"
#import "JL_SDM_HeartRate.h"
#import "JL_SDM_MoveSteps.h"
#import "JL_SDM_TrainLoad.h"
#import "JL_SDM_AirPressure.h"
#import "JL_SDM_OxSaturation.h"
#import "JL_SDM_SportMessage.h"
#import "JL_MSG_Weather.h"
#import "JL_MSG_Func.h"
#import "JLWatchEnum.h"
#import "NfcModel.h"

///心率
typedef void(^JL_CB_HeartRate)(JL_SDM_HeartRate *heartRate);
///气压
typedef void(^JL_CB_AirPressure)(JL_SDM_AirPressure *ap);
///海拔
typedef void(^JL_CB_Altitude)(JL_SDM_Altitude *altitude);
///运动步数
typedef void(^JL_CB_MoveSteps)(JL_SDM_MoveSteps *ms);
///压力检测
typedef void(^JL_CB_Stress)(JL_SDM_Stress *stress);
///血氧饱和度
typedef void(^JL_CB_Oxsaturation)(JL_SDM_OxSaturation *oxs);
///训练负荷
typedef void(^JL_CB_TrainLoad)(JL_SDM_TrainLoad *tl);
///最大摄氧量
typedef void(^JL_CB_MaxOxg)(JL_SDM_MaxOxg *mo);
///运动恢复时间
typedef void(^JL_CB_RecTime)(JL_SDM_RecTime *rt);
///运动信息
typedef void(^JL_CB_SportMsg)(JL_SDM_SportMessage *sm);
///传感器log
typedef void(^JL_CB_WatchLog)(WATCH_LOG_TYPE type,NSData *data);

//MARK:设置相关
///天气设置回调
typedef void(^JL_CB_Weather)(BOOL succeed);


#endif /* JL_SDM_Header_h */
