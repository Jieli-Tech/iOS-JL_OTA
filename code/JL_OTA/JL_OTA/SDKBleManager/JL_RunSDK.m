//
//  JL_RunSDK.m
//  JL_OTA_InnerBle
//
//  Created by 凌煊峰 on 2021/10/9.
//

#import "JL_RunSDK.h"

@interface JL_RunSDK() <JL_ManagerMDelegate>

@property (strong, nonatomic) NSString *selectedOtaFilePath;
@property (strong, nonatomic) NSString *connectUUID;

@end

@implementation JL_RunSDK


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
        self.connectUUID = nil;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noteListen:) name:nil object:nil];
    }
    return self;
}


-(void)noteListen:(NSNotification *)note{
    NSString *name = note.name;
    if(!self.connectUUID) return;
    if([name isEqual:kJL_BLE_M_FOUND]){
        NSArray *itemsArray = [note object];
        __weak typeof(self) weakSelf = self;
        for (JL_EntityM *entity in itemsArray) {
            if([entity.mPeripheral.identifier.UUIDString isEqualToString:self.connectUUID]){
                [self.mBleMultiple scanStop];
                self.connectUUID = nil;
                [self.mBleMultiple connectEntity:entity Result:^(JL_EntityM_Status status) {
                    if(status == JL_EntityM_StatusPaired){
                        weakSelf.mBleEntityM = entity;
                    }
                }];
            }
        }
        
    }
}

-(void)startLoopConnect:(NSString *)uuid{
    self.connectUUID = uuid;
    [self.mBleMultiple scanStart];
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


-(void)handelDeviceInfo{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getDeviceInfo:^(BOOL needForcedUpgrade) {
            
        }];
    });
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
            JL_OTAManager *otaManager = [self.mBleEntityM.mCmdManager mOTAManager];
            JLOtaSourcesExtendMode upSt = otaManager.otaSourceMode;
            if (otaManager.otaStatus == JL_OtaStatusForce) {
                if (otaManager.isSupportReuseSpaceOTA) {
                    if (otaManager.otaSourceMode  == JLSourcesExtendModeNormal
                        || otaManager.otaSourceMode == JLSourcesExtendModeDisable) {
                        if (otaManager.bootloaderType == JL_BootLoaderYES) {
                            kJLLog(JLLOG_DEBUG, @"---> 进入 Loader 升级.");
                        }else{
                            kJLLog(JLLOG_DEBUG, @"---> 进入资源升级.");
                        }
                    }
                }else{
                    kJLLog(JLLOG_DEBUG, @"---> 进入强制升级.");
                }
                if (weakSelf.selectedOtaFilePath) {
                    [weakSelf otaFuncWithFilePath:weakSelf.selectedOtaFilePath];
                } else {
                    callback(true);
                }
                return;
            } else {
                if (otaManager.otaHeadset == JL_OtaHeadsetYES) {
                    kJLLog(JLLOG_DEBUG, @"---> 进入强制升级: OTA另一只耳机.");
                    if (weakSelf.selectedOtaFilePath) {
                        [weakSelf otaFuncWithFilePath:weakSelf.selectedOtaFilePath];
                    } else {
                        callback(true);
                    }
                    return;
                }
                if (upSt == JLSourcesExtendModeFirmwareOnly) {
                    kJLLog(JLLOG_DEBUG, @"---> 进入固件更新.");
                    if (weakSelf.selectedOtaFilePath) {
                        [weakSelf otaFuncWithFilePath:weakSelf.selectedOtaFilePath];
                    } else {
                        callback(true);
                    }
                    return;
                }
            }
            kJLLog(JLLOG_DEBUG, @"---> 设备正常使用...");
            [JL_Tools mainTask:^{
                /*--- 获取公共信息 ---*/
                [weakSelf.mBleEntityM.mCmdManager cmdGetSystemInfo:JL_FunctionCodeCOMMON Result:nil];
                callback(false);
            }];
        } else {
            kJLLog(JLLOG_DEBUG, @"---> ERROR：设备信息获取错误!");
        }
    }];
}

- (void)otaFuncWithFilePath:(NSString *)otaFilePath {
    kJLLog(JLLOG_DEBUG, @"current otaFilePath ---> %@", otaFilePath);
    self.selectedOtaFilePath = otaFilePath;
    __weak typeof(self) weakSelf = self;
    [self.mBleMultiple otaFuncWithEntityM:self.mBleEntityM withFilePath:otaFilePath Result:^(JL_OTAResult result, float progress) {
        if ([weakSelf.otaDelegate respondsToSelector:@selector(otaProgressWithOtaResult:withProgress:)]) {
            [weakSelf.otaDelegate otaProgressWithOtaResult:result withProgress:progress];
        }
    }];
}

+(double)getWidthWithString:(NSString*)str font:(UIFont*)font{
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize detailSize = [str sizeWithAttributes:dict];
    return detailSize.width;
}

+ (NSAttributedString *)getAttributeWith:(id)sender string:(NSString *)string orginFont:(CGFloat)orginFont orginColor:(UIColor *)orginColor attributeFont:(CGFloat)attributeFont attributeColor:(UIColor *)attributeColor
{
    __block  NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:string];
    [totalStr addAttribute:NSFontAttributeName value:FontMedium(orginFont) range:NSMakeRange(0, string.length)];
    [totalStr addAttribute:NSForegroundColorAttributeName value:orginColor range:NSMakeRange(0, string.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0f]; //设置行间距
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [totalStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalStr length])];
    
    if ([sender isKindOfClass:[NSArray class]]) {
        
        __block NSString *oringinStr = string;
        __weak typeof(self) weakSelf = self;
        
        [sender enumerateObjectsUsingBlock:^(NSString *  _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSRange range = [oringinStr rangeOfString:str];
            [totalStr addAttribute:NSFontAttributeName value:FontMedium(attributeFont) range:range];
            [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
            oringinStr = [oringinStr stringByReplacingCharactersInRange:range withString:[weakSelf getStringWithRange:range]];
        }];
        
    } else if ([sender isKindOfClass:[NSString class]]) {
        
        NSRange range = [string rangeOfString:sender];
        
        [totalStr addAttribute:NSFontAttributeName value:FontMedium(attributeFont) range:range];
        [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
    }
    return totalStr;
}

+ (NSString *)getStringWithRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < range.length ; i++) {
        [string appendString:@" "];
    }
    return string;
}

@end
