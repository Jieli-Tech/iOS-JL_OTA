//
//  AutoUpdateViewController.m
//  JL_OTA
//
//  Created by EzioChan on 2022/12/9.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "AutoUpdateViewController.h"
#import "UfwFileCell.h"
#import "JLShareFileViewController.h"
#import "ToolsHelper.h"
#import "JLBleManager.h"
#import "TipsFinishView.h"
#import "TipsProgressView.h"
#import "TipsComputerView.h"
#import "LoopUpdateManager.h"
#import "PopoverView.h"
#import "JLBleHandler.h"


@interface AutoUpdateViewController ()<UITableViewDelegate,UITableViewDataSource,JLBleManagerOtaDelegate>

@property(nonatomic,strong)UILabel *connectStatusLab;
@property(nonatomic,strong)UILabel *statusLab;
@property(nonatomic,strong)UILabel *deviceTypeLab;
@property(nonatomic,strong)UILabel *deviceTypeLab1;
@property(nonatomic,strong)UIView  *centerView;
@property(nonatomic,strong)UILabel *fileSelectLab;
@property(nonatomic,strong)UIButton *fileTransportBtn;
@property(nonatomic,strong)UIImageView *noneUfwImgv;
@property(nonatomic,strong)UITableView *ufwTable;
@property(nonatomic,strong)UIButton *updateBtn;
@property(nonatomic,strong)UIView *popSuperView;
@property(nonatomic,strong)PopoverView *popView;


//MARK: - Tips Views
@property(nonatomic,strong)TipsFinishView *finishView;
@property(nonatomic,strong)TipsProgressView *progressView;
@property(nonatomic,strong)TipsComputerView *transportComputerView;
@property(nonatomic,strong)DownloadView *ufwDownloadView;

//MARK: - data
@property(nonatomic,strong)NSArray *itemArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (assign, nonatomic) NSInteger selectIndex;
@property(nonatomic,strong)NSTimer *connectTimer;
@property(nonatomic,assign)int connectTimerCount;
@property(nonatomic,assign)int maxOtaTime;
@end

@implementation AutoUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

-(void)initData{
    self.itemArray = @[];
    
    [[JLBleManager sharedInstance] addDelegate:self];
    self.selectedArray = [NSMutableArray new];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerNotifi:) name:nil object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleQrresult:) name:QR_SCAN_RESULT object:nil];
}

-(void)initUI{
    
    self.title = kJL_TXT("update");
    _connectStatusLab = [UILabel new];
    _connectStatusLab.font = FontMedium(15);
    _connectStatusLab.text = kJL_TXT("device_status");
    _connectStatusLab.textColor = [UIColor colorFromHexString:@"#242424"];
    [self.view addSubview:_connectStatusLab];
    
    [_connectStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_top).offset(10);
        }
        make.left.equalTo(self.view.mas_left).offset(24);
        make.height.offset(30);
    }];
    
    _statusLab = [UILabel new];
    _statusLab.font = FontMedium(15);
    _statusLab.text = kJL_TXT("not_connect");
    _statusLab.textColor = [UIColor colorFromHexString:@"#398BFF"];
    [self.view addSubview:_statusLab];
    
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_top).offset(10);
        }
        make.left.equalTo(_connectStatusLab.mas_right).offset(2);
        make.height.offset(30);
    }];
    
    _deviceTypeLab = [UILabel new];
    _deviceTypeLab.font = FontMedium(15);
    _deviceTypeLab.text = kJL_TXT("device_type");
    _deviceTypeLab.textColor = [UIColor colorFromHexString:@"#242424"];
    [self.view addSubview:_deviceTypeLab];
    
    [_deviceTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_connectStatusLab.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(24);
        make.height.offset(30);
    }];
    
    _deviceTypeLab1 = [UILabel new];
    _deviceTypeLab1.font = FontMedium(15);
