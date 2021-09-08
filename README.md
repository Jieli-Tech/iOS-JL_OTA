[toc]

# iOS杰理蓝牙OTA开发说明v1.5.0

- 对应的芯片类型：AC692x，BD29
- APP开发环境：iOS平台，iOS 10.0以上，Xcode 11.0以上
- 基于「杰理蓝牙控制库SDK v1.5.0 **(多设备版)**」 开发
- 对应于苹果商店上的APP: **【OTA Update】**
- 源码连接： https://github.com/Jieli-Tech/iOS-JL_OTA

## 声明

1. 本项⽬所参考、使⽤技术必须全部来源于公知技术信息，或⾃主创新设计。 

2. 本项⽬不得使⽤任何未经授权的第三⽅知识产权的技术信息。 

3. 如个⼈使⽤未经授权的第三⽅知识产权的技术信息，造成的经济损失和法律后果由个⼈承担。 

## 版本

| 版本 | 日期           | 编辑    | 修改内容                                       |
| ---- | -------------- | ------- | ---------------------------------------------- |
| v1.5.0 | 2021年09月08日 | 冯 洪鹏 | 优化自定义蓝牙SDK的接入方式 |
| v1.2 | 2020年12月09日 | 冯 洪鹏 | 更新文档 |
| v1.1 | 2020年04月20日 | 冯 洪鹏 | 增加升级的错误回调                             |
| v1.0 | 2019年09月09日 | 冯 洪鹏 | OTA升级功能                                    |


## 概述

本文档是为了后续开发者更加便捷移植杰理OTA升级功能而创建。

## 1、导入JL_BLEKit.framework

将*JL_BLEKit.framework*导入Xcode工程项目里，添加*Privacy - Bluetooth Peripheral Usage Description*和*Privacy - Bluetooth Always Usage Description*两个权限。

## 2、SDK具体使用的两种方式
​        第一种，使用SDK内的蓝牙连接API进行OTA：完全使用SDK。

​        第二种，使用自定义的蓝牙连接API进行OTA：所有BLE的操作都自行实现，SDK只负责对OTA数据包解析

从而实现OTA功能。

### 2.1、使用SDK内的蓝牙连接API进行OTA

**参考Demo：「 OTA_Update(内部BLE) 」**

**1、支持的功能**：

- BLE设备的扫描、连接、断开、收发数据、回连功能；

- BLE设备过滤；

- BLE设备握手连接；

- BLE连接服务和特征值设置；

- 获取设备信息；

- OTA升级能实现；

**2、会用到的类**：

- **JL_BLEUsage** ：可设置BLE过滤、握手、参数；

  ​                             查看蓝牙状态；（详情看*2.1.1*，*2.1.2*，*2.1.3*，*2.1.4*，*2.1.5*）

- **JL_Entity**：BLE设备的模型类，记录设备的相关信息（如名字、UUID、UID、PID等）；

- **JL_Manager**：BLE扫描、连接、断开、回连、获取设备信息、OTA操作；
#### 2.1.1、过滤BLE外设机制
```objective-c
        /*--- YES开启过滤，NO关闭过滤 ---*/
        JL_BLEUsage *usage = [JL_BLEUsage sharedMe];
        usage.bt_ble.BLE_FILTER_ENABLE = YES; 
        
        /*--- 过滤码设置，赋值nil为默认值 ---*/
        usage.bt_ble.filterKey = nil;//一般情况赋值nil即可
```

#### 2.1.2、与BLE外设握手机制

```objective-c
        /*--- YES开启握手，NO关闭握手BLE直接连接 ---*/
        JL_BLEUsage *usage = [JL_BLEUsage sharedMe];
        usage.bt_ble.BLE_PAIR_ENABLE = YES; 
        
        /*--- 配对码设置，赋值nil为默认值 ---*/
        usage.bt_ble.pairKey = nil;//一般情况赋值nil即可
```

#### 2.1.3、回连BLE外设机制

```objective-c
        /*--- 1、BLE外设自己断开后，APP的主动回连 ---*/
        JL_BLEUsage *usage = [JL_BLEUsage sharedMe];
        usage.bt_ble.BLE_RELINK_ACTIVE = YES; //一般情况赋值NO即可
        
        /*--- 2、iPhone关闭蓝牙后，开启蓝牙，APP的主动回连 ---*/
        usage.bt_ble.BLE_RELINK = YES;//一般情况赋值NO即可
```

#### 2.1.4、BLE连接服务和特征值

