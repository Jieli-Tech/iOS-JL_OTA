//
//  BrowsecastBleManager.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/25.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "BroadcastBleManager.h"
#import "ToolsHelper.h"
#import "FittingView.h"
#import "BroadcastThread.h"

NSString *kBDM_BLE_FOUND        = @"BDM_BLE_FOUND";            //发现设备
NSString *kBDM_BLE_PAIRED       = @"BDM_BLE_PAIRED";           //BLE已配对
NSString *kBDM_BLE_CONNECTED    = @"BDM_BLE_CONNECTED";        //BLE已连接
NSString *kBDM_BLE_DISCONNECTED = @"BDM_BLE_DISCONNECTED";     //BLE断开连接

NSString *BLE_SERVICE = @"AE00"; //服务号
NSString *BLE_RCSP_W  = @"AE01"; //命令“写”通道
NSString *BLE_RCSP_R  = @"AE02"; //命令“读”通道

@interface BroadcastBleManager()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *bleManager;

@property (strong, nonatomic) NSMutableArray<JLBleEntity *> *blePeripheralArr;

@property (strong, nonatomic) JL_Assist *mAssist;

@property (strong, nonatomic) CBPeripheral *bleCurrentPeripheral;
@property (strong, nonatomic) NSString *connectByUUID;
@property (strong, nonatomic) CBPeripheral *__nullable mBlePeripheral;
@property (strong, nonatomic) JLBleEntity *__nullable currentEntity;
@property (strong, nonatomic) NSString *lastUUID;                        // 上一次连接的蓝牙UUID
@property (strong, nonatomic) NSMutableArray *lastBleMacAddressList;
@property (strong, nonatomic) NSMutableDictionary *connectDict;

@end


@implementation BroadcastBleManager

+ (instancetype)sharedInstance {
    static BroadcastBleManager *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _bleManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _assistDicts = [NSMutableDictionary new];
        _blePeripheralArr = [NSMutableArray new];
        _lastBleMacAddressList = [NSMutableArray new];
        _connectDict = [NSMutableDictionary new];
    }
    return self;
}