//    _deviceTypeLab1.text = kJL_TXT("unKnow");
    _deviceTypeLab1.textColor = [UIColor colorFromHexString:@"#242424"];
    [self.view addSubview:_deviceTypeLab1];
    
    [_deviceTypeLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_connectStatusLab.mas_bottom).offset(5);
        make.left.equalTo(_deviceTypeLab.mas_right).offset(2);
        make.height.offset(30);
    }];
    
    _updateBtn = [UIButton new];
    _updateBtn.layer.cornerRadius = 24;
    _updateBtn.layer.masksToBounds = YES;
    [_updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_updateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _updateBtn.titleLabel.font = FontMedium(15);
    [_updateBtn addTarget:self action:@selector(startUpdateAction) forControlEvents:UIControlEventTouchUpInside];
    [_updateBtn setBackgroundColor:[UIColor colorFromHexString:@"#D7DADD"]];
    [self.view addSubview:_updateBtn];
    [_updateBtn setTitle:kJL_TXT("update") forState:UIControlStateNormal];
    [_updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.offset(48);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-90);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view.mas_bottom).offset(-90);
        }
    }];
    
    _centerView = [UIView new];
    _centerView.backgroundColor = [UIColor whiteColor];
    _centerView.layer.cornerRadius = 8;
    _centerView.layer.masksToBounds = YES;
    [self.view addSubview:_centerView];
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_deviceTypeLab.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.bottom.equalTo(_updateBtn.mas_top).offset(-90);
    }];
    
    
    _fileSelectLab = [UILabel new];
    _fileSelectLab.font = FontMedium(15);
    _fileSelectLab.textColor = [UIColor colorFromHexString:@"#242424"];
    _fileSelectLab.text = kJL_TXT("select_file");
    [_centerView addSubview:_fileSelectLab];
    
    [_fileSelectLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerView.mas_top).offset(16);
        make.left.equalTo(_centerView.mas_left).offset(16);
        make.height.offset(30);
    }];
    
    _fileTransportBtn = [UIButton new];
    [_fileTransportBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [_fileTransportBtn addTarget:self action:@selector(fileTransportBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_centerView addSubview:_fileTransportBtn];
    [_fileTransportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerView.mas_top).offset(16);
        make.right.equalTo(_centerView.mas_right).offset(-16);
        make.height.width.offset(30);
    }];
    
    
    _ufwTable = [UITableView new];
    _ufwTable.delegate = self;
    _ufwTable.dataSource = self;
    _ufwTable.rowHeight = 65;
    _ufwTable.tableFooterView = [UIView new];
    _ufwTable.backgroundColor = [UIColor whiteColor];
    _ufwTable.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    [_ufwTable registerNib:[UINib nibWithNibName:NSStringFromClass(UfwFileCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(UfwFileCell.class)];
    [_centerView addSubview:_ufwTable];
    [_ufwTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fileSelectLab.mas_bottom).offset(10);
        make.left.equalTo(_centerView.mas_left).offset(0);
        make.right.equalTo(_centerView.mas_right).offset(0);
        make.bottom.equalTo(_centerView.mas_bottom).offset(0);
    }];
    
    
    
    _noneUfwImgv = [UIImageView new];
    _noneUfwImgv.image = [UIImage imageNamed:@"img_01"];
    [_centerView addSubview:_noneUfwImgv];
    
    [_noneUfwImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.offset(0);
        make.width.offset(154);
        make.height.offset(106);
    }];
    
    
    _popSuperView = [UIView new];
    _popSuperView.backgroundColor = [UIColor clearColor];
    _popSuperView.hidden = YES;
    [self.view addSubview:_popSuperView];
    [_popSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    _popView = [[PopoverView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_popView];
    _popView.hidden = YES;
    [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fileTransportBtn.mas_bottom).offset(4);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.width.offset(125);
        make.height.offset(141);
    }];
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgesToDismissPopView)];
    [_popSuperView addGestureRecognizer:tapges];
    [_popView addObserver:self forKeyPath:@"selectIndex" options:NSKeyValueObservingOptionNew context:nil];
    
    _finishView = [[TipsFinishView alloc] init:JLTipsAuto];
    UIWindow *windows = [[UIApplication sharedApplication] keyWindow];
    [windows addSubview:_finishView];
    _finishView.hidden = YES;
    [_finishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(windows.mas_top).offset(0);
        make.left.equalTo(windows.mas_left).offset(0);
        make.right.equalTo(windows.mas_right).offset(0);
        make.bottom.equalTo(windows.mas_bottom).offset(0);
    }];
    
    _progressView = [TipsProgressView new];
    [windows addSubview:_progressView];
    _progressView.hidden = YES;
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(windows.mas_top).offset(0);
        make.left.equalTo(windows.mas_left).offset(0);
        make.right.equalTo(windows.mas_right).offset(0);
        make.bottom.equalTo(windows.mas_bottom).offset(0);
    }];
    
    _transportComputerView = [TipsComputerView new];
    [windows addSubview:_transportComputerView];
    _transportComputerView.hidden = YES;
    [_transportComputerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(windows.mas_top).offset(0);
        make.left.equalTo(windows.mas_left).offset(0);
        make.right.equalTo(windows.mas_right).offset(0);
        make.bottom.equalTo(windows.mas_bottom).offset(0);
    }];
    
    _ufwDownloadView = [[DownloadView alloc] initWithFrame:CGRectZero];
    [windows addSubview:_ufwDownloadView];
    [_ufwDownloadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(windows);
    }];
    _ufwDownloadView.hidden = true;
}

