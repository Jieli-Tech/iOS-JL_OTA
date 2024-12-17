//
//  DeviceManager.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/24.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "DeviceManager.h"

@implementation DeviceManager

+(instancetype)share{
    static DeviceManager *mgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[DeviceManager alloc] init];
    });
    return mgr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _devices = [NSMutableArray new];
    }
    return self;
}


-(void)addDevicesWithSDKEntity:(JL_EntityM *)entity{
    JLBleEntity *entityBasic = [[JLBleEntity alloc] init];
    entityBasic.mRSSI = entity.mRSSI;
    entityBasic.mPeripheral = entity.mPeripheral;
    entityBasic.bleMacAddress = entity.mBleAddr;
    entityBasic.mType = entity.mType;
    [self addDevicesEntity:entityBasic WithManager:entity.mCmdManager];
}


-(void)addDevicesEntity:(JLBleEntity *)entity WithManager:(JL_ManagerM *)manager{
    BOOL bk = false;
    for (JLDeviceInfo *info in self.devices) {
        JLBleEntity *item = info.entity;
        if ([item.mPeripheral.identifier.UUIDString isEqualToString:entity.mPeripheral.identifier.UUIDString]){
            bk = true;
            break;
        }
    }
    if(!bk){
        JLDeviceInfo *info = [JLDeviceInfo new];
        info.entity = entity;
        info.manager = manager;
        [_devices addObject:info];
    }
    
    for (JLDeviceInfo *info in _devices) {
        kJLLog(JLLOG_DEBUG, @"JLDeviceInfo:%@",info);
    }
}

-(void)removeDevicesBy:(CBPeripheral *)cbp{
    for (JLDeviceInfo *info in self.devices) {
        JLBleEntity *item = info.entity;
        if ([item.mPeripheral.identifier.UUIDString isEqualToString:cbp.identifier.UUIDString]){
            [_devices removeObject:info];
            break;
        }
    }
}


-(JLDeviceInfo * _Nullable)checkoutWith:(CBPeripheral *)peripheral{
    for (JLDeviceInfo *info in self.devices) {
        JLBleEntity *item = info.entity;
        if ([item.mPeripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]){
            return info;
        }
    }
    return nil;
}






@end


@implementation JLDeviceInfo

-(void)test{
    [_manager cmdGetSystemInfo:JL_FunctionCodeCOMMON SelectionBit:0x4000 Result:^(JL_CMDStatus status, uint8_t sn, NSData * _Nullable data) {
        
    }];
}

@end
