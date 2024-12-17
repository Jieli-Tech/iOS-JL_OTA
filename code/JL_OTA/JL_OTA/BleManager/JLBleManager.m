//
//  JLBleManager.m
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/11.
//

#import "JLBleManager.h"
#import "FittingView.h"
#import "SingleDataSender.h"

#define SENDBYSINGLE  0 //1：通过信号检测发送 0：通过直接塞数据发送

NSString *kFLT_BLE_FOUND        = @"FLT_BLE_FOUND";            //发现设备
NSString *kFLT_BLE_PAIRED       = @"FLT_BLE_PAIRED";           //BLE已配对
NSString *kFLT_BLE_CONNECTED    = @"FLT_BLE_CONNECTED";        //BLE已连接
NSString *kFLT_BLE_DISCONNECTED = @"FLT_BLE_DISCONNECTED";     //BLE断开连接

NSString *FLT_BLE_SERVICE = @"AE00"; //服务号
NSString *FLT_BLE_RCSP_W  = @"AE01"; //命令“写”通道
NSString *FLT_BLE_RCSP_R  = @"AE02"; //命令“读”通道



@interface JLBleManager() <CBCentralManagerDelegate, CBPeripheralDelegate,JL_OTAManagerDelegate,JLHashHandlerDelegate,SingleSendDelegate>

@property (strong, nonatomic) CBCentralManager *bleManager;
@property (strong, nonatomic) JLHashHandler *pairHash;
@property (assign, nonatomic) BOOL pairStatus;

@property (strong, nonatomic) NSMutableArray<JLBleEntity *> *blePeripheralArr;
@property (strong, nonatomic) CBPeripheral *bleCurrentPeripheral;
@property (strong, nonatomic) CBService * mService;
@property (strong, nonatomic) CBCharacteristic *mRcspWrite;
@property (strong, nonatomic) CBCharacteristic *mRcspRead;

@property (strong, nonatomic) NSString *selectedOtaFilePath;
@property (strong, nonatomic) NSString *connectByUUID;

@property (strong, nonatomic) GET_DEVICE_CALLBACK getCallback;


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
        _isPaired = YES;
        _pairStatus = NO;
        
        _bleManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        /*--- JLSDK ADD ---*/
        _otaManager = [JL_OTAManager getOTAManager];
        [JL_OTAManager logSDKVersion];
        [JLHashHandler sdkVersion];
        [_otaManager logSendData:false];
        
        _otaManager.delegate = self;
        
        self.pairHash = [[JLHashHandler alloc] init];
        self.pairHash.delegate = self;
        
        _connectByUUID = nil;
#if SENDBYSINGLE
        [[SingleDataSender share] addDelegate:self];
#endif
        
    }
    return self;
}

- (void)setIsPaired:(BOOL)isPaired {
    _isPaired = isPaired;
}


#pragma mark - 扫描设备相关

#pragma mark 开始扫描
- (void)startScanBLE {
    kJLLog(JLLOG_DEBUG, @"BLE ---> startScanBLE.");
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
        kJLLog(JLLOG_DEBUG, @"BLE --->To disconnectBLE.");
        [_bleManager cancelPeripheralConnection:_bleCurrentPeripheral];
        self.isConnected = false;
        self.currentEntity = nil;
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

    kJLLog(JLLOG_DEBUG, @"BLE Connecting... Name ---> %@", peripheral.name);
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
            kJLLog(JLLOG_DEBUG, @"reconnect:%@",cbp);
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
        kJLLog(JLLOG_DEBUG, @"FLT Connecting(Last)... Name ---> %@ UUID:%@",ble_name,ble_uuid);
        
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
    NSDictionary *info = [JLAdvParse bluetoothAdvParse:self.pairKey AdvData:advertisementData];
    if (ble_name.length == 0) return;
    
    kJLLog(JLLOG_DEBUG, @"发现 ----> NAME:%@ RSSI:%@ AD:%@", ble_name,RSSI,ble_AD);
    
    NSString *key = [[FittingView getFitterKey] uppercaseString];
    if ([key isEqualToString:@""]) {
        [self addPeripheral:peripheral RSSI:RSSI Name:ble_name Info:info];
    }else{
        if ([[ble_name uppercaseString] rangeOfString:key].location == NSNotFound) {
            //
            kJLLog(JLLOG_DEBUG, @"过滤 ----> NAME:%@ RSSI:%@ AD:%@", ble_name,RSSI,ble_AD);
        }else{
            [self addPeripheral:peripheral RSSI:RSSI Name:ble_name Info:info];
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kFLT_BLE_FOUND object:_blePeripheralArr userInfo:nil];
    
    // ota升级过程，回连使用
    if ([JLAdvParse otaBleMacAddress:self.lastBleMacAddress isEqualToCBAdvDataManufacturerData:ble_AD]) {
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
        kJLLog(JLLOG_DEBUG, @"type:%d,name:%@",[info[@"TYPE"] intValue],name);
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
    kJLLog(JLLOG_DEBUG, @"BLE Connected ---> Device %@", peripheral.name);
    for (JLBleEntity *entity in self.blePeripheralArr) {
        if([entity.mPeripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]){
            self.currentEntity = entity;
            break;
        }
    }
    self.isConnected = YES;
    
    _otaManager.mBLE_NAME = peripheral.name;
    _otaManager.mBLE_UUID = peripheral.identifier.UUIDString;
    
    [DFNotice post:kFLT_BLE_CONNECTED Object:peripheral];
    // 连接成功后，查找服务
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    kJLLog(JLLOG_DEBUG, @"Err:BLE Connect FAIL ---> Device:%@ Error:%@",peripheral.name,[error description]);
}

#pragma mark 设备断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    kJLLog(JLLOG_DEBUG, @"BLE Disconnect ---> Device %@ error:%d", peripheral.name, (int)error.code);
    
    [_otaManager noteEntityDisconnected];
    self.isConnected = NO;
    self.pairStatus = NO;
    /*--- UI刷新，设备断开 ---*/
    [[NSNotificationCenter defaultCenter] postNotificationName:kFLT_BLE_DISCONNECTED object:peripheral];
}

#pragma mark - CBPeripheralDelegate

#pragma mark 设备服务回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    if (error) { kJLLog(JLLOG_DEBUG, @"Err: Discovered services fail."); return; }
    _mBlePeripheral = peripheral;
    for (CBService *service in peripheral.services) {
        //如果我们知道要查询的特性的CBUUID，可以在参数一中传入CBUUID数组。
        //if ([service.UUID.UUIDString isEqual:FLT_BLE_SERVICE]) {
            kJLLog(JLLOG_DEBUG, @"BLE Service ---> %@", service.UUID.UUIDString);
            [peripheral discoverCharacteristics:nil forService:service];
            //break;
        //}
    }
}