//MARK: - Button action

-(void)fileTransportBtnAction{
    _popSuperView.hidden = NO;
    _popView.hidden  = NO;
}

-(void)tapgesToDismissPopView{
    _popSuperView.hidden = YES;
    _popView.hidden  = YES;
}

-(void)startUpdateAction{
    
    if (![[JLBleManager sharedInstance] isConnected] ) {
        [DFUITools showText:kJL_TXT("connect_first") onView:self.view delay:1.0];
        return;
    }
    if(self.selectedArray.count > 0){
        [[LoopUpdateManager share] cleanList];
        [[LoopUpdateManager share] setFinishNumber:0];
        [[LoopUpdateManager share] setFailedNumber:0];
        [[JLBleManager sharedInstance] getDeviceInfo:^(BOOL needForcedUpgrade) {
            //开始升级
            [[LoopUpdateManager share] startLoopUpdate:self.selectedArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_progressView.hidden = NO;
            });
        }];
        
    }
}

//MARK: - handle notification
-(void)handlerNotifi:(NSNotification *)note{
    NSString *name = [note name];
    if([name isEqualToString:kJL_BLE_M_ENTITY_CONNECTED]
       || [name isEqualToString:kFLT_BLE_CONNECTED]
       || [name isEqualToString:kFLT_BLE_DISCONNECTED]
       || [name isEqualToString:kJL_BLE_M_ENTITY_DISCONNECTED]){
        [self checkDeviceConnected];
        [self cancelReconnectTimer];
    }
    if([name isEqualToString:@"REFRESH_FILE"]){
        [self reflashFileArray];
    }
    
    if([name isEqualToString:UIApplicationDidEnterBackgroundNotification]){
        __weak typeof(self) weakSelf = self;
        
        JLBleEntity * entity = [[JLBleManager sharedInstance] currentEntity];
        if(entity){
            [[JLBleManager sharedInstance] otaFuncCancel:^(uint8_t status) {
                if(status == JL_CMDStatusSuccess){
                    weakSelf.progressView.hidden = YES;
                }
            }];
        }
    }
    
}
-(void)handleQrresult:(NSNotification *)note{
    NSString *url = note.object;
    [_ufwDownloadView downloadAction:url];
}

//MARK: - tools
- (void)reflashFileArray {
    // 获取沙盒升级文件
    NSString *docPath = [DFFile listPath:NSDocumentDirectory MiddlePath:@"upgrade" File:nil];
    _itemArray = [DFFile subPaths:docPath];
    if(_itemArray.count>0){
        self.noneUfwImgv.hidden = YES;
    }else{
        self.noneUfwImgv.hidden = NO;
    }
    [self.ufwTable reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reflashFileArray];
    
    [self checkDeviceConnected];
}

- (BOOL)checkDeviceConnected {
    
    self.deviceTypeLab1.text = [JLBleHandler deviceType];
    if ([JLBleManager sharedInstance].isConnected) {
        self.statusLab.text = kJL_TXT("device_connected");
        if(self.selectedArray.count>0){
            [self.updateBtn setBackgroundColor:[UIColor colorFromHexString:@"#398BFF"]];
            return YES;
        }
    } else {
        [self.updateBtn setBackgroundColor:[UIColor colorFromHexString:@"#D7DADD"]];
        self.statusLab.text = kJL_TXT("not_connect");
        self.deviceTypeLab1.text = @"";
    }
    
    return NO;
}

//MARK: - Handle with OTA callback

