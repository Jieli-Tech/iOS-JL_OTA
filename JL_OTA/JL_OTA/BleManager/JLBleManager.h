//
//  JLBleManager.h
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/11.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <JL_BLEKit/JL_BLEKit.h>
#import <DFUnits/DFUnits.h>
#import <UIKit/UIKit.h>
#import "JLBleEntity.h"

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


@interface JLBleManager : ECOneToMorePtl

@property (assign, nonatomic) CBManagerState mBleManagerState;
@property (strong, nonatomic) CBPeripheral *__nullable mBlePeripheral;
@property (assign, nonatomic) BOOL isFilter;                            // 是否过滤非杰理蓝牙
@property (assign, nonatomic) BOOL isPaired;                            // 连接蓝牙是否需要认证配对
@property (strong, nonatomic) NSString *lastUUID;                        // 上一次连接的蓝牙UUID
@property (strong, nonatomic) NSString *__nullable lastBleMacAddress;     // 上一次连接的蓝牙地址
@property (strong, nonatomic) JL_Assist *mAssist;

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

/**
 *  获取已连接的蓝牙设备信息
 */
- (void)getDeviceInfo:(GET_DEVICE_CALLBACK _Nonnull)callback;

/**
 *  OTA升级
 */
- (void)otaFuncWithFilePath:(NSString *)otaFilePath;

@end

NS_ASSUME_NONNULL_END
