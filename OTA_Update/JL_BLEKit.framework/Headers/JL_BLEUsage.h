//
//  JL_BLEUsage.h
//  JL_BLEKit
//
//  Created by zhihui liang on 2018/11/10.
//  Copyright © 2018 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "JL_Handle.h"

NS_ASSUME_NONNULL_BEGIN
#define kUI_JL_BLE_FOUND            @"UI_JL_BLE_FOUND"
#define kUI_JL_BLE_FOUND_SINGLE     @"UI_JL_BLE_FOUND_SINGLE"
#define kUI_JL_BLE_PAIRED           @"UI_JL_BLE_PAIRED"
#define kUI_JL_BLE_DISCONNECTED     @"UI_JL_BLE_DISCONNECTED"
#define kUI_JL_BLE_ON               @"UI_JL_BLE_ON"
#define kUI_JL_BLE_OFF              @"UI_JL_BLE_OFF"

@class JL_Entity;
@interface JL_BLEUsage : NSObject
@property(nonatomic,strong)JL_BLEApple      *bt_ble;                    //蓝牙操作实例
@property(nonatomic,strong)JL_Handle        *bt_handle;                 //蓝牙数据流分包中心
@property(nonatomic,strong)NSArray          *bt_EntityList;             //蓝牙设备列表
@property(nonatomic,strong)JL_Entity        *bt_Entity;                 //当前设备
@property(nonatomic,strong)NSString         *bt_name;                   //当前设备名字
@property(nonatomic,strong)NSUUID           *bt_uuid;                   //当前设备UUID
@property(nonatomic,assign)BOOL             bt_status_phone;            //手机蓝牙是否开启
@property(nonatomic,assign)BOOL             bt_status_connect;          //设备是否连接
@property(nonatomic,assign)BOOL             bt_status_paired;           //设备是否配对
+(id)sharedMe;
-(void)rename:(NSString*)name withUuid:(NSString*)uuid;
@end

@interface JL_Entity  : NSObject                                //蓝牙设备模型
@property(assign,nonatomic)int            mIndex;
@property(assign,nonatomic)NSString       *mUUID;
@property(assign,nonatomic)float          mDistance;
@property(strong,nonatomic)NSNumber       *mRSSI;
@property(strong,nonatomic)NSString       *mItem;
@property(strong,nonatomic)CBPeripheral   *mPeripheral;
@property(assign,nonatomic)int            mType;            //-1:传统音箱 0:AI音箱 1:蓝牙对耳 2:数码充电仓
@property(assign,nonatomic)BOOL           isSelectedStatus;
@property(assign,nonatomic)BOOL           isExclusive;
@property(assign,nonatomic)BOOL           isBound;
@property(assign,nonatomic)BOOL           isEdrLinked;
@property(assign,nonatomic)BOOL           isCharging;
@property(assign,nonatomic)BOOL           isCharging_L;
@property(assign,nonatomic)BOOL           isCharging_R;
@property(assign,nonatomic)BOOL           isCharging_C;
@property(assign,nonatomic)uint8_t        mPower;
@property(assign,nonatomic)uint8_t        mPower_L;
@property(assign,nonatomic)uint8_t        mPower_R;
@property(assign,nonatomic)uint8_t        mPower_C;
@property(strong,nonatomic)NSString       *mVID;
@property(strong,nonatomic)NSString       *mPID;
@property(strong,nonatomic)NSString       *mEdr;
@property(assign,nonatomic)uint8_t        mChipType;        //0：690x 1：692x 2：693x
@property(assign,nonatomic)uint8_t        mProtocolType;    //默认0x00
/**
 0x00 - dismiss 不显示弹窗
 0x01 - unconnected 经典蓝牙未连接
    iOS : 不显示电量，请手动连接XXX
    Android：不显示电量，显示连接按钮
 0x02 - connected 经典蓝牙已连接
    iOS：判断已连接的经典蓝牙名是否一致，若未连接或蓝牙名不一致，
         显示“设备已被占用”。若一致，显示电量等信息。
    Android：判断已连接的经典蓝牙Mac是否一致，若未连接或蓝牙Mac不一致，
             显示“设备已被占用”。若一致，显示电量等信息。
 0x03 - connecting 设备正在自动回连
    Android 和 iOS 显示“设备正在自动回连 ”
 0x04 - connectionless 设备不可连接（需要按下配对按键）
    Android 和 iOS 显示配对操作方式
 */
@property(assign,nonatomic)int8_t         mScene;
@property(assign,nonatomic)uint8_t        mSeq;             //Seq 每次开机会加 1，用于app区分是否同一次开机
@property(assign,nonatomic)uint8_t        mTWS_Paired;      //TWS配对标识，0:未配对 1:已配对
@property(assign,nonatomic)uint8_t        mTWS_Cap;         //0:关盖 1:开盖
@property(assign,nonatomic)uint8_t        mTWS_Mode;        //0:充电模式 1:发射模式
@property(strong,nonatomic)NSData         *mAdvData;
@end
NS_ASSUME_NONNULL_END