-(void)otaProgressWithOtaResult:(JL_OTAResult)result withProgress:(float)progress{
   
    [self.progressView setWithOtaResult:result withProgress:progress];
    if(result == JL_OTAResultPreparing){
        self.finishView.hidden = YES;
        [LoopUpdateManager share].status = DeviceOtaStatusPrepare;
        [self otaTimeCheck];//增加超时检测
    }else if (result == JL_OTAResultUpgrading ) {
        self.finishView.hidden = YES;
        [self otaTimeCheck];//增加超时检测
    } else if (result == JL_OTAResultPrepared) {
        kJLLog(JLLOG_DEBUG, @"---> 检验文件【完成】");
        [self otaTimeCheck];//增加超时检测
        [LoopUpdateManager share].status = DeviceOtaStatusStepI;
    } else if (result == JL_OTAResultReconnect
               || result == JL_OTAResultReconnectUpdateSource) {
        kJLLog(JLLOG_DEBUG, @"---> OTA正在回连设备... %@", [JLBleManager sharedInstance].mBlePeripheral.name);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[LoopUpdateManager share] startLoopOta];
        });
        [self otaTimeCheck];//增加超时检测
    } else if (result == JL_OTAResultReconnectWithMacAddr) {
        
//        JLModel_Device *model = [[JLBleManager sharedInstance].mAssist.mCmdManager outputDeviceModel];
        JL_OTAManager *model = [JLBleManager sharedInstance].otaManager;
        kJLLog(JLLOG_DEBUG, @"---> OTA正在通过Mac Addr方式回连设备... %@", model.bleAddr);
        
        [JLBleManager sharedInstance].lastBleMacAddress = model.bleAddr;
        [[JLBleManager sharedInstance] startScanBLE];
        
        [LoopUpdateManager share].reConnectMac = model.bleAddr;
        [LoopUpdateManager share].status = DeviceOtaStatusStepII;
        [self otaTimeCheck];//增加超时检测
    } else if (result == JL_OTAResultSuccess) {
        kJLLog(JLLOG_DEBUG, @"--->升级成功.");
    } else if (result == JL_OTAResultReboot) {
        kJLLog(JLLOG_DEBUG, @"--->升级完成设备重启.");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.finishView succeed];
            [self otaTimeClose];//关闭超时检测
        });
        [LoopUpdateManager share].status = DeviceOtaStatusFinish;
        [LoopUpdateManager share].finishNumber+=1;
        
        [[JLBleManager sharedInstance] disconnectBLE];
        [self checkDeviceConnected];
        [self otaTimeClose];//关闭超时检测
        if([[LoopUpdateManager share] shouldLoopUpdate]){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.finishView.hidden = YES;
            });
            [DFUITools showText:kJL_TXT("wait_connect") onView:self.view delay:4];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[LoopUpdateManager share] startLoopOta];
                [self startReconnect];
            });
        }
    } else if (result == JL_OTAResultDisconnect){
        kJLLog(JLLOG_DEBUG, @"--->设备断开连接.");
        [self otaTimeClose];//关闭超时检测
    } else {
        self.progressView.hidden = YES;
        [self otaTimeClose];
        [DFUITools showText:kJL_TXT("update_failed") onView:self.view delay:1.0];
        if ([[LoopUpdateManager share] shouldLoopUpdate]){
            [self.finishView failed:result];
        }
        [LoopUpdateManager share].failedNumber+=1;
        [self faultTolerantHandle];
        // 其余错误码详细 Command+点击JL_OTAResult 查看说明
        kJLLog(JLLOG_DEBUG, @"ota update result: %@", [ToolsHelper errorReason:result]);
    }
}


/// 容错处理
-(void)faultTolerantHandle{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (![[LoopUpdateManager share] shouldLoopUpdate]){
//            [[LoopUpdateManager share] cleanList];
//            [self.finishView succeed];
            return;
        }
        
        if([ToolsHelper getFaultTolerant] && [ToolsHelper getFaultTolerantTimes]>=[[LoopUpdateManager share] failedNumber]){
            
            self.finishView.hidden = YES;
            self.progressView.hidden = false;
            [self.progressView setWithOtaResult:JL_OTAResultReconnect withProgress:0.0];
            [[JLBleManager sharedInstance] disconnectBLE];
            if([LoopUpdateManager share].status == DeviceOtaStatusPrepare || [LoopUpdateManager share].status == DeviceOtaStatusFinish){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([ToolsHelper isSupportHID]) {
                        [[LoopUpdateManager share] startLoopOta];
                    }else{
                        [[JLBleManager sharedInstance] connectPeripheralWithUUID:[JLBleManager sharedInstance].lastUUID];
                    }
                });
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [JLBleManager sharedInstance].lastBleMacAddress = [LoopUpdateManager share].reConnectMac;
                    [[JLBleManager sharedInstance] startScanBLE];
                });
            }
        }
        
    });
}

