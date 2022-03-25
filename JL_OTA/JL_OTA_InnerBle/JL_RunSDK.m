//
//  JL_RunSDK.m
//  JL_OTA_InnerBle
//
//  Created by 凌煊峰 on 2021/10/9.
//

#import "JL_RunSDK.h"

@interface JL_RunSDK() <JL_ManagerMDelegate>

@property (strong, nonatomic) NSString *selectedOtaFilePath;

@end

@implementation JL_RunSDK

+ (instancetype)sharedInstance {
    static JL_RunSDK *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        /*--- 初始化JL_SDK ---*/
        self.mBleMultiple = [[JL_BLEMultiple alloc] init];
        self.mBleMultiple.BLE_FILTER_ENABLE = YES;
        self.mBleMultiple.BLE_PAIR_ENABLE = YES;
        self.mBleMultiple.BLE_TIMEOUT = 7;
    }
    return self;
}

+ (NSString *)textEntityStatus:(JL_EntityM_Status)status {
    if (status < 0) return kJL_TXT("未知错误");
    NSArray *arr = @[kJL_TXT("蓝牙未开启"), kJL_TXT("连接失败"), kJL_TXT("正在连接"), kJL_TXT("重复连接"),
                     kJL_TXT("连接超时"), kJL_TXT("被拒绝"), kJL_TXT("配对失败"), kJL_TXT("配对超时"), kJL_TXT("已配对"),
                     kJL_TXT("正在主从切换"), kJL_TXT("断开成功"), kJL_TXT("请打开蓝牙")];
    if (status+1 <= arr.count) {
        return arr[status];
    } else {
        return kJL_TXT("未知错误");
    }
}

- (JL_EntityM *)getEntity:(NSString *)uuid {
    NSMutableArray *mConnectArr = self.mBleMultiple.bleConnectedArr;
    for (JL_EntityM *entity in mConnectArr) {
        NSString *inUnid = entity.mPeripheral.identifier.UUIDString;
        if ([uuid isEqual:inUnid]) {
            return entity;
        }
    }
    return nil;
}

#pragma mark - 杰理蓝牙库OTA流程相关业务

/**
 *  获取已连接的蓝牙设备信息，这里如果上次设备升级没有成功，会要求执行otaFuncWithFilePath:强制升级
 */
- (void)getDeviceInfo:(GET_DEVICE_CALLBACK _Nonnull)callback {
    __weak typeof(self) weakSelf = self;
    /*--- 获取设备信息 ---*/
    [self.mBleEntityM.mCmdManager cmdTargetFeatureResult:^(JL_CMDStatus status, uint8_t sn, NSData * _Nullable data) {
        if (status == JL_CMDStatusSuccess) {
            JLModel_Device *model = [weakSelf.mBleEntityM.mCmdManager outputDeviceModel];
            JL_OtaStatus upSt = model.otaStatus;
            if (upSt == JL_OtaStatusForce) {
                NSLog(@"---> 进入强制升级.");
                if (weakSelf.selectedOtaFilePath) {
                    [weakSelf otaFuncWithFilePath:weakSelf.selectedOtaFilePath];
                } else {
                    callback(true);
                }
                return;
            } else {
                if (model.otaHeadset == JL_OtaHeadsetYES) {
                    NSLog(@"---> 进入强制升级: OTA另一只耳机.");
                    if (weakSelf.selectedOtaFilePath) {
                        [weakSelf otaFuncWithFilePath:weakSelf.selectedOtaFilePath];
                    } else {
                        callback(true);
                    }
                    return;
                }
            }
            NSLog(@"---> 设备正常使用...");
            [JL_Tools mainTask:^{
                /*--- 获取公共信息 ---*/
                [weakSelf.mBleEntityM.mCmdManager cmdGetSystemInfo:JL_FunctionCodeCOMMON Result:nil];
            }];
        } else {
            NSLog(@"---> ERROR：设备信息获取错误!");
        }
    }];
}

- (void)otaFuncWithFilePath:(NSString *)otaFilePath {
    NSLog(@"current otaFilePath ---> %@", otaFilePath);
    self.selectedOtaFilePath = otaFilePath;
    __weak typeof(self) weakSelf = self;
    [self.mBleMultiple otaFuncWithEntityM:self.mBleEntityM withFilePath:otaFilePath Result:^(JL_OTAResult result, float progress) {
        if ([weakSelf.otaDelegate respondsToSelector:@selector(otaProgressWithOtaResult:withProgress:)]) {
            [weakSelf.otaDelegate otaProgressWithOtaResult:result withProgress:progress];
        }
    }];
}

@end
