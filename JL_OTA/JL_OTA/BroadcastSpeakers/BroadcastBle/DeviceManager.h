//
//  DeviceManager.h
//  JL_OTA
//
//  Created by EzioChan on 2022/11/24.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_BLEKit.h>
#import "JLBleEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLDeviceInfo : NSObject

@property(nonatomic,strong)JLBleEntity *entity;

@property(nonatomic,strong)JL_ManagerM *manager;

@end

@interface DeviceManager : NSObject

@property(nonatomic,strong,readonly)NSMutableArray <JLDeviceInfo *>* devices;

+(instancetype)share;

-(void)addDevicesWithSDKEntity:(JL_EntityM *)entity;

-(void)addDevicesEntity:(JLBleEntity *)entity WithManager:(JL_ManagerM *)manager;

-(void)removeDevicesBy:(CBPeripheral *)cbp;

-(JLDeviceInfo * _Nullable)checkoutWith:(CBPeripheral *)peripheral;

@end

NS_ASSUME_NONNULL_END
