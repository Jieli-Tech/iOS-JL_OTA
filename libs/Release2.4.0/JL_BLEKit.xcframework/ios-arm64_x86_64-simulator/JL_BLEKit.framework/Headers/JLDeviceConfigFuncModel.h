//
//  JLDeviceConfigFuncModel.h
//  JL_BLEKit
//
//  Created by EzioChan on 2022/10/31.
//  Copyright © 2022 www.zh-jieli.com. All rights reserved.
//

#import "ECOneToMorePtl.h"

NS_ASSUME_NONNULL_BEGIN

//MARK: - 必须功能

/// 必须功能
@interface JLDeviceBasicFuncModel : NSObject

/// 支持OTA
@property(nonatomic,assign)BOOL spOTA;

/// 支持资源更新
@property(nonatomic,assign)BOOL spSourceUpdate;

/// 支持表盘增加/删除/查询
@property(nonatomic,assign)BOOL spDialOperation;

/// 支持表盘切换
@property(nonatomic,assign)BOOL spDialSwitch;

/// 支持表盘预览
@property(nonatomic,assign)BOOL spDialPreview;


-(instancetype)init:(NSData *)data;

@end

//MARK: - 系统功能
/// 系统功能
@interface JLDeviceSystemFuncModel : NSObject

/// 支持屏幕设置
@property(nonatomic,assign)BOOL spScreenSetting;
/// 支持震动强度
@property(nonatomic,assign)BOOL spVibrationIntensity;
/// 支持勿扰模式
@property(nonatomic,assign)BOOL spDoNotDisturb;
/// 支持锻炼设置
@property(nonatomic,assign)BOOL spExerciseSettings;
/// 支持断开提醒
@property(nonatomic,assign)BOOL spDisconnectReminder;

-(instancetype)init:(NSData *)data;

@end

//MARK: - 功能选项
/// 功能选项
@interface JLDeviceExportFuncModel : NSObject
/// 支持常用联系人
@property(nonatomic,assign)BOOL spTopContacts;
/// 支持音乐文件浏览
@property(nonatomic,assign)BOOL spMusicFileBrows;
/// 音乐文件删除、传输
@property(nonatomic,assign)BOOL spMusicFileOp;
/// 支持闹钟设置
@property(nonatomic,assign)BOOL spAlarmSettings;
/// 支持信息同步
@property(nonatomic,assign)BOOL spSyncInfo;
/// 支持天气同步
@property(nonatomic,assign)BOOL spSyncWeather;
/// 支持找手机/设备
@property(nonatomic,assign)BOOL spFindPhoneOrDevice;
/// Ai 云功能
@property(nonatomic,assign)BOOL spAiCloud;
/// Ai 表盘
@property(nonatomic,assign)BOOL spAiDial;
/// 平台接口信息获取
@property(nonatomic,assign)BOOL spOpenInfo;
/// 支持4G模块
@property(nonatomic,assign)BOOL sp4GModel;

/// 支持表盘信息拓展
@property(nonatomic,assign)BOOL spDialInfoExtend;

-(instancetype)init:(NSData *)data;

@end

//MARK: - 运动健康

/// 手表综合功能支持
@interface JLHealthFuncComprehensive : NSObject

/// 支持健康监控
@property(nonatomic,assign)BOOL spHealthMonitor;
/// 支持个人信息
@property(nonatomic,assign)BOOL spPersonInfo;
/// 支持睡眠检测
@property(nonatomic,assign)BOOL spSleepMonitor;
/// 支持运动心率提醒
@property(nonatomic,assign)BOOL spSportHeartRateRemind;
/// 支持久坐提醒
@property(nonatomic,assign)BOOL spSedentaryRemind;
/// 支持压力自动检测
@property(nonatomic,assign)BOOL spStressDetection;
/// 支持跌倒检测
@property(nonatomic,assign)BOOL spFallDetection;
/// 支持传感器设置
@property(nonatomic,assign)BOOL spSensorSetup;

-(instancetype)init:(NSData *)data;