```objective-c
        //一般情况以下设置不用更改，不设置就是默认这些值。
        usage.bt_ble.JL_BLE_SERVICE = @"AE00"; //服务号
        usage.bt_ble.JL_BLE_RCSP_W  = @"AE01"; //命令“写”通道
        usage.bt_ble.JL_BLE_RCSP_R  = @"AE02"; //命令“读”通道
        usage.bt_ble.JL_BLE_PAIR_W  = @"AE03"; //暂无使用
        usage.bt_ble.JL_BLE_PAIR_R  = @"AE04"; //暂无使用
        usage.bt_ble.JL_BLE_AUIDO_W = @"AE05"; //暂无使用
        usage.bt_ble.JL_BLE_AUIDO_R = @"AE06"; //暂无使用
```


#### 2.1.5、初始化SDK

```objective-c
        //根据需求，按照文档的1、2、3、4点设置SDK
        /*--- 初始化JL_SDK ---*/
        [JL_Manager setManagerDelegate:self];
        JL_BLEUsage *usage = [JL_BLEUsage sharedMe];
        usage.bt_ble.BLE_PAIR_ENABLE = YES;
        usage.bt_ble.BLE_FILTER_ENABLE = YES;
        usage.bt_ble.BLE_RELINK_ACTIVE = NO;
        usage.bt_ble.BLE_RELINK = NO;
        usage.bt_ble.filterKey = nil;
        usage.bt_ble.pairKey = nil;
```

#### 2.1.6、扫描设备

```objective-c
        //API通过【JL_Manager】使用
        /**
         开始扫描
         */
        +(void)bleStartScan;
        /**
        停止扫描
         */
        +(void)bleStopScan;

        //监听通知【JL_BLEStatusFound】回调设备数组
        JL_BLEUsage *JL_ug = [JL_BLEUsage sharedMe];
    NSArray     *btEnityList = JL_ug.bt_EntityList;
```

#### 2.1.7、连接和断开设备

```objective-c
        //API通过【JL_Manager】使用
        /**第一种连接方式：
         连接蓝牙外设，如果外设不在已发现的外设列表中，则返回失败
         @param peripheral 要连接的蓝牙外设
         @return 返回是否成功发起连接
         */
        +(BOOL)bleConnectToDevice:(CBPeripheral *)peripheral;
        
        /**第二种连接方式：
     通过UUID的连接设备
     @param uuid 设备的UUID
     */
    +(void)bleConnectDeviceWithUUID:(NSString*)uuid;
    
    /**
     断开当前连接的蓝牙设备，不会影响下次的自动连接
     */
    +(void)bleDisconnect;
        
        //1、在发现的设备数组里以【JL_Entity】存储，详情可以看【JL_BLEUsage.h】头文件。
        //2、连接成功，回调【JL_BLEStatusPaired】
        //3、连接失败、BLE断开，回调【JL_BLEStatusDisconnected】
        //4、手机蓝牙关闭，回调【JL_BLEStatusOff】
        //5、手机蓝牙开启，回调【JL_BLEStatusOn】
        //6、连接过程错误，回调【kJL_BLE_ERROR】
         /**
         *  错误代码：
         *  4001  BLE未开启
         *  4002  BLE不支持
         *  4003  BLE未授权
         *  4004  BLE重置中
         *  4005  未知错误
         *  4006  连接失败
         *  4007  连接超时
         *  4008  特征值超时
         *  4009  配对失败
         *  4010  设备UUID无效
         */
```

#### 2.1.8、获取设备信息(必须)

```objective-c
        //注意：API通过【JL_Manager】使用，连上设备必须先获取设备的信息！
        //在连接成功后，即可调用获取设备信息(最好延时0.5秒执行)
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
                    return;
                }
                
                /*--- 后续会用版本来决定是否要OTA升级 ---*/
                NSLog(@"---> 当前固件版本号：%@",md.versionFirmware);
                
                JL_OtaStatus upSt = md.otaStatus;
                if (upSt == JL_OtaStatusForce) {
                    NSLog(@"---> 进入强制升级.");
                    //此处必须将设备升级，否则无法使用
                }else{
                    JL_OtaHeadset hdSt = md.otaHeadset;
                    if (hdSt == JL_OtaHeadsetYES) {
                        //此处必须将设备升级，否则无法使用，针对单备份的耳机设备OTA操作。
                        //(一般情况不回来到这)
                    }
                }
            }else{
                NSLog(@"---> 错误提示：%d",st);
            }
        }];
```

#### 2.1.9、开始OTA升级