-(void)makeAssist:(CBPeripheral *)cbp{
    JL_Assist *assist = _assistDicts[cbp.identifier.UUIDString];
    if (assist){
        _mAssist = assist;
    }else{
        /*--- JLSDK ADD ---*/
        assist = [[JL_Assist alloc] init];
        [_assistDicts setValue:assist forKey:cbp.identifier.UUIDString];
        
        _mAssist = assist;
        _mAssist.mNeedPaired = [ToolsHelper isSupportPair];             //是否需要握手配对
        /*--- 自定义配对码(16个字节配对码) ---*/
        //char pairkey[16] = {0x01,0x02,0x03,0x04,
        //                    0x01,0x02,0x03,0x04,
        //                    0x01,0x02,0x03,0x04,
        //                    0x01,0x02,0x03,0x04};
        //NSData *pairData = [NSData dataWithBytes:pairkey length:16];
        _mAssist.mPairKey    = nil;             //配对秘钥（或者自定义配对码pairData）
        _mAssist.mService    = BLE_SERVICE; //服务号
        _mAssist.mRcsp_W     = BLE_RCSP_W;  //特征「写」
        _mAssist.mRcsp_R     = BLE_RCSP_R;  //特征「读」
    }
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
- (void)disconnectBLE:(CBPeripheral *)cbp{
    kJLLog(JLLOG_DEBUG, @"BLE --->To disconnectBLE.");
    [_bleManager cancelPeripheralConnection:cbp];
    
}

#pragma mark 连接蓝牙设备

- (void)connectBLE:(CBPeripheral*)peripheral {

    [self makeAssist:peripheral];
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

-(void)connectPeripheralWithMacAddr:(NSString *)macAddr{
    kJLLog(JLLOG_DEBUG, @"---> OTA正在通过Mac Addr方式回连设备... %@", macAddr);
    if(_lastBleMacAddressList.count == 0){
        [self.bleManager scanForPeripheralsWithServices:nil options:nil];
    }
    if(![_lastBleMacAddressList containsObject:macAddr]){
        [_lastBleMacAddressList addObject:macAddr];
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
    
    kJLLog(JLLOG_DEBUG, @"发现：name:%@ advertisementData:%@",peripheral.name,advertisementData);
    
    
    [self addPeripheral:peripheral RSSI:RSSI Name:ble_name Info:info Adv:ble_AD];
    
    /*
    NSString *key = [[FittingView getFitterKey] uppercaseString];
    if ([key isEqualToString:@""]) {
//        kJLLog(JLLOG_DEBUG, @"发现 ----> NAME:%@ RSSI:%@ AD:%@", ble_name,RSSI,ble_AD);
        [self addPeripheral:peripheral RSSI:RSSI Name:ble_name Info:info Adv:ble_AD];
    }else{
        if ([[ble_name uppercaseString] rangeOfString:key].location == NSNotFound) {
            //
            kJLLog(JLLOG_DEBUG, @"过滤 ----> NAME:%@ RSSI:%@ AD:%@", ble_name,RSSI,ble_AD);
        }else{
            kJLLog(JLLOG_DEBUG, @"发现 ----> NAME:%@ RSSI:%@ AD:%@", ble_name,RSSI,ble_AD);
            [self addPeripheral:peripheral RSSI:RSSI Name:ble_name Info:info Adv:ble_AD];
        }
    }
     */
//    [self addPeripheral:peripheral RSSI:RSSI Name:ble_name Info:info];

    [DFNotice post:kBDM_BLE_FOUND Object:_blePeripheralArr];
    
    // ota升级过程，回连使用
    for (NSString *itemAddr in self.lastBleMacAddressList) {
        if ([JL_BLEAction otaBleMacAddress:itemAddr isEqualToCBAdvDataManufacturerData:ble_AD]) {
            [_connectDict setValue:itemAddr forKey:peripheral.identifier.UUIDString];
            [self connectBLE:peripheral];
        }
    }
}

- (void)addPeripheral:(CBPeripheral*)peripheral RSSI:(NSNumber *)rssi Name:(NSString*)name Info:(NSDictionary*)info Adv:(NSData *)advertisementData{
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
    if (flag == 0 ) {
        JLBleEntity *bleEntity = [JLBleEntity new];
        bleEntity.mName = peripheral.name;
        bleEntity.mRSSI = rssi;
        bleEntity.mType = [info[@"TYPE"] intValue];
        bleEntity.uid = [advertisementData subf:4 t:2].beLittleUint16;
        bleEntity.pid = [advertisementData subf:2 t:2].beLittleUint16;
        bleEntity.edrMacAddress = info[@"EDR"];
        uint8_t headOta[] = {0xD6,0x05,0x41,0x54,0x4F,0x4C,0x4A};
        NSData *headData = [NSData dataWithBytes:headOta length:7];
        if([[advertisementData subf:0 t:7] isEqualToData:headData]){
            if ([advertisementData subf:7 t:1].beUint8 == 0x01) {
                bleEntity.pid = [advertisementData subf:14 t:2].beLittleUint16;
                bleEntity.uid = [advertisementData subf:16 t:2].beLittleUint16;
            }else{
                bleEntity.uid = 0;
                bleEntity.pid = 0;
            }
        }
        kJLLog(JLLOG_DEBUG, @"type:%d,name:%@ pid:%hx,uid:%hx type:%d",[info[@"TYPE"] intValue],peripheral.name,bleEntity.pid,bleEntity.uid,(int)bleEntity.mType);
        bleEntity.mPeripheral = peripheral;
        if([ToolsHelper isBroadcastFitter]){
            if(bleEntity.mType == JL_DeviceTypeSoundBox && [advertisementData subf:0 t:2].beLittleUint16 == 0x05D6){
                [_blePeripheralArr addObject:bleEntity];
            }
        }else{
            if([advertisementData subf:0 t:2].beLittleUint16 == 0x05D6){
                [_blePeripheralArr addObject:bleEntity];
            }
        }
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
    [central stopScan];
    // 连接成功后，查找服务
    [peripheral discoverServices:nil];
}



- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    kJLLog(JLLOG_DEBUG, @"Err:BLE Connect FAIL ---> Device:%@ Error:%@",peripheral.name,[error description]);
    [[DeviceManager share] removeDevicesBy:peripheral];
    [_assistDicts removeObjectForKey:peripheral.identifier.UUIDString];
}

#pragma mark 设备断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    kJLLog(JLLOG_DEBUG, @"BLE Disconnect ---> Device %@ error:%d reason:%@", peripheral.name, (int)error.code,error);
    self.mBlePeripheral = nil;
    /*--- JLSDK ADD ---*/
    JL_Assist *assist = _assistDicts[peripheral.identifier.UUIDString];
    [assist assistDisconnectPeripheral:peripheral];
    
    [JL_Tools post:kBDM_BLE_DISCONNECTED Object:peripheral];
    
    [[DeviceManager share] removeDevicesBy:peripheral];
    [_assistDicts removeObjectForKey:peripheral.identifier.UUIDString];
}

#pragma mark - CBPeripheralDelegate

#pragma mark 设备服务回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    if (error) { kJLLog(JLLOG_DEBUG, @"Err: Discovered services fail."); return; }
    
    for (CBService *service in peripheral.services) {
        
        kJLLog(JLLOG_DEBUG, @"BLE Service ---> %@", service.UUID.UUIDString);
        [peripheral discoverCharacteristics:nil forService:service];
        
    }
}

#pragma mark 设备特征回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    if (error) { kJLLog(JLLOG_DEBUG, @"Err: Discovered Characteristics fail."); return; }
    
    /*--- JLSDK ADD ---*/
    JL_Assist *assist = _assistDicts[peripheral.identifier.UUIDString];
    [assist assistDiscoverCharacteristicsForService:service Peripheral:peripheral];
}

