//
//  JLBleManager.h
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/11.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>
#import <DFUnits/DFUnits.h>
#import "JLBleEntity.h"
#import "HandleBroadcastPtl.h"

#import <JL_OTALib/JL_OTALib.h>
#import <JL_HashPair/JL_HashPair.h>
#import <JL_AdvParse/JL_AdvParse.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - BLE状态通知
extern NSString *kFLT_BLE_FOUND;         //发现设备
extern NSString *kFLT_BLE_PAIRED;        //已配对
extern NSString *kFLT_BLE_CONNECTED;     //已连接
extern NSString *kFLT_BLE_DISCONNECTED;  //断开连接



@protocol JLBleManagerOtaDelegate <NSObject>

@required
/**
 *  ota升级过程状态回调
 */
- (void)otaProgressWithOtaResult:(JL_OTAResult)result withProgress:(float)progress;

@end


@interface JLBleManager : HandleBroadcastPtl

@property (assign, nonatomic) CBManagerState mBleManagerState;
@property (strong, nonatomic) CBPeripheral *__nullable mBlePeripheral;

/// 连接蓝牙是否需要认证配对
@property (assign, nonatomic) BOOL isPaired;

/// 配对秘钥（默认为空）
@property (assign, nonatomic) NSData *pairKey;

/// 连接设备的MTU（单次最大发送数据）
@property (assign, nonatomic) NSInteger bleMtu;

/// 上一次连接的蓝牙UUID
@property (strong, nonatomic) NSString *lastUUID;

/// 上一次连接的蓝牙地址
@property (strong, nonatomic) NSString *__nullable lastBleMacAddress;

@property (strong, nonatomic) JL_OTAManager *otaManager;

@property (assign,nonatomic)BOOL isConnected;

@property (strong, nonatomic) JLBleEntity *__nullable currentEntity;

/**
 * 单例
 */
+ (instancetype)sharedInstance;

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
 断开连接
 */
-(void)disconnectBLE;

/**
 使用UUID，重连设备。
*/
-(void)connectPeripheralWithUUID:(NSString *)uuid;


/// HID设备重连
/// - Parameter uuid: 设备 identifyString
-(void)findHid:(NSString *)uuid;

#pragma mark - 杰理蓝牙库OTA流程相关业务

typedef void(^GET_DEVICE_CALLBACK)(BOOL needForcedUpgrade);

typedef void(^CANCEL_CALLBACK)(uint8_t status);

/**
 *  获取已连接的蓝牙设备信息
 */
- (void)getDeviceInfo:(GET_DEVICE_CALLBACK _Nonnull)callback;

/**
 *  OTA升级
 */
- (void)otaFuncWithFilePath:(NSString *)otaFilePath;

- (void)otaFuncCancel:(CANCEL_CALLBACK _Nonnull)result;

@end

NS_ASSUME_NONNULL_END
