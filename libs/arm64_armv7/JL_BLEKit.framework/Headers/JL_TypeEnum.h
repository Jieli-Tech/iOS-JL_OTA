//
//  JL_TypeEnum.h
//  JL_BLEKit
//
//  Created by DFung on 2018/11/29.
//  Copyright © 2018 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JLModel_SmallFile.h>

typedef NS_ENUM(NSInteger, JL_BLEStatus) {
    JL_BLEStatusFound,                      //发现设备，对应 kUI_JL_BLE_FOUND
    JL_BLEStatusPaired,                     //已配对，  对应 kUI_JL_BLE_PAIRED
    JL_BLEStatusDisconnected,               //断开连接，对应 kUI_JL_BLE_DISCONNECTED
    JL_BLEStatusOn,                         //蓝牙开启，对应 kUI_JL_BLE_ON
    JL_BLEStatusOff,                        //蓝牙关闭，对应 kUI_JL_BLE_OFF
    JL_BLEStatusUnknown,                    //状态未知
};
typedef NS_ENUM(NSInteger, JL_DeviceBTStatus) {
    JL_DeviceBTStatusDisconnected   = 0,    //设备经典蓝牙已断开
    JL_DeviceBTStatusConnected      = 1,    //设备经典蓝牙已连接
    JL_DeviceBTStatusUnknown,
};
typedef NS_ENUM(UInt8, JL_CMDStatus) {
    JL_CMDStatusSuccess             = 0x00, //成功
    JL_CMDStatusFail                = 0x01, //失败
    JL_CMDStatusUnknownCmd          = 0x02, //未定义命令
    JL_CMDStatusBusy                = 0x03, //忙碌
    JL_CMDStatusNoResponse          = 0x04, //没有收到回复
    JL_CMDStatusCrcErr              = 0x05, //CRC错误
    JL_CMDStatusDataCrcErr          = 0x06, //数据CRC错误
    JL_CMDStatusParamErr            = 0x07, //参数错误
    JL_CMDStatusOverLimit           = 0x08, //数据溢出
    JL_CMDStatusLrcError            = 0x09, //LRC获取出错
    JL_CMDStatusUnknown,
};
typedef void(^JL_CMD_RESPOND)(JL_CMDStatus status, uint8_t sn, NSData* __nullable data);

//---------------------------------------------------------//


typedef NS_ENUM(UInt8,JL_AdvType) {
    JL_AdvTypeSoundBox              = 0,     //音箱类型
    JL_AdvTypeChargingBin           = 1,     //充电仓类型
    JL_AdvTypeTWS                   = 2,     //TWS耳机类型
    JL_AdvTypeHeadset               = 3,     //普通耳机类型
    JL_AdvTypeSoundCard             = 4,     //声卡类型
    JL_AdvTypeWatch                 = 5,     //手表类型
    JL_AdvTypeTradition             = 6,     //传统设备类型
};
typedef NS_ENUM(NSInteger,JL_DeviceType) {
    JL_DeviceTypeSoundBox           = 0,     //AI音箱类型
    JL_DeviceTypeChargingBin        = 1,     //充电仓类型
    JL_DeviceTypeTWS                = 2,     //TWS耳机类型
    JL_DeviceTypeHeadset            = 3,     //普通耳机类型
    JL_DeviceTypeSoundCard          = 4,     //声卡类型
    JL_DeviceTypeWatch              = 5,     //手表类型
    JL_DeviceTypeTradition          = -1,    //传统设备类型
};

typedef NS_ENUM(UInt8,JLDevSpecialType) {
    ///普通正常设备
    JLDevSpecialType_Normal = 0x00,
    ///回连设备
    JLDevSpecialType_Reconnect = 0x01,
};

typedef NS_ENUM(int64_t,JL_CLASS) {
    JL_CLASS_SmallFile      = 0,
    JL_CLASS_File           = 1,
    JL_CLASS_OTA            = 2,
    JL_CLASS_Flash          = 3,
    JL_CLASS_ChargingBin    = 4,
    JL_CLASS_AlarmClock     = 5,
    JL_CLASS_Light          = 6,
    JL_CLASS_Tws            = 7,
    JL_CLASS_SoundCard      = 8,
    JL_CLASS_Call           = 9,
    JL_CLASS_Speex          = 10,
    JL_CLASS_Lrc            = 11,
    JL_CLASS_FindDevice     = 12,
    JL_CLASS_MusicControl   = 13,
    JL_CLASS_Fm             = 14,
    JL_CLASS_SystemEQ       = 15,
    JL_CLASS_SystemTime     = 16,
    JL_CLASS_SystemVolume   = 17,
    JL_CLASS_Custom         = 18,
    JL_CLASS_Batch          = 19,
    JL_CLASS_DeviceLogs     = 20,
    JL_CLASS_BigData        = 21,
};

//---------------------------------------------------------//


