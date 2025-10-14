//
//  JLBleHandler.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/12.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "JLBleHandler.h"
#import "ToolsHelper.h"

NSString *kFLT_BLE_OTA_CALLBACK = @"kFLT_BLE_OTA_CALLBACK";     //BLE断开连接


@interface JLBleHandler()<JLBleManagerOtaDelegate,JL_RunSDKOtaDelegate>{
    
    JL_BLEMultiple  *sdkManager;
    JLBleManager    *userManager;
}
@end

@implementation JLBleHandler

+(instancetype)share{
    static JLBleHandler *handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[JLBleHandler alloc] init];
    });
    
    return handler;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        sdkManager = [JL_RunSDK sharedInstance].mBleMultiple;
        [JL_RunSDK sharedInstance].otaDelegate = self;
        sdkManager.BLE_FILTER_ENABLE = YES;
        
        userManager = [JLBleManager sharedInstance];
        [userManager addDelegate:self];
    }
    return self;
}


- (void)setDelegate:(id<JLBleHandlDelegate>)delegate{
    _delegate = delegate;
    [JL_RunSDK sharedInstance].otaDelegate = self;
}

-(BOOL)isConnected{
    if([ToolsHelper isConnectBySDK]){
        return [[JL_RunSDK sharedInstance] mBleEntityM].mBLE_IS_PAIRED;
    }else{
        return [[JLBleManager sharedInstance] isConnected];
    }
}

-(BOOL)handleWeatherNeedUpdate{
    JL_OtaStatus upSt = JL_OtaStatusNormal;
    if([ToolsHelper isConnectBySDK]){
        JLModel_Device *model = [[[JL_RunSDK sharedInstance] mBleEntityM].mCmdManager outputDeviceModel];
        upSt = model.otaStatus;
    }else{
        
        upSt = userManager.otaManager.otaStatus;
    }
    if (upSt == JL_OtaStatusForce){
        return YES;
    }else{
        return NO;
    }
}

-(NSString *)handleDeviceNowUUID{
    if([ToolsHelper isConnectBySDK]){
        return [JL_RunSDK sharedInstance].mBleEntityM.mPeripheral.identifier.UUIDString;
    }else{
        return [JLBleManager sharedInstance].mBlePeripheral.identifier.UUIDString;
    }
}

-(BOOL)handleGetBleStatus{
    if([ToolsHelper isConnectBySDK]){
        if(sdkManager.bleManagerState == CBManagerStatePoweredOn)
            return YES;
        return NO;
    }else{
        if([JLBleManager sharedInstance].mBleManagerState == CBManagerStatePoweredOn)
            return YES;
        return NO;
    }
}

-(void)handleScanDevice{
    if([ToolsHelper isConnectBySDK]){
        [sdkManager scanStart];
    }else{
        [userManager startScanBLE];
    }
}

-(void)handleStopScanDevice{
    if([ToolsHelper isConnectBySDK]){
        [sdkManager scanStop];
    }else{
        [userManager stopScanBLE];
    }
}

-(void)handleDisconnect{
//    if(![ToolsHelper isConnectBySDK]){
        JL_EntityM *entity = [[JL_RunSDK sharedInstance] mBleEntityM];
        [sdkManager disconnectEntity:entity Result:^(JL_EntityM_Status status) {
            
        }];
//    }else{
        [userManager disconnectBLE];
//    }
}

-(void)handleReconnectByMac{
    if([ToolsHelper isConnectBySDK]){
        kJLLog(JLLOG_DEBUG, @"---> OTA SDK 正在通过Mac Addr方式回连设备... %@", [JL_RunSDK sharedInstance].mBleEntityM.mBleAddr);
        [sdkManager scanStart];
    }else{
        
        kJLLog(JLLOG_DEBUG, @"---> OTA正在通过Mac Addr方式回连设备... %@", userManager.otaManager.bleAddr);
        [JLBleManager sharedInstance].lastBleMacAddress = userManager.otaManager.bleAddr;
        [[JLBleManager sharedInstance] startScanBLE];
    }
}

-(void)handleReconnectByUUID{
    if([ToolsHelper isConnectBySDK]){
        sdkManager.BLE_PAIR_ENABLE = [ToolsHelper isSupportPair];
        kJLLog(JLLOG_DEBUG, @"---> OTA SDK 正在回连设备... %@,%@", [JL_RunSDK sharedInstance].mBleEntityM.mItem, [JL_RunSDK sharedInstance].lastUUID);
        JL_EntityM *entity = [sdkManager makeEntityWithUUID:[JL_RunSDK sharedInstance].lastUUID];
        [sdkManager connectEntity:entity Result:^(JL_EntityM_Status status) {
        }];
    }else{
        kJLLog(JLLOG_DEBUG, @"---> OTA正在回连设备... %@,%@", [JLBleManager sharedInstance].mBlePeripheral.name,userManager.lastUUID);
        [userManager connectPeripheralWithUUID:userManager.lastUUID];
    }
}

-(void)handleConnectWithUUID:(NSString *)uuid{
    if([ToolsHelper isConnectBySDK]){
        [[JL_RunSDK sharedInstance] startLoopConnect:uuid];
    }else{
        [userManager connectPeripheralWithUUID:uuid];
    }
}



+(NSString *)deviceType{
    JL_DeviceType type = JL_DeviceTypeTradition;
    if([ToolsHelper isConnectBySDK]){
        type = [[JL_RunSDK sharedInstance] mBleEntityM].mType;
    }else{
        type = [[JLBleManager sharedInstance] currentEntity].mType;
    }
    switch (type) {
        case JL_DeviceTypeSoundBox:
            return @"sound box";
            break;
        case JL_DeviceTypeChargingBin:
            return @"charging box";
            break;
        case JL_DeviceTypeTWS:
            return @"TWS";
            break;
        case JL_DeviceTypeHeadset:
            return @"headset";
            break;
        case JL_DeviceTypeSoundCard:
            return @"sound card";
            break;
        case JL_DeviceTypeWatch:
            return @"watch";
        case JL_DeviceTypeTradition:
            return @"tradition";
            break;
    }
    return kJL_TXT("unKnow");
}



- (void)handleOtaFuncWithFilePath:(NSString *)otaFilePath{
    
    if([ToolsHelper isConnectBySDK]){
        [[JL_RunSDK sharedInstance] otaFuncWithFilePath:otaFilePath];
    }else{
        [[JLBleManager sharedInstance] otaFuncWithFilePath:otaFilePath];
    }
}



-(void)handleOtaCancelUpdate:(void(^)(JL_CMDStatus status))block{
    JL_EntityM * _Nullable entity;
    if([ToolsHelper isConnectBySDK]){
        entity = [[JL_RunSDK sharedInstance] mBleEntityM];
        if(entity){
            [entity.mCmdManager.mOTAManager cmdOTACancelResult:^(JL_CMDStatus status, uint8_t sn, NSData * _Nullable data) {
                block(status);
            }];
        }else{
            block(JL_CMDStatusFail);
        }
    }else{
       JLBleEntity * entity = [[JLBleManager sharedInstance] currentEntity];
        if(entity){

            [[JLBleManager sharedInstance] otaFuncCancel:^(uint8_t status) {
                block(status);
            }];
        }else{
            block(JL_CMDStatusFail);
        }
    }
   
}



- (void)otaProgressWithOtaResult:(JL_OTAResult)result withProgress:(float)progress {
    if([self.delegate respondsToSelector:@selector(otaProgressOtaResult:withProgress:)]){
        [self.delegate otaProgressOtaResult:result withProgress:progress];
    }
}




@end