```objective-c
        _otaData = [NSData dataWithContentsOfFile:@"升级文件的路径"];
    [JL_Manager cmdOTAData:self.otaData Result:^(JL_OTAResult result, float progress) {
        if (result == JL_OTAResultUpgrading ||
            result == JL_OTAResultPreparing)
        {
            [self isUpdatingUI:YES];
            //NSLog(@"%.1f%%",progress*100.0f);
            NSString *txt = [NSString stringWithFormat:@"%.1f%%",progress*100.0f];
            self.updateSeek.text = txt;
            self.updateProgress.progress = progress;
            
            if (result == JL_OTAResultPreparing) self.updateTxt.text = kJL_TXT("校验文件中");
            if (result == JL_OTAResultUpgrading) self.updateTxt.text = kJL_TXT("正在升级");

            [self otaTimeCheck];//增加超时检测
        }else if(result == JL_OTAResultPrepared){
            NSLog(@"OTA is ResultPrepared...");
            [self otaTimeCheck];//增加超时检测
        }else{
            [self otaTimeClose];//关闭超时检测
        }
        
        if (result == JL_OTAResultSuccess) {
            NSLog(@"OTA 升级完成.");
            self.updateTxt.text = kJL_TXT("升级完成");
            self.updateProgress.progress = 1.0;
        }
        
        if (result == JL_OTAResultReboot) {
            NSLog(@"OTA 设备准备重启.");
            //self.updateTxt.text = kJL_TXT("设备准备重启");
            self.updateTxt.text = kJL_TXT("升级完成");
            [DFUITools showText:kJL_TXT("升级完成") onView:self.view delay:1.0];

            [DFAction delay:1.5 Task:^{
                [self isUpdatingUI:NO];
                //[JL_Tools post:@"UI_CHANEG_VC" Object:@(1)];
                [JL_Manager bleConnectLastDevice];
            }];
        }
        
        if (result == JL_OTAResultFailCompletely) {
            self.updateTxt.text = kJL_TXT("升级失败");
            [DFUITools showText:kJL_TXT("升级失败") onView:self.view delay:1.0];

            [DFAction delay:1.5 Task:^{
                [self isUpdatingUI:NO];
            }];
        }
        
        if (result == JL_OTAResultFailKey) {
            self.updateTxt.text = kJL_TXT("升级文件KEY错误");
            [DFUITools showText:kJL_TXT("升级文件KEY错误") onView:self.view delay:1.0];

            [DFAction delay:1.5 Task:^{
                [self isUpdatingUI:NO];
            }];
        }
        
        if (result == JL_OTAResultFailErrorFile) {
            self.updateTxt.text = kJL_TXT("升级失败");
            [DFUITools showText:kJL_TXT("升级失败") onView:self.view delay:1.0];

            [DFAction delay:1.5 Task:^{
                [self isUpdatingUI:NO];
            }];
        }
    }];
```

### 2.2、使用自定义的蓝牙连接API进行OTA

**参考Demo：「 OTA_Update(外部BLE) 」**

**1、支持的功能**：

- BLE设备握手连接；

- 获取设备信息；

- OTA升级能实现；

  注意：相对于2.1中描述的所有BLE操作都需自行实现。

**2、会用到的类**：

- **JL_Assist**：部署SDK类；(必须)
- **JL_ManagerM**：命令处理中心，所有的命令操作都集中于此；(必须)
- **JLModel_Device**：设备信息存储的数据模型；(必须)

**3、BLE参数**：

- **【服务号】**：AE00
- **【写】特征值**：AE01
- **【读 】特征值**：AE02


### 2.2.1、初始化SDK 
```objective-c
        /*--- JLSDK ADD ---*/
        self.mAssist = [[JL_Assist alloc] init];
        self.mAssist.mNeedPaired = YES;             //是否需要握手配对
        self.mAssist.mPairKey    = nil;             //配对秘钥
        self.mAssist.mService    = @"AE00";                 //服务号
        self.mAssist.mRcsp_W     = @"AE01";                  //特征「写」
        self.mAssist.mRcsp_R     = @"AE02";                  //特征「读」

```
### 2.2.2、BLE设备特征回调

```objective-c
#pragma mark - 设备特征回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service
             error:(nullable NSError *)error
{
    if (error) { NSLog(@"Err: Discovered Characteristics fail."); return; }
    
    /*--- JLSDK ADD ---*/
    [self.mAssist assistDiscoverCharacteristicsForService:service Peripheral:peripheral];
}
```


### 2.2.3、BLE更新通知特征的状态
```objective-c
#pragma mark - 更新通知特征的状态
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(nonnull CBCharacteristic *)characteristic
             error:(nullable NSError *)error
{
    if (error) { NSLog(@"Err: Update NotificationState For Characteristic fail."); return; }
    
    /*--- JLSDK ADD ---*/
    [self.mAssist assistUpdateCharacteristic:characteristic
                                  Peripheral:peripheral
                                      Result:^(BOOL isPaired) {
        if (isPaired == YES) {
            self->_mBlePeripheral = peripheral;
            
              //配对成功，可以继续从此处操作设备；
        }else{
            [self->bleManager cancelPeripheralConnection:peripheral];
        }
    }];
}


```