@end

/// 手表运动模式支持功能
@interface JLHealthFuncSportModel : NSObject
/// 支持运动记录
@property(nonatomic,assign)BOOL spRecord;
/// 支持运动统计
@property(nonatomic,assign)BOOL spStatistics;
/// 支持室外运动
@property(nonatomic,assign)BOOL spOutdoor;
/// 支持室内运动
@property(nonatomic,assign)BOOL spIndoor;

-(instancetype)init:(NSData *)data;
@end

/// 手表计步功能支持功能
@interface JLHealthFuncGSensorModel : NSObject
/// 是否存在该传感器
@property(nonatomic,assign)BOOL spExist;
/// 支持运动步数
@property(nonatomic,assign)BOOL spStep;

-(instancetype)init:(NSData *)data;

@end


/// 手表心率功能支持功能
@interface JLHealthFuncHeartRateModel : NSObject
/// 是否存在该传感器
@property(nonatomic,assign)BOOL spExist;
/// 支持连续测试
@property(nonatomic,assign)BOOL spSerialTest;

-(instancetype)init:(NSData *)data;

@end

/// 手表血氧功能支持功能
@interface JLHealthFuncBloodOxygenModel : NSObject
/// 是否存在该传感器
@property(nonatomic,assign)BOOL spExist;

-(instancetype)init:(NSData *)data;

@end


/// 手表海拔功能支持功能
@interface JLHealthFuncAltitudeModel : NSObject
/// 是否存在该传感器
@property(nonatomic,assign)BOOL spExist;

-(instancetype)init:(NSData *)data;

@end

/// 手表GPS功能支持功能
@interface JLHealthFuncGPSModel : NSObject
/// 是否存在该传感器
@property(nonatomic,assign)BOOL spExist;

-(instancetype)init:(NSData *)data;

@end



@interface JLDeviceHealthFuncModel : NSObject

/// 手表综合功能支持
@property(nonatomic,strong)JLHealthFuncComprehensive *spComprehensive;
/// 手表运动模式支持功能
@property(nonatomic,strong)JLHealthFuncSportModel *spSportModel;
/// 手表计步功能支持功能
@property(nonatomic,strong)JLHealthFuncGSensorModel *spGSensor;
/// 手表心率功能支持功能
@property(nonatomic,strong)JLHealthFuncHeartRateModel *spHeartRate;
/// 手表血氧功能支持功能
@property(nonatomic,strong)JLHealthFuncBloodOxygenModel *spBloodOxygen;
/// 手表海拔功能支持功能
@property(nonatomic,strong)JLHealthFuncAltitudeModel *spAltitude;
/// 手表GPS功能支持功能
@property(nonatomic,strong)JLHealthFuncGPSModel *spGPS;

-(instancetype)init:(NSData *)data;

@end

//MARK: - 设备配置信息

/// 设备配置信息
@interface JLDeviceConfigBasic:NSObject
/// 产品标志类型
/// 0 - 手表
/// 1 - TWS耳机
@property(nonatomic,assign)int deviceType;
/// 版本
@property(nonatomic,assign)int version;

/// 数据
@property(nonatomic,copy)NSData *basicData;

/// 功能配置所属设备的UUID
@property(nonatomic,strong)NSString  * _Nullable mbleIdentifyStr;

-(instancetype)init:(NSData *)data;

@end

//MARK: - 手表配置信息数据结构解析

/// 手表配置信息数据结构
@interface JLDeviceConfigModel:JLDeviceConfigBasic
/// - 必须功能
@property(nonatomic,strong)JLDeviceBasicFuncModel *basicFunc;
/// - 系统功能
@property(nonatomic,strong)JLDeviceSystemFuncModel *systemFunc;
/// - 功能选项
@property(nonatomic,strong)JLDeviceExportFuncModel * exportFunc;
/// - 运动健康
@property(nonatomic,strong)JLDeviceHealthFuncModel *healthFunc;

@end

NS_ASSUME_NONNULL_END
