//
//  JLBleManager.m
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/11.
//

#import "JLBleManager.h"

#import "FittingView.h"

NSString *kFLT_BLE_FOUND        = @"FLT_BLE_FOUND";            //发现设备
NSString *kFLT_BLE_PAIRED       = @"FLT_BLE_PAIRED";           //BLE已配对
NSString *kFLT_BLE_CONNECTED    = @"FLT_BLE_CONNECTED";        //BLE已连接
NSString *kFLT_BLE_DISCONNECTED = @"FLT_BLE_DISCONNECTED";     //BLE断开连接

NSString *FLT_BLE_SERVICE = @"AE00"; //服务号
NSString *FLT_BLE_RCSP_W  = @"AE01"; //命令“写”通道
NSString *FLT_BLE_RCSP_R  = @"AE02"; //命令“读”通道


@interface JLBleManager() <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *bleManager;

@property (strong, nonatomic) NSMutableArray<JLBleEntity *> *blePeripheralArr;
@property (strong, nonatomic) CBPeripheral *bleCurrentPeripheral;

@property (strong, nonatomic) NSString *selectedOtaFilePath;
@property (strong, nonatomic) NSString *connectByUUID;
@end

@implementation JLBleManager

+ (instancetype)sharedInstance {
    static JLBleManager *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isFilter = YES;
        _isPaired = YES;
        
        _bleManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        /*--- JLSDK ADD ---*/
        _mAssist = [[JL_Assist alloc] init];
        _mAssist.mNeedPaired = _isPaired;             //是否需要握手配对
        /*--- 自定义配对码(16个字节配对码) ---*/
        //char pairkey[16] = {0x01,0x02,0x03,0x04,
        //                    0x01,0x02,0x03,0x04,
        //                    0x01,0x02,0x03,0x04,
        //                    0x01,0x02,0x03,0x04};
        //NSData *pairData = [NSData dataWithBytes:pairkey length:16];
        _mAssist.mPairKey    = nil;             //配对秘钥（或者自定义配对码pairData）
        _mAssist.mService    = FLT_BLE_SERVICE; //服务号
        _mAssist.mRcsp_W     = FLT_BLE_RCSP_W;  //特征「写」
        _mAssist.mRcsp_R     = FLT_BLE_RCSP_R;  //特征「读」
        _connectByUUID = nil;
    }
    return self;
}

- (void)setIsPaired:(BOOL)isPaired {
    self.mAssist.mNeedPaired = isPaired;
    _isPaired = isPaired;
}


#pragma mark - 扫描设备相关

#pragma mark 开始扫描
- (void)startScanBLE {
    NSLog(@"BLE ---> startScanBLE.");
    _blePeripheralArr = [NSMutableArray new];
    if (_bleManager) {
        if (_bleManager.state == CBManagerStatePoweredOn) {
            [_bleManager scanForPeripheralsWithServices:nil options:nil];
        } else {
            __weak typeof(self) weakSelf = self;
            dispatch_after(0.5, dispatch_get_main_queue(), ^{
                if (weakSelf.bleManager.state == CBManagerStatePoweredOn) {
                    [weakSelf.bleManager scanForPeripheralsWithServices:nil options:nil];
                }
            });
        }
    }
}

#pragma mark 停止扫描
- (void)stopScanBLE {
    if (_bleManager) [_bleManager stopScan];
}



#pragma mark - 蓝牙设备连接相关

#pragma mark 断开当前蓝牙设备连接
- (void)disconnectBLE {
    if (_bleCurrentPeripheral) {
        NSLog(@"BLE --->To disconnectBLE.");
        [_bleManager cancelPeripheralConnection:_bleCurrentPeripheral];
        self.isConnected = false;
    }
}

#pragma mark 连接蓝牙设备

- (void)connectBLE:(CBPeripheral*)peripheral {
    if(_bleCurrentPeripheral){
        [_bleManager cancelPeripheralConnection:_bleCurrentPeripheral];
    }
    _bleCurrentPeripheral = peripheral;
    [_bleCurrentPeripheral setDelegate:self];
    [_bleManager connectPeripheral:_bleCurrentPeripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey:@(YES)}];
    [_bleManager stopScan];

    NSLog(@"BLE Connecting... Name ---> %@", peripheral.name);
}

- (void)connectPeripheralWithUUID:(NSString*)uuid {
    _connectByUUID = uuid;
    [self startScanBLE];
}

-(void)findHid:(NSString *)uuid{
    NSUUID *uuidNs = [[NSUUID alloc] initWithUUIDString:uuid];
    NSArray *array = [self.bleManager retrievePeripheralsWithIdentifiers:@[uuidNs]];
    
    for (CBPeripheral *cbp in array) {
        if([cbp.identifier.UUIDString isEqualToString:uuid]){
            NSLog(@"reconnect:%@",cbp);
            [self connectBLE:cbp];
            break;
        }
    }
    
}

