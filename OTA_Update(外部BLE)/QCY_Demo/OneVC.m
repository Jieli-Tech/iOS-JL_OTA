//
//  OneVC.m
//  QCY_Demo
//
//  Created by 杰理科技 on 2020/3/17.
//  Copyright © 2020 杰理科技. All rights reserved.
//

#import "OneVC.h"
#import "QCY_BLEApple.h"


@interface OneVC ()<UITableViewDelegate,
                    UITableViewDataSource>
{
    DFTips          *loadingTip;
    QCY_BLEApple    *bt_ble;
    NSMutableArray  *bt_EntityList;
    JL_ManagerM     *mCmdManager;
}
@property (weak  ,nonatomic) IBOutlet UIView   *subTitleView;
@property (weak  ,nonatomic) IBOutlet UILabel  *subLabel;
@property (weak  ,nonatomic) IBOutlet UIButton *refrashBtn;
@property (weak  ,nonatomic) IBOutlet UITableView *subTableview;
@property (strong,nonatomic) NSArray  *dataArray;
@property (assign,nonatomic) float sw;
@property (assign,nonatomic) float sh;
@property (assign,nonatomic) float sGap_h;
@property (assign,nonatomic) float sGap_t;
@end

@implementation OneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupBLE];
    [self addNote];

}
-(void)setupUI{
    _sw = [DFUITools screen_2_W];
    _sh = [DFUITools screen_2_H];
    if (_sh < 812.0f) {//兼容iPhoneX尺寸以下手机
        _sGap_h = 74.0;
        _sGap_t = 44.0;
    }else{
        _sGap_h = 88.0;
        _sGap_t = 64.0;
    }
    _subTitleView.frame = CGRectMake(0, 0, _sw, _sGap_h);
    _subLabel.center    = CGPointMake(_sw/2.0, _sGap_h - 20.0);
    _refrashBtn.frame   = CGRectMake(_sw-50.0, _sGap_h-50.0, 50.0, 50.0);
    
    _subTableview.frame = CGRectMake(0, _sGap_h+1, _sw, _sh-_sGap_h-_sGap_t-50.0);
    _subTableview.tableFooterView = [UIView new];
    _subTableview.dataSource= self;
    _subTableview.delegate  = self;
    _subTableview.rowHeight = 60.0;
    
}

-(void)setupBLE{
    
    bt_ble = [QCY_BLEApple new];
    bt_EntityList = [NSMutableArray new];
    mCmdManager = bt_ble.mAssist.mCmdManager;
}

- (void)refresh {
    if (!_bt_status_phone) {
        [DFUITools showText:@"蓝牙没有打开" onView:self.view delay:1.0];
        return;
    }
    /*--- 提示【搜索设备...】 ---*/
    [self startLoadingView:@"搜索..." Delay:2.0];
    /*--- 搜索蓝牙设备 ---*/
    [bt_ble startScanBLE];

    [DFAction delay:2.0 Task:^{
        [self->bt_ble stopScanBLE];
    }];
}

- (IBAction)refrash_btn:(id)sender {
    [bt_ble startScanBLE];
}

- (IBAction)info_btn:(id)sender {
    /*--- 获取设备信息 ---*/
    [mCmdManager cmdTargetFeatureResult:^(NSArray * _Nullable array) {
        JL_CMDStatus st = [array[0] intValue];
        if (st == JL_CMDStatusSuccess) {
            
            JLModel_Device *model = [self->mCmdManager outputDeviceModel];
            
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
                [self->mCmdManager cmdGetSystemInfo:JL_FunctionCodeCOMMON Result:nil];
            }];
        }else{
            NSLog(@"---> ERROR：设备信息获取错误!");
        }
    }];
}