#pragma mark 设备特征回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    if (error) { kJLLog(JLLOG_DEBUG, @"Err: Discovered Characteristics fail."); return; }
    
    if ([service.UUID.UUIDString isEqual:FLT_BLE_SERVICE]) {
        
        for (CBCharacteristic *character in service.characteristics) {
            /*--- RCSP ---*/
            if ([character.UUID.UUIDString isEqual:FLT_BLE_RCSP_W]) {
                kJLLog(JLLOG_DEBUG, @"BLE Get Rcsp(Write) Channel ---> %@",character.UUID.UUIDString);
                self.mRcspWrite = character;
            }
            
            if ([character.UUID.UUIDString isEqual:FLT_BLE_RCSP_R]) {
                kJLLog(JLLOG_DEBUG, @"BLE Get Rcsp(Read) Channel ---> %@",character.UUID.UUIDString);
                self.mRcspRead = character;
                [peripheral setNotifyValue:YES forCharacteristic:character];
                
                if(self.mRcspRead.properties == CBCharacteristicPropertyRead){
                    [peripheral readValueForCharacteristic:character];
                    kJLLog(JLLOG_DEBUG, @"BLE  Rcsp(Read) Read Value For Characteristic.");
                }
            }
        }
    }
}

#pragma mark 更新通知特征的状态
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
    if (error) { kJLLog(JLLOG_DEBUG, @"Err: Update NotificationState For Characteristic fail."); return; }
    
    if ([characteristic.service.UUID.UUIDString isEqual:FLT_BLE_SERVICE] &&
        [characteristic.UUID.UUIDString isEqual:FLT_BLE_RCSP_R]          &&
        characteristic.isNotifying == YES)
    {
        
        __weak typeof(self) weakSelf = self;
        self.bleMtu = [peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithoutResponse];
        kJLLog(JLLOG_DEBUG, @"BLE ---> MTU:%lu",(unsigned long)self.bleMtu);
        if (self.isPaired == YES) {
            [_pairHash hashResetPair];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //设备认证
                [self->_pairHash bluetoothPairingKey:self.pairKey Result:^(BOOL ret) {
                    if(ret){
                        weakSelf.lastUUID = peripheral.identifier.UUIDString;
                        weakSelf.lastBleMacAddress = nil;
                        [[NSNotificationCenter defaultCenter] postNotificationName:kFLT_BLE_PAIRED object:peripheral];
                        [weakSelf.otaManager noteEntityConnected];
                        weakSelf.pairStatus = YES;
                    }else{
                        kJLLog(JLLOG_DEBUG, @"JL_Assist Err: bluetooth pairing fail.");
                        [weakSelf.bleManager cancelPeripheralConnection:peripheral];
                    }
                }];
            });
        }else{
            self.lastUUID = peripheral.identifier.UUIDString;
            self.lastBleMacAddress = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:kFLT_BLE_PAIRED object:peripheral];
            [self.otaManager noteEntityConnected];
        }
    }
    self.isConnected = YES;
}

#pragma mark 设备返回的数据 GET
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) { kJLLog(JLLOG_DEBUG, @"Err: receive data fail."); return; }

    if(_isPaired == YES && _pairStatus == NO){
        //收到设备的认证交互数据
        [_pairHash inputPairData:characteristic.value];
    }else{
        //收到的设备数据，正常通讯数据
        [_otaManager cmdOtaDataReceive:characteristic.value];
    }

}

