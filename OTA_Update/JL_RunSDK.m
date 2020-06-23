//
//  JL_RunSDK.m
//  JL_BLE_TEST
//
//  Created by DFung on 2018/11/26.
//  Copyright © 2018 www.zh-jieli.com. All rights reserved.
//

#import "JL_RunSDK.h"

NSString *kUI_JL_BLE_STATUS_DEVICE = @"UI_JL_BLE_STATUS_DEVICE";
NSString *kUI_JL_BLE_PAIR_ERR      = @"UI_JL_BLE_PAIR_ERR";
NSString *kUI_JL_UPDATE_STATUS     = @"UI_JL_UPDATE_STATUS";
NSString *kUI_JL_OTA_UPDATE        = @"UI_JL_OTA_UPDATE";

@interface JL_RunSDK()<JL_ManagerDelegate>
@end

@implementation JL_RunSDK
- (instancetype)init
{
    self = [super init];
    if (self) {
        /*--- 初始化JL_SDK ---*/
        [JL_Manager setManagerDelegate:self];
        
        /*--- 关闭认证流程 ---*/
        //JL_BLEUsage *usage = [JL_BLEUsage sharedMe];
        //usage.bt_ble.BLE_PAIR_ENABLE = NO;
        //usage.bt_ble.BLE_RELINK = NO;
    }
    return self;
}

#pragma mark - 蓝牙状态
/**
 蓝牙中心操作状态（发现、配对、断开、蓝牙开、蓝牙关）
 @param array 设备数组
 @param status 状态
 */
-(void)onManagerPeripherals:(NSArray<JL_Entity*> *)array
               updateStatus:(JL_BLEStatus)status{
    NSDictionary *dic = @{@"DEVICE":array,@"STATUS":@(status)};
    
    if (status == JL_BLEStatusPaired) {
        [JL_Tools delay:0.5 Task:^{
            /*--- 获取设备信息 ---*/
            [JL_Manager cmdTargetFeatureResult:^(NSArray *array) {
                JL_CMDStatus st = [array[0] intValue];
                if (st == JL_CMDStatusSuccess) {
                    NSLog(@"---> 正常获取设备信息.");
                    
                    JLDeviceModel *md = [JL_Manager outputDeviceModel];
                    if (md.otaBleAllowConnect == JL_OtaBleAllowConnectNO) {
                        //OTA 禁止连接后，断开连接清楚连接记录。
                        [JL_Manager bleClean];
                        [JL_Manager bleDisconnect];

                        [JL_Tools post:@"OTA_BLE_ALLOW_NO" Object:nil];
                    }
                    
                    /*--- 后续会用版本来决定是否要OTA升级 ---*/
                    NSLog(@"---> 当前固件版本号：%@",md.versionFirmware);
                    
                    JL_OtaStatus upSt = md.otaStatus;
                    if (upSt == JL_OtaStatusForce) {
                        NSLog(@"---> 进入强制升级.");
                        [JL_Tools post:kUI_JL_UPDATE_STATUS Object:nil];
                    }
                    
                }else{
                    NSLog(@"---> 错误提示：%d",st);
                }
            }];
        }];
    }
    [JL_Tools post:kUI_JL_BLE_STATUS_DEVICE Object:dic];
}

/**
 配对失败
 */
-(void)onManagerPeripheralPairFailed{
    //NSLog(@"---> 配对失败");
    [JL_Tools post:kUI_JL_BLE_PAIR_ERR Object:nil];
}

#pragma mark - 设备信息更新
/**
 设备更新系统信息
 @param model 设备模型
 */
-(void)onManagerCommandUpdateDeviceSystemInfo:(JLDeviceModel*)model{
    //NSLog(@"---> 设备系统信息");
    [JL_Tools post:kUI_JL_UPDATE_STATUS Object:model];
}

- (void)onManagerCommandCustomData:(nonnull NSData *)data {
    //NSLog(@"---> 收到自定义数据");
}


@end