### 2.2.4、BLE**设备返回的数据**
```objective-c
#pragma mark - 设备返回的数据 GET
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    if (error) { NSLog(@"Err: receive data fail."); return; }

    /*--- JLSDK ADD ---*/
    [self.mAssist assistUpdateValueForCharacteristic:characteristic];
}
```
### 2.2.5、BLE**设备断开连接**
```objective-c
#pragma mark - 设备断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(nullable NSError *)error
{
    NSLog(@"BLE Disconnect ---> Device %@ error:%d",peripheral.name,(int)error.code);
    self.mBlePeripheral = nil;
    
    /*--- JLSDK ADD ---*/
    [self.mAssist assistDisconnectPeripheral:peripheral];
}
```
### 2.2.6、手机蓝牙状态更新
```objective-c
//外部蓝牙，手机蓝牙状态回调处，实现以下：
#pragma mark - 蓝牙初始化 Callback
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSInteger st = central.state;
  
    /*--- JLSDK ADD ---*/
    [self.mAssist assistUpdateState:st];
}
```
### 2.2.7、功能实现
#### 2.2.7.1、获取设备信息 （BLE连接且配对后必须执行一次）
```objective-c
[self.mAssist.mCmdManager cmdTargetFeatureResult:^(NSArray * _Nullable array) {
        JL_CMDStatus st = [array[0] intValue];
        if (st == JL_CMDStatusSuccess) {
            JL_OtaStatus upSt = model.otaStatus;
            if (upSt == JL_OtaStatusForce) {
                NSLog(@"---> 进入强制升级.");
                [self noteOtaUpdate:nil];
                return;
            }else{
                if (model.otaHeadset == JL_OtaHeadsetYES) {
                    NSLog(@"---> 进入强制升级: OTA另一只耳机.");
                    [self noteOtaUpdate:nil];
                    return;
                }
            }
            NSLog(@"---> 设备正常使用...");
            [JL_Tools mainTask:^{
                [DFUITools showText:@"设备正常使用" onView:self.view delay:1.0];
                
                /*--- 获取公共信息 ---*/
                [self.mAssist.mCmdManager cmdGetSystemInfo:JL_FunctionCodeCOMMON Result:nil];
            }];
        }else{
            NSLog(@"---> ERROR：设备信息获取错误!");
        }
    }];
```
#### 2.2.7.2、固件OTA升级
```objective-c
   //升级流程：连接设备-->获取设备信息-->是否强制升级-->(是)则必须调用该API去OTA升级;
     //                                                                        |_______>(否)则可以正常使用APP;
                                                                            
        NSData *otaData = [[NSData alloc] initWithContentsOfFile:@"OTA升级文件路径"];
    [self.mAssist.mCmdManager cmdOTAData:otaData Result:^(JL_OTAResult result, float progress) {
        if (result == JL_OTAResultSuccess) {
            NSLog(@"--->升级成功.");
        }
        if (result == JL_OTAResultFail) {
            NSLog(@"--->OTA升级失败");
        }
        if (result == JL_OTAResultDataIsNull) {
            NSLog(@"--->OTA升级数据为空!");
        }
        if (result == JL_OTAResultCommandFail) {
            NSLog(@"--->OTA指令失败!");
        }
        if (result == JL_OTAResultSeekFail) {
            NSLog(@"--->OTA标示偏移查找失败!");
        }
        if (result == JL_OTAResultInfoFail) {
            NSLog(@"--->OTA升级固件信息错误!");
        }
        if (result == JL_OTAResultLowPower) {
            NSLog(@"--->OTA升级设备电压低!");
        }
        if (result == JL_OTAResultEnterFail) {
            NSLog(@"--->未能进入OTA升级模式!");
        }
        if (result == JL_OTAResultUnknown) {
            NSLog(@"--->OTA未知错误!");
        }
        if (result == JL_OTAResultFailSameVersion) {
            NSLog(@"--->相同版本！");
        }
        if (result == JL_OTAResultFailTWSDisconnect) {
            NSLog(@"--->TWS耳机未连接");
        }
        if (result == JL_OTAResultFailNotInBin) {
            NSLog(@"--->耳机未在充电仓");
        }
        
        if (result == JL_OTAResultPreparing ||
            result == JL_OTAResultUpgrading)
        {
            if (result == JL_OTAResultUpgrading) NSLog(@"---> 正在升级：%.1f",progress*100.0f);
            if (result == JL_OTAResultPreparing) NSLog(@"---> 检验文件：%.1f",progress*100.0f);
        }
        
        if (result == JL_OTAResultPrepared) {
            NSLog(@"---> 检验文件【完成】");
        }
        if (result == JL_OTAResultReconnect) {
            NSLog(@"---> OTA正在回连设备... %@",self->bt_ble.mBleName);
            [self->bt_ble connectPeripheralWithUUID:self->bt_ble.lastUUID];//自行实现回连
        }
    }];
```