- (void)peripheralIsReadyToSendWriteWithoutResponse:(CBPeripheral *)peripheral{
    
#if SENDBYSINGLE
    [[SingleDataSender share] sendSingle];
#endif
    
}


#pragma mark - 杰理蓝牙库OTA流程相关业务

/**
 *  获取已连接的蓝牙设备信息，这里如果上次设备升级没有成功，会要求执行otaFuncWithFilePath:强制升级
 */
- (void)getDeviceInfo:(GET_DEVICE_CALLBACK _Nonnull)callback {
    /*--- 获取设备信息 ---*/
    _getCallback = callback;
    [_otaManager cmdTargetFeature];
}

/**
 *  ota升级
 *  @param otaFilePath ota升级文件路径
 */
- (void)otaFuncWithFilePath:(NSString *)otaFilePath {
    kJLLog(JLLOG_DEBUG, @"current otaFilePath ---> %@", otaFilePath);
    self.selectedOtaFilePath = otaFilePath;
    NSData *otaData = [[NSData alloc] initWithContentsOfFile:otaFilePath];
    
    [_otaManager cmdOTAData:otaData Result:^(JL_OTAResult result, float progress) {
        for (id<JLBleManagerOtaDelegate> objc in self.delegates) {
            if([objc respondsToSelector:@selector(otaProgressWithOtaResult:withProgress:)]){
                [objc otaProgressWithOtaResult:result withProgress:progress];
            }
        }
        
    }];
}

- (void)otaFuncCancel:(CANCEL_CALLBACK _Nonnull)result{
    
    [_otaManager cmdOTACancelResult:^(uint8_t status, uint8_t sn, NSData * _Nullable data) {
        result(status);
    }];
}



//MARK: - ota manager delegate callback
-(void)otaCancel{
    //TODO: 取消OTA升级回调
}
-(void)otaUpgradeResult:(JL_OTAResult)result Progress:(float)progress{
    //TODO: 设备升级过程回调，包括进度状态
}

-(void)otaDataSend:(NSData *)data{
    [self writeDataByCbp:data];
}

-(void)otaFeatureResult:(JL_OTAManager *)manager{
    
    kJLLog(JLLOG_DEBUG, @"getDeviceInfo:%d",__LINE__);
    if (manager.otaStatus == JL_OtaStatusForce) {
        kJLLog(JLLOG_DEBUG, @"---> 进入强制升级.");
        if (self.selectedOtaFilePath) {
            [self otaFuncWithFilePath:self.selectedOtaFilePath];
        } else {
            _getCallback(true);
        }
        return;
    } else {
        if (manager.otaHeadset == JL_OtaHeadsetYES) {
            kJLLog(JLLOG_DEBUG, @"---> 进入强制升级: OTA另一只耳机.");
            if (self.selectedOtaFilePath) {
                [self otaFuncWithFilePath:self.selectedOtaFilePath];
            } else {
                _getCallback(true);
            }
            return;
        }
    }
    kJLLog(JLLOG_DEBUG, @"---> 设备正常使用...");
    dispatch_async(dispatch_get_main_queue(), ^{
        /*--- 获取公共信息 ---*/
        [self->_otaManager cmdSystemFunction];
        self->_getCallback(false);
    });

}

//MARK: - Hash pair delegate callback

-(void)hashOnPairOutputData:(NSData *)data{
    [self writeDataByCbp:data];
}


//MARK: - data send manager

/// 需要分包发送
/// - Parameter data: 数据
-(void)writeDataByCbp:(NSData *)data{
    //    kJLLog(JLLOG_DEBUG, @"%s:data:%@",__func__,data);
        if (_mBlePeripheral && self.mRcspWrite) {
            if (data.length > 0 ) {
                NSInteger len = data.length;
                while (len>0) {
                    if (len <= _bleMtu) {
                        NSData *mtuData = [data subdataWithRange:NSMakeRange(0, data.length)];
                        [self selectSendAction:mtuData];
                        len -= data.length;
                    }else{
                        NSData *mtuData = [data subdataWithRange:NSMakeRange(0, _bleMtu)];
                        [self selectSendAction:mtuData];
                        len -= _bleMtu;
                        data = [data subdataWithRange:NSMakeRange(_bleMtu, len)];
                    }
                }
            }
        }else{
            //需要先赋值写特征的内容
            kJLLog(JLLOG_DEBUG, @"need to init");
        }
}

-(void)selectSendAction:(NSData *)data{
    
#if SENDBYSINGLE
    [[SingleDataSender share] appendSend:data];
#else
    [_mBlePeripheral writeValue:data
      forCharacteristic:self.mRcspWrite
                   type:CBCharacteristicWriteWithoutResponse];
#endif
    
}


//MARK: - 通过信号阀发送
- (void)singleDidSendData:(NSData *)data{
    [_mBlePeripheral writeValue:data
      forCharacteristic:self.mRcspWrite
                   type:CBCharacteristicWriteWithoutResponse];
}


@end





