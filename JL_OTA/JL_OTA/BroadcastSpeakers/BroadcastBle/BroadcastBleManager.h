//
//  BrowsecastBleManager.h
//  JL_OTA
//
//  Created by EzioChan on 2022/11/25.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <JL_BLEKit/JL_BLEKit.h>
#import <DFUnits/DFUnits.h>
#import <UIKit/UIKit.h>
#import "JLBleEntity.h"
#import "DeviceManager.h"
#import "BroadcastThread.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - BLE状态通知
extern NSString *kBDM_BLE_FOUND;         //发现设备
extern NSString *kBDM_BLE_PAIRED;        //已配对
extern NSString *kBDM_BLE_CONNECTED;     //已连接
extern NSString *kBDM_BLE_DISCONNECTED;  //断开连接

@interface BroadcastBleManager : NSObject

@property (strong, nonatomic)NSMutableDictionary *assistDicts;
@property (assign, nonatomic) CBManagerState mBleManagerState;

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
- (void)disconnectBLE:(CBPeripheral *)cbp;

/**
 使用UUID，重连设备。
*/
-(void)connectPeripheralWithUUID:(NSString *)uuid;


/// 单备份回连
/// - Parameter macAddr: 设备的mac
-(void)connectPeripheralWithMacAddr:(NSString *)macAddr;

@end

NS_ASSUME_NONNULL_END