-(void)connectAction{
    
    if(self.connectByUUID == nil) return;
    
    NSArray *uuidArr = @[[[NSUUID alloc] initWithUUIDString:self.connectByUUID]];
    NSArray *phArr = [_bleManager retrievePeripheralsWithIdentifiers:uuidArr];//serviceUUID就是你首次连接配对的蓝牙

    if (phArr.count == 0) {
        return;
    }
    
    CBPeripheral* peripheral = phArr[0];
    
    if (phArr.firstObject && [phArr.firstObject state] != CBPeripheralStateConnected && [phArr.firstObject state] != CBPeripheralStateConnecting) {
        
        NSString *ble_name = peripheral.name;
        NSString *ble_uuid = peripheral.identifier.UUIDString;
        NSLog(@"FLT Connecting(Last)... Name ---> %@ UUID:%@",ble_name,ble_uuid);
        
        _bleCurrentPeripheral = peripheral;
        [_bleCurrentPeripheral setDelegate:self];
        
        [_bleManager connectPeripheral:_bleCurrentPeripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey:@(YES)}];
        _connectByUUID = nil;
    }
}

#pragma mark - CBCentralManagerDelegate

#pragma mark 蓝牙初始化 Callback
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    _mBleManagerState = central.state;
    
    /*--- JLSDK ADD ---*/
    [self.mAssist assistUpdateState:central.state];
    
    if (_mBleManagerState != CBManagerStatePoweredOn) {
        self.mBlePeripheral = nil;
        self.blePeripheralArr = [NSMutableArray array];
    }
}

#pragma mark 发现设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSString *ble_name = advertisementData[@"kCBAdvDataLocalName"];
    NSData *ble_AD   = advertisementData[@"kCBAdvDataManufacturerData"];
    NSDictionary *info = [JL_BLEAction bluetoothKey_1:self.mAssist.mPairKey Filter:advertisementData];
    if (ble_name.length == 0) return;
    
    NSLog(@"发现 ----> NAME:%@ RSSI:%@ AD:%@", ble_name,RSSI,ble_AD);
    
    NSString *key = [[FittingView getFitterKey] uppercaseString];
    if ([key isEqualToString:@""]) {
        [self addPeripheral:peripheral RSSI:RSSI Name:ble_name Info:info];
    }else{
        if ([[ble_name uppercaseString] rangeOfString:key].location == NSNotFound) {
            //
            NSLog(@"过滤 ----> NAME:%@ RSSI:%@ AD:%@", ble_name,RSSI,ble_AD);
        }else{
            [self addPeripheral:peripheral RSSI:RSSI Name:ble_name Info:info];
        }
    }

    [DFNotice post:kFLT_BLE_FOUND Object:_blePeripheralArr];
    
    // ota升级过程，回连使用
    if ([JL_BLEAction otaBleMacAddress:self.lastBleMacAddress isEqualToCBAdvDataManufacturerData:ble_AD]) {
        [self connectBLE:peripheral];
    }
}

- (void)addPeripheral:(CBPeripheral*)peripheral RSSI:(NSNumber *)rssi Name:(NSString*)name Info:(NSDictionary*)info{
    int flag = 0;
    for (JLBleEntity *bleEntity in _blePeripheralArr) {
        CBPeripheral *info_pl = bleEntity.mPeripheral;
        NSString *info_uuid = info_pl.identifier.UUIDString;
        NSString *ble_uuid  = peripheral.identifier.UUIDString;
        if ([info_uuid isEqualToString:ble_uuid]) {
            bleEntity.mRSSI = rssi;
            flag = 1;
            break;
        }
    }
    if (flag == 0 && name.length > 0) {
        JLBleEntity *bleEntity = [JLBleEntity new];
        bleEntity.mName = name?:@"Unknow";
        bleEntity.mRSSI = rssi;
        bleEntity.mType = [info[@"TYPE"] intValue];
        bleEntity.edrMacAddress = info[@"EDR"];
        NSLog(@"type:%d,name:%@",[info[@"TYPE"] intValue],name);
        bleEntity.mPeripheral = peripheral;
        [_blePeripheralArr addObject:bleEntity];
    }
    if(_connectByUUID && [peripheral.identifier.UUIDString isEqualToString:_connectByUUID]){
        [self stopScanBLE];
        [self connectAction];
    }
}

