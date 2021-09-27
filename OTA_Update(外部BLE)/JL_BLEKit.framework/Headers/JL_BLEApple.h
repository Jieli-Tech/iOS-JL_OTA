//
//  JL_BLEApple.h
//  JL_BLEKit
//
//  Created by zhihui liang on 2018/11/10.
//  Copyright © 2018 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>
#import "JL_Tools.h"

NS_ASSUME_NONNULL_BEGIN
/**
 *  BLE状态通知
 */
extern NSString *kJL_BLE_FOUND;         //发现设备
extern NSString *kJL_BLE_FOUND_SINGLE;  //发现单个设备
extern NSString *kJL_BLE_PAIRED;        //已配对
extern NSString *kJL_BLE_CONNECTED;     //已连接
extern NSString *kJL_BLE_DISCONNECTED;  //断开连接
extern NSString *kJL_BLE_ON;            //BLE开启
extern NSString *kJL_BLE_OFF;           //BLE关闭
/**
 *  错误代码：
 *  4001  BLE未开启
 *  4002  BLE不支持
 *  4003  BLE未授权
 *  4004  BLE重置中
 *  4005  未知错误
 *  4006  连接失败
 *  4007  连接超时
 *  4008  特征值超时
 *  4009  配对失败
 *  4010  设备UUID无效
 */
extern NSString *kJL_BLE_ERROR;         //BLE报错

/**
 *  BLE数据通知
 */
extern NSString *kJL_RCSP_RECEIVE;      //Rcsp数据【接收】
extern NSString *kJL_RCSP_SEND;         //Rcsp数据【发送】
extern NSString *kJL_PAIR_RECEIVE;      //Pair数据【接收】
extern NSString *kJL_PAIR_SEND;         //Pair数据【发送】
extern NSString *kJL_UPDATE_SEND;       //Update数据【发送】

/**
 *  BLE特征值
 */
//extern NSString *JL_BLE_SERVICE;        //服务号
//extern NSString *JL_BLE_PAIR_W;         //配对【写】通道
//extern NSString *JL_BLE_PAIR_R;         //配对【读】通道
//extern NSString *JL_BLE_AUIDO_W;        //音频【写】通道
//extern NSString *JL_BLE_AUIDO_R;        //音频【读】通道
//extern NSString *JL_BLE_RCSP_W;         //命令【写】通道
//extern NSString *JL_BLE_RCSP_R;         //命令【读】通道

extern NSString *JL_EDR_CHANGE;         //经典蓝牙变化
extern NSString *JL_BLE_CHANGE_MASTER;  //耳机主从切换成功


/**
 *  记录上次BLE设备的UUID，准备重连！
 */
#define kJL_BLE_UUID        @"JL_BLE_UUID"

/**
 *  记录手机的虚拟地址
 */
#define kJL_IOS_ADDR        @"JL_IOS_ADDR"

@interface JL_BLEApple : NSObject
@property(nonatomic,strong)NSData *__nullable filterKey;    //过滤码
@property(nonatomic,strong)NSData *__nullable pairKey;      //配对码
@property(nonatomic,assign)BOOL BLE_FILTER_ENABLE;          //是否【开启过滤】
@property(nonatomic,assign)BOOL BLE_PAIR_ENABLE;            //是否【开启配对】
@property(nonatomic,assign)BOOL BLE_RELINK;                 //是否【被动重连】
@property(nonatomic,assign)BOOL BLE_RELINK_ACTIVE;          //是否【主动重连】
@property(nonatomic,assign)int  BLE_TIMEOUT;                //连接超时时间
@property(nonatomic,strong)NSMutableArray *bleHistoryPeripherals;//历史记录
@property(nonatomic,assign)BOOL isOpenHistory;

@property(nonatomic,strong) NSString *JL_BLE_SERVICE;        //服务号
@property(nonatomic,strong) NSString *JL_BLE_PAIR_W;         //配对【写】通道
@property(nonatomic,strong) NSString *JL_BLE_PAIR_R;         //配对【读】通道
@property(nonatomic,strong) NSString *JL_BLE_AUIDO_W;        //音频【写】通道
@property(nonatomic,strong) NSString *JL_BLE_AUIDO_R;        //音频【读】通道
@property(nonatomic,strong) NSString *JL_BLE_RCSP_W;         //命令【写】通道
@property(nonatomic,strong) NSString *JL_BLE_RCSP_R;         //命令【读】通道

/**
 开始搜索
 */
-(void)startScanBLE;

/**
 停止搜索
 */
-(void)stopScanBLE;

/**
 连接设备
 
 @param peripheral 蓝牙设备类
 */
-(void)connectBLE:(CBPeripheral*)peripheral;

/**
 重连设备
 */
-(void)connectLastPeripheral;

/**
 使用UUID，重连设备。
 */
-(void)connectPeripheralWithUUID:(NSString*)uuid;

/**
 断开连接
 */
-(void)disconnectBLE;

/**
 清连接记录
 */
-(void)cleanBLE;

/**
 发送配对数据
 
 @param data 数据
 @return 是否已发送
 */
-(BOOL)writePairData:(NSData*)data;

/**
 发送RCSP数据
 
 @param data 数据
 @return 是否已发送
 */
-(BOOL)writeRcspData:(NSData*)data;

/**
调整发数参数

@param isGame 是否为游戏模式
@param mtu 每包发数字节数
@param delay 延时时间
*/
-(void)setGameMode:(BOOL)isGame MTU:(NSUInteger)mtu Delay:(int)delay;

/**
 返回经典蓝牙信息
 @return @{@"ADDRESS":@"7c9a1da7330e",
           @"TYPE"   :@"BluetoothA2DPOutput",
           @"NAME"   :@"earphone"}
 */
+(NSDictionary*)outputEdrInfo;

/// 查询是否在连接蓝牙中
-(BOOL)wetherConnecting;

@end

NS_ASSUME_NONNULL_END
