//
//  JLBleEntity.h
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/11.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


NS_ASSUME_NONNULL_BEGIN

@interface JLBleEntity : NSObject                                //蓝牙设备模型

@property (strong, nonatomic) NSNumber *mRSSI;
@property (strong, nonatomic) CBPeripheral *mPeripheral;
@property (strong, nonatomic) NSString *mName;
@property (strong, nonatomic) NSString *bleMacAddress;
@property (strong, nonatomic) NSString *edrMacAddress;
@property (assign, nonatomic) uint8_t mType;
@property (assign, nonatomic) uint16_t pid;
@property (assign, nonatomic) uint16_t uid;

/// 系统已连接设备标记：由 retrieveConnectedPeripheralsWithServices: 获取，而非扫描发现。
/// 用于设备列表把“系统已连”的设备固定在首位，并在其断开后从列表清理。
@property (assign, nonatomic) BOOL isSystemConnected;

@end

NS_ASSUME_NONNULL_END
