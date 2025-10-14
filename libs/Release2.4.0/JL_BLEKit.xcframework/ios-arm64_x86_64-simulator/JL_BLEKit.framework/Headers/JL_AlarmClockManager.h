//
//  JL_AlarmClockManager.h
//  JL_BLEKit
//
//  Created by EzioChan on 2021/12/16.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JLModel_AlarmSetting.h>
#import <JL_BLEKit/RTC_RingInfo.h>
#import <JL_BLEKit/JL_TypeEnum.h>
#import <JL_BLEKit/JLModel_RTC.h>
#import <JL_BLEKit/JLModel_Ring.h>
#import <JL_BLEKit/JL_FunctionBaseManager.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(UInt8, JL_RtcOperate) {
    JL_FlashOperateFlagRead             = 0x00, //读取
    JL_FlashOperateFlagWrite            = 0x01, //设置
};

typedef void(^JL_RTC_ALARM_BK)(NSArray <JLModel_AlarmSetting *>* __nullable array, uint8_t flag);

typedef void(^JL_RTC_GET_ALARM_BK)(NSArray <JLModel_RTC *>* __nullable alarms,NSError * __nullable error);

#pragma mark ---> 闹钟响与停止
///闹钟正在响
extern NSString *kJL_MANAGER_RTC_RINGING;

///闹钟停止响
extern NSString *kJL_MANAGER_RTC_RINGSTOP;

//闹钟铃声试听
extern NSString *kJL_MANAGER_RTC_AUDITION;


/// RTC闹钟管理者
@interface JL_AlarmClockManager : JL_FunctionBaseManager

///RTC 版本
@property (assign,nonatomic) uint8_t             rtcVersion;
///是否支持闹铃设置
@property (assign,nonatomic) JL_RTCAlarmType     rtcAlarmType;
///设备当前时间
@property (strong,nonatomic) JLModel_RTC         *rtcModel;
///设备闹钟数组
@property (strong,nonatomic) NSMutableArray<JLModel_RTC *>      *rtcAlarms;
///默认铃声
@property (strong,nonatomic) NSMutableArray<JLModel_Ring *>      *rtcDfRings;


/// 查询设备闹钟
/// - Parameter result: 设备回调
-(void)cmdRtcGetAlarms:(JL_RTC_GET_ALARM_BK)result;


/// 设置/增加闹钟
/// - Parameters:
///   - array: array 闹钟模型数组
///   - result: 结果回调
-(void)cmdRtcSetArray:(NSArray<JLModel_RTC *>*)array Result:(JL_CMD_RESPOND __nullable)result;


/// 删除闹钟
/// - Parameters:
///   - array: 闹钟序号数组
///   - result: 设备回复
-(void)cmdRtcDeleteIndexArray:(NSArray<NSNumber *>*)array Result:(JL_CMD_RESPOND __nullable)result;


/// 停止闹钟响声
/// - Parameter result: 设备回复
-(void)cmdRtcStopResult:(JL_CMD_RESPOND __nullable)result;


/// 闹钟试听响铃
/// - Parameters:
///   - rtc: 闹钟模型
///   - option: 启停标记
///   - result: 设备回复
-(void)cmdRtcAudition:(JLModel_RTC *)rtc Option:(BOOL)option result:(JL_CMD_RESPOND __nullable)result;


/// 闹铃设置
/// @param operate 0x00:读取 0x01:设置
/// @param index 掩码 (0x01设置第1个闹钟，0x03设置第一个和第二个闹钟)
/// @param setting 设置选项，读取时无需传入
/// @param result 设备回复
-(void)cmdRtcOperate:(JL_RtcOperate)operate
               Index:(uint8_t)index
             Setting:(JLModel_AlarmSetting* __nullable)setting
              Result:(JL_RTC_ALARM_BK __nullable)result;


/// 解析闹钟数据内容
/// @param infoData 数据内容
/// @param ltvVersion LTV的版本
-(void)parseData:(NSData *)infoData WithLtyType:(uint8_t)ltvVersion;

/// 【闹钟信息】解析
/// - Parameters:
///   - data: 需要解析的数据
///   - rtcType: RTC类型
+(NSMutableArray<JLModel_RTC*> *)makeOutRtc:(NSData*)data RtcType:(uint8_t)rtcType;


/// [默认闹钟铃声]解析
/// - Parameter data: [默认闹钟铃声]数据
+(NSMutableArray<JLModel_Ring*> *)makeOutRtcDefaultRing:(NSData *)data;


@end

NS_ASSUME_NONNULL_END