#pragma mark 设备连接回调
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"BLE Connected ---> Device %@", peripheral.name);
    for (JLBleEntity *entity in self.blePeripheralArr) {
        if([entity.mPeripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]){
            self.currentEntity = entity;
            break;
        }
    }
    self.isConnected = YES;
    [DFNotice post:kFLT_BLE_CONNECTED Object:peripheral];
    // 连接成功后，查找服务
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"Err:BLE Connect FAIL ---> Device:%@ Error:%@",peripheral.name,[error description]);
}

#pragma mark 设备断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"BLE Disconnect ---> Device %@ error:%d", peripheral.name, (int)error.code);
    self.mBlePeripheral = nil;
    
    /*--- JLSDK ADD ---*/
    [self.mAssist assistDisconnectPeripheral:peripheral];
    
    self.isConnected = NO;
    /*--- UI刷新，设备断开 ---*/
    [JL_Tools post:kFLT_BLE_DISCONNECTED Object:peripheral];
}

#pragma mark - CBPeripheralDelegate

#pragma mark 设备服务回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    if (error) { NSLog(@"Err: Discovered services fail."); return; }
    
    for (CBService *service in peripheral.services) {
        //如果我们知道要查询的特性的CBUUID，可以在参数一中传入CBUUID数组。
        //if ([service.UUID.UUIDString isEqual:FLT_BLE_SERVICE]) {
            NSLog(@"BLE Service ---> %@", service.UUID.UUIDString);
            [peripheral discoverCharacteristics:nil forService:service];
            //break;
        //}
    }
}

#pragma mark 设备特征回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    if (error) { NSLog(@"Err: Discovered Characteristics fail."); return; }
    
    /*--- JLSDK ADD ---*/
    [self.mAssist assistDiscoverCharacteristicsForService:service Peripheral:peripheral];
}

#pragma mark 更新通知特征的状态
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
    if (error) { NSLog(@"Err: Update NotificationState For Characteristic fail."); return; }
    
    /*--- JLSDK ADD ---*/
    __weak typeof(self) weakSelf = self;
    [self.mAssist assistUpdateCharacteristic:characteristic Peripheral:peripheral Result:^(BOOL isPaired) {
        if (isPaired == YES) {
            weakSelf.lastUUID = peripheral.identifier.UUIDString;
            weakSelf.lastBleMacAddress = nil;
            weakSelf.mBlePeripheral = peripheral;
            /*--- UI配对成功 ---*/
            [JL_Tools post:kFLT_BLE_PAIRED Object:peripheral];
        } else {
            
            [weakSelf.bleManager cancelPeripheralConnection:peripheral];
        }
        weakSelf.isConnected = YES;
    }];
}

#pragma mark 设备返回的数据 GET
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) { NSLog(@"Err: receive data fail."); return; }

    /*--- JLSDK ADD ---*/
    [self.mAssist assistUpdateValueForCharacteristic:characteristic];
}


#pragma mark - 杰理蓝牙库OTA流程相关业务

/**
 *  获取已连接的蓝牙设备信息，这里如果上次设备升级没有成功，会要求执行otaFuncWithFilePath:强制升级
 */
- (void)getDeviceInfo:(GET_DEVICE_CALLBACK _Nonnull)callback {
    __weak typeof(self) weakSelf = self;
    NSLog(@"getDeviceInfo:%d",__LINE__);
    /*--- 获取设备信息 ---*/
    [self.mAssist.mCmdManager cmdTargetFeatureResult:^(JL_CMDStatus status, uint8_t sn, NSData * _Nullable data) {
        NSLog(@"getDeviceInfo:%d",__LINE__);
        if (status == JL_CMDStatusSuccess) {
            JLModel_Device *model = [weakSelf.mAssist.mCmdManager outputDeviceModel];
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
                [weakSelf.mAssist.mCmdManager cmdGetSystemInfo:JL_FunctionCodeCOMMON Result:nil];
                callback(false);
            }];
        } else {
            NSLog(@"---> ERROR：设备信息获取错误!");
        }
    }];
}

/**
 *  ota升级
 *  @param otaFilePath ota升级文件路径
 */
- (void)otaFuncWithFilePath:(NSString *)otaFilePath {
    NSLog(@"current otaFilePath ---> %@", otaFilePath);
    self.selectedOtaFilePath = otaFilePath;
    NSData *otaData = [[NSData alloc] initWithContentsOfFile:otaFilePath];
    
    [JLBleManager sharedInstance];
    JL_OTAManager *otaManager = self.mAssist.mCmdManager.mOTAManager;
    
    [otaManager cmdOTAData:otaData Result:^(JL_OTAResult result, float progress) {
        for (id<JLBleManagerOtaDelegate> objc in self.delegates) {
            if([objc respondsToSelector:@selector(otaProgressWithOtaResult:withProgress:)]){
                [objc otaProgressWithOtaResult:result withProgress:progress];
            }
        }
        
    }];
}

@end