#pragma mark 更新通知特征的状态
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
    if (error) { kJLLog(JLLOG_DEBUG, @"Err: Update NotificationState For Characteristic fail."); return; }
    
    /*--- JLSDK ADD ---*/
    __weak typeof(self) weakSelf = self;
    JL_Assist *assist = _assistDicts[peripheral.identifier.UUIDString];
    [assist assistUpdateCharacteristic:characteristic Peripheral:peripheral Result:^(BOOL isPaired) {
        if (isPaired == YES) {
            weakSelf.lastUUID = peripheral.identifier.UUIDString;
            weakSelf.mBlePeripheral = peripheral;
            /**收集BLE信息*/
            [weakSelf collectBleMsg:peripheral];
            [weakSelf getInfo:peripheral];
            /*--- UI配对成功 ---*/
            [JL_Tools post:kBDM_BLE_PAIRED Object:peripheral];
            
        } else {
            [weakSelf.bleManager cancelPeripheralConnection:peripheral];
        }
        
    }];
}

//- (void)peripheralIsReadyToSendWriteWithoutResponse:(CBPeripheral *)peripheral{
////    kJLLog(JLLOG_DEBUG, @"ReadyToSend");
//    usleep(100);
//}
//- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//    if(error){
//        kJLLog(JLLOG_DEBUG, @"write error:%@",error);
//    }
//}

#pragma mark 设备返回的数据 GET
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) { kJLLog(JLLOG_DEBUG, @"Err: receive data fail."); return; }
    
    JL_Assist *assist = _assistDicts[peripheral.identifier.UUIDString];
    /*--- JLSDK ADD ---*/
    [assist assistUpdateValueForCharacteristic:characteristic];
}



//MARK: - 获取基本的信息以及状态
-(void)getInfo:(CBPeripheral *)peripheral{
    __weak typeof(self) weakSelf = self;
    JL_Assist *assist = _assistDicts[peripheral.identifier.UUIDString];
    /*--- 获取设备信息 ---*/
    [assist.mCmdManager cmdTargetFeatureResult:^(JL_CMDStatus status, uint8_t sn, NSData * _Nullable data) {
        
        if (status == JL_CMDStatusSuccess) {
            JLModel_Device *model = [weakSelf.mAssist.mCmdManager outputDeviceModel];
            JL_OtaStatus upSt = model.otaStatus;
            if (upSt == JL_OtaStatusForce) {
                kJLLog(JLLOG_DEBUG, @"---> 进入强制升级.");
                NSString *mac = [weakSelf.connectDict valueForKey:peripheral.identifier.UUIDString];
                if(mac){
                    [[BroadcastThread share] otaUpdateStepII:mac Info:peripheral];
                    [weakSelf.lastBleMacAddressList removeObject:mac];
                    [weakSelf.connectDict removeObjectForKey:peripheral.identifier.UUIDString];
                    
                    for (NSString *macStr in weakSelf.lastBleMacAddressList) {
                        kJLLog(JLLOG_DEBUG, @"lastBleMacAddressList:%@",macStr);
                    }
                    for (NSObject *objc in weakSelf.connectDict) {
                        kJLLog(JLLOG_DEBUG, @"connectDict:%@",objc);
                    }
                }
                
                if(weakSelf.lastBleMacAddressList.count > 0){
                    kJLLog(JLLOG_DEBUG, @"继续搜索设备进行回连:\n");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{                    
                        [weakSelf.bleManager scanForPeripheralsWithServices:nil options:nil];
                    });
                }
                return;
            }
            kJLLog(JLLOG_DEBUG, @"---> 设备正常使用...");
            [assist.mCmdManager cmdGetSystemInfo:JL_FunctionCodeCOMMON Result:nil];
            
        } else {
            kJLLog(JLLOG_DEBUG, @"---> ERROR：设备信息获取错误!");
        }
    }];
}

//MARK: - 收集已连接BLE的相关信息
-(void)collectBleMsg:(CBPeripheral *)cbp{
    for (JLBleEntity *entity in _blePeripheralArr) {
        if([entity.mPeripheral isEqual:cbp]){
            [[DeviceManager share] addDevicesEntity:entity WithManager:self.mAssist.mCmdManager];
            break;
        }
    }
}


@end