- (IBAction)ota_btn:(id)sender {
    [self noteOtaUpdate:nil];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return bt_EntityList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IDCell = @"BTCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDCell];
    }
    cell.imageView.image = [UIImage imageNamed:@"ic_bluetooth"];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:18.0];
    
    QCY_Entity *entity = bt_EntityList[indexPath.row];
    CBPeripheral *item = entity.mPeripheral;
    cell.textLabel.text= entity.mName;
    
    if (item.state == CBPeripheralStateConnected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_bt_status_phone) {
        [DFUITools showText:@"蓝牙没有打开" onView:self.view delay:1.0];
        return;
    }
    if (bt_EntityList.count == 0) return;
    QCY_Entity *entity = bt_EntityList[indexPath.row];
    CBPeripheral *item = entity.mPeripheral;
    
    if (item.state == CBPeripheralStateDisconnected) {
        [bt_ble disconnectBLE];
        
        NSLog(@"蓝牙正在连接... ==> %@",entity.mName);
        [self startLoadingView:@"连接中..." Delay:5.0];
        [bt_ble connectBLE:item];
    }else{
        NSString *txt = [NSString stringWithFormat:@"你是否要断开设备【%@】？",item.name];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:txt
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"断开" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action)
        {
            [self->bt_ble disconnectBLE];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


-(void)allNoteListen:(NSNotification*)note{
    NSString *name = note.name;
        
    if ([name isEqual:kQCY_BLE_FOUND])
    {
        NSMutableArray *mArr = [NSMutableArray new];
        NSMutableArray *peripherals = [note object];
        
        for (NSDictionary *dic in peripherals)
        {
            CBPeripheral *item = dic[@"BLE"];
            NSNumber     *rssi = dic[@"RSSI"];
            NSString     *name = dic[@"NAME"];
            
            if ([rssi intValue] <= 0) {
                QCY_Entity *entity = [QCY_Entity new];
                entity.mRSSI       = rssi;
                entity.mPeripheral = item;
                entity.mName       = name;
                [mArr addObject:entity];
            }
        }
        
        /*--- 按信号强度排序 ---*/
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"mRSSI"
                                                             ascending:NO];
        [mArr sortUsingDescriptors:@[sd]];
        bt_EntityList = [mArr copy];
        
        [_subTableview reloadData];
    }
    
    if ([name isEqual:kQCY_BLE_CONNECTED]) {
        _bt_status_phone   = YES;
        _bt_status_connect = YES;
        [_subTableview reloadData];
    }
    
    if ([name isEqual:kQCY_BLE_PAIRED])
    {
        [self startLoadingView:@"连接成功." Delay:1.0];
        
        CBPeripheral *pl = [note object];

        _bt_status_phone   = YES;
        _bt_status_connect = YES;

        NSLog(@"BLE Paired ---> %@ UUID:%@",pl.name,pl.identifier.UUIDString);
        [_subTableview reloadData];
        [self endLoadingView];
        
        [JL_Tools delay:0.5 Task:^{
            [self info_btn:nil];
        }];
    }
    
    if ([name isEqual:kQCY_BLE_DISCONNECTED]){


        _bt_status_connect = NO;
        [_subTableview reloadData];
    }
    
    if ([name isEqual:kQCY_BLE_OFF]) {
        _bt_status_phone   = NO;
        _bt_status_connect = NO;
    }
    
    if ([name isEqual:kQCY_BLE_ON]) {
        _bt_status_phone = YES;
    }
}


-(void)addNote{
    [DFNotice add:nil Action:@selector(allNoteListen:) Own:self];
}

-(void)startLoadingView:(NSString*)text Delay:(NSTimeInterval)delay{
    [loadingTip hide:YES ];
    UIWindow *win = [DFUITools getWindow];
    loadingTip = [DFUITools showHUDWithLabel:text onView:win
                                       color:[UIColor blackColor]
                              labelTextColor:[UIColor whiteColor]
                      activityIndicatorColor:[UIColor whiteColor]];
    [loadingTip hide:YES afterDelay:delay];
}

-(void)endLoadingView{
    [loadingTip hide:YES];
}



-(void)noteOtaUpdate:(NSNotification*)note{
    NSString *filePath = @"OTA升级文件路径";//[[NSBundle mainBundle] pathForResource:@"696HID1" ofType:@"ufw"];
    NSData *otaData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    [self->mCmdManager cmdOTAData:otaData Result:^(JL_OTAResult result, float progress)
    {
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
            NSLog(@"---> OTA正在回连设备... %@",self->bt_ble.mBlePeripheral.name);
            [self->bt_ble connectPeripheralWithUUID:self->bt_ble.lastUUID];
        }
        
        if (result == JL_OTAResultSuccess) {
            NSLog(@"--->升级成功.");
        }
        if (result == JL_OTAResultReboot) {
            NSLog(@"--->设备重启.");
        }
    }];
}

@end