#pragma mark - OTA升级监听超时定时器（也可不监听超时）
static NSTimer  *otaTimer = nil;
static int      otaTimeout= 0;
- (void)otaTimeCheck {
    otaTimeout = 0;
    _maxOtaTime = 20;
    if([ToolsHelper isSupportHID]){
        _maxOtaTime = 60;
    }
    if (otaTimer == nil) {
        otaTimer = [JL_Tools timingStart:@selector(otaTimeAdd) target:self Time:1.0];
    }
}

#pragma mark 关闭超时检测
- (void)otaTimeClose {
    [JL_Tools timingStop:otaTimer];
    otaTimeout = 0;
    otaTimer = nil;
}

- (void)otaTimeAdd {
    otaTimeout++;
    if (otaTimeout == _maxOtaTime) {
        [self otaTimeClose];
        kJLLog(JLLOG_DEBUG, @"OTA ---> 超时了！！！");
        [DFUITools showText:kJL_TXT("update_timeout") onView:self.view delay:1.0];
        [self.progressView timeOutShow];
        [self.finishView failed:JL_OTAResultFailCmdTimeout];
        [self faultTolerantHandle];
    }
}

//MARK: - reconnect timer
-(void)startReconnect{
    self.connectTimerCount = 0;
    [self.connectTimer invalidate];
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(reconnectAdd) userInfo:nil repeats:true];
    [self.connectTimer fire];
}

-(void)reconnectAdd{
    self.connectTimerCount+=1;
    if(self.connectTimerCount > 5){
        [[LoopUpdateManager share] startLoopOta];
    }
    if (self.connectTimerCount > 10){
        [self.connectTimer invalidate];
        self.connectTimer = nil;
        [self.progressView timeOutShow];
        [self.finishView failed:JL_OTAResultFailTWSDisconnect];
        kJLLog(JLLOG_DEBUG, @"---> 重连超时");
    }
}

-(void)cancelReconnectTimer{
    [self.connectTimer invalidate];
    self.connectTimer = nil;
}


//MARK: - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UfwFileCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UfwFileCell.class)];
    NSString *item = _itemArray[indexPath.row];
    cell.mainLab.text = _itemArray[indexPath.row];
    cell.detailLab.text = @"../Document/upgrade";
    cell.numberLab.layer.cornerRadius = 9;
    cell.numberLab.layer.masksToBounds = true;
    
    
    if([self.selectedArray containsObject:item]){
        cell.isLinked = true;
        NSInteger num = [self.selectedArray indexOfObject:item];
        cell.numberLab.text = [NSString stringWithFormat:@"%d",(int)num+1];
        cell.numberLab.hidden = false;
        cell.selectedImgv.hidden = true;
    }else{
        cell.isLinked = false;
        cell.numberLab.hidden = true;
        cell.selectedImgv.hidden = false;
    }
    
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kJL_TXT("delete");
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    NSString *path = [DFFile listPath:NSDocumentDirectory MiddlePath:@"upgrade" File:self.itemArray[indexPath.row]];
    [DFFile removePath:path];
    [_selectedArray removeAllObjects];
    [self reflashFileArray];
    [self checkDeviceConnected];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if([self.selectedArray containsObject:self.itemArray[indexPath.row]]){
        [self.selectedArray removeObject:self.itemArray[indexPath.row]];
    }else{
        [self.selectedArray addObject:self.itemArray[indexPath.row]];
    }
    
    [self.ufwTable reloadData];
    [self checkDeviceConnected];
    
}

//MARK: - handle select transport index
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"selectIndex"]){
        [self tapgesToDismissPopView];
        NSInteger selectIndex = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        switch (selectIndex) {
            case 0:{
                JLShareFileViewController *vc = [[JLShareFileViewController alloc] init];
                [vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:vc animated:true];
            }break;
            case 1:{
                self.transportComputerView.hidden = NO;
            }break;
            case 2:{
                ScanQRCodeVC *scv = [[ScanQRCodeVC alloc] init];
                [scv setHidesBottomBarWhenPushed:true];
                [self.navigationController pushViewController:scv animated:true];
            }break;
            default:
                break;
        }
        
    }
}



- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(void)dealloc{
    [self.popView removeObserver:self forKeyPath:@"selectIndex" context:nil];
}


@end
