//
//  BroadcastViewController.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/25.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "BroadcastViewController.h"
#import "JLDeviceCell.h"
#import "BroadcastBleManager.h"
#import "FittingView.h"
#import "PopoverView.h"
#import "AppDelegate.h"
#import "JLMainViewController.h"
#import "NSString+Size.h"
#import "ToolsHelper.h"

@interface BroadcastViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UIView *nameFitterView;
@property (strong, nonatomic) UILabel *nameFitterLab1;
@property (strong, nonatomic) UISwitch *fitterSwitch;
@property (strong, nonatomic) UILabel *deviceListLab;
@property (strong, nonatomic) UIActivityIndicatorView *deviceListActive;
@property (strong, nonatomic) UITableView *subTableView;
@property (strong, nonatomic) FittingView *fitView;
@property (strong, nonatomic) PopoverView *popView;
@property (strong, nonatomic) UIView *popViewBg;
@property (strong, nonatomic) NSMutableArray *btEnityList;
@property (strong, nonatomic)MJRefreshNormalHeader *header;

@property (nonatomic,strong) UIButton *testBtn;
@property (assign, nonatomic) BOOL showAnimation;

@end

@implementation BroadcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

-(void)initData{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allNoteListen:) name:nil object:nil];
    _btEnityList = [NSMutableArray new];
}

-(void)initUI{
    
    self.title = kJL_TXT("connect");
    self.nameFitterView = [UIView new];
    self.nameFitterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.nameFitterView];
    [self.nameFitterView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_top).offset(10);
        }
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.offset(48);
    }];
    
    self.nameFitterLab1 = [UILabel new];
    [self.nameFitterView addSubview:self.nameFitterLab1];
    self.nameFitterLab1.font = FontMedium(15);
    self.nameFitterLab1.text = kJL_TXT("device_filter");
    self.nameFitterLab1.textColor = [UIColor colorFromHexString:@"#242424"];
    [self.nameFitterLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.equalTo(self.nameFitterView.mas_left).offset(20);
    }];

    
    _fitterSwitch = [UISwitch new];
    [self.nameFitterView addSubview:_fitterSwitch];
    [_fitterSwitch setOn:[ToolsHelper isBroadcastFitter]];
    [_fitterSwitch addTarget:self action:@selector(fitterSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [_fitterSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.equalTo(self.nameFitterView).inset(12);
    }];
    
    
    self.deviceListLab = [UILabel new];
    [self.view addSubview:self.deviceListLab];
    self.deviceListLab.font = FontMedium(15);
    self.deviceListLab.text = kJL_TXT("devices_list");
    self.deviceListLab.textAlignment = NSTextAlignmentCenter;
    self.deviceListLab.textColor = [UIColor colorFromHexString:@"#838383"];
    [self.deviceListLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameFitterView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.height.offset(35);
    }];
    
    _deviceListActive = [UIActivityIndicatorView new];
    [self.view addSubview:_deviceListActive];
    _deviceListActive.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_deviceListActive startAnimating];
    [_deviceListActive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameFitterView.mas_bottom).offset(10);
        make.left.equalTo(self.deviceListLab.mas_right).offset(6);
        make.height.width.offset(35);
    }];
    
    _subTableView = [UITableView new];
    _subTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_subTableView];
    _subTableView.tableFooterView = [UIView new];
    _subTableView.dataSource= self;
    _subTableView.delegate  = self;
    _subTableView.rowHeight = 64.0;
    _subTableView.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    [_subTableView registerNib:[UINib nibWithNibName:NSStringFromClass(JLDeviceCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(JLDeviceCell.class)];
    [_subTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_deviceListLab.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        
    }];
    
    __weak typeof(self) weakSelf = self;
    _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"--->开始刷新...");
        [weakSelf startScanDevice];
    }];
    _subTableView.mj_header = _header;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.subTableView.mj_header beginRefreshing];
    });
    
    
     self.showAnimation = NO;
     
     _fitView = [[FittingView alloc] initWithFrame:CGRectZero];
     UIWindow *windows = [[UIApplication sharedApplication] keyWindow];
     [windows addSubview:_fitView];
     [_fitView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(windows.mas_top).offset(0);
         make.bottom.equalTo(windows.mas_bottom).offset(0);
         make.left.equalTo(windows.mas_left).offset(0);
         make.right.equalTo(windows.mas_right).offset(0);
     }];
     [_fitView setHidden:YES];
     
     [self.fitView addObserver:self forKeyPath:@"fitterKey" options:NSKeyValueObservingOptionNew context:nil];
     [self addRightBtn];
     [self addToWindows];
}

-(void)addToWindows{
    UIWindow *window = [[UIApplication sharedApplication] windows].firstObject;
    self.popViewBg = [UIView new];
    self.popViewBg.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismissPop)];
    [self.popViewBg addGestureRecognizer:tap];
    [window addSubview:self.popViewBg];
    
    [self.popViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    self.popView = [[PopoverView alloc] init];
    self.popView.type = PopoverTypeBrowseCast;
    self.popView.itemList = @[kJL_TXT("broadcast_speaker"),kJL_TXT("normal_model")];
    [self.popView addObserver:self forKeyPath:@"selectIndex" options:NSKeyValueObservingOptionNew context:nil];
    [window addSubview:self.popView];
    CGFloat fw = [kJL_TXT("broadcast_speaker") textWidthFont:FontMedium(14) maxHeight:22];
    self.popView.popBgImg = [UIImage imageNamed:@"popout_bg_02"];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(window.mas_safeAreaLayoutGuideTop).offset(38);
        make.right.equalTo(window.mas_right).offset(-12);
        make.width.offset(fw+8+20+8+10);
        make.height.offset(96);
    }];
    [self tapToDismissPop];
}

-(void)tapToDismissPop{
    self.popViewBg.hidden = true;
    self.popView.hidden = true;
}

-(void)addRightBtn{
    UIImage *image = [[UIImage imageNamed:@"icon_switch"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)rightBtnAction{
    self.popViewBg.hidden = false;
    self.popView.hidden = false;
    [self.popView.listTable reloadData];
}

- (void)setShowAnimation:(BOOL)showAnimation{
    _showAnimation = showAnimation;
    if (_showAnimation) {
        _deviceListActive.hidden = NO;
        [_deviceListActive startAnimating];
    }else{
        _deviceListActive.hidden = YES;
        [_deviceListActive stopAnimating];
    }
}


-(void)addFitterAction{
    [_fitView setHidden:NO];
}


-(void)testBtnAction{
    JLDeviceInfo *first = [DeviceManager share].devices.firstObject;
    BroadcastOtaInfo *info = [[BroadcastOtaInfo alloc] init];
    info.cbp = first.entity.mPeripheral;
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    info.updatePath = [path stringByAppendingPathComponent:@"/upgrade/update-4.ufw"];
    [[BroadcastThread share] startOta:@[info]];
}

/**
 *  刷新蓝牙设备
 */
- (void)startScanDevice {
    if ([[BroadcastBleManager sharedInstance] mBleManagerState] != CBManagerStatePoweredOn) {
        [self.subTableView.mj_header endRefreshing];
        return;
    }
    /*--- 搜索蓝牙设备 ---*/
    [[BroadcastBleManager sharedInstance] startScanBLE];
    [JL_Tools delay:2.0 Task:^{
        NSLog(@"--->已刷完.");
        [[BroadcastBleManager sharedInstance] stopScanBLE];
        [self.subTableView.mj_header endRefreshing];
    }];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    if([keyPath isEqualToString:@"selectIndex"]){
        [self tapToDismissPop];
        NSInteger selectIndex = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        switch (selectIndex) {
            case 0:{
                [self tapToDismissPop];
            }break;
            case 1:{
                AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                delegate.window.rootViewController = [JLMainViewController prepareViewControllers];
                [delegate.window makeKeyAndVisible];
            }break;
            default:
                break;
        }
        
    }
}

-(void)fitterSwitchChange:(UISwitch *)sender{
    [ToolsHelper setBroadcastFitter:sender.on];
    [self startScanDevice];
}

-(void)allNoteListen:(NSNotification *)note{

    NSString *name = note.name;
    
    if ([name isEqual:kBDM_BLE_FOUND]) {
        /*--- 按信号强度排序 ---*/
        NSArray *bleArray = [note object];
        self.btEnityList = [NSMutableArray arrayWithArray:bleArray];
        for (JLDeviceInfo *info in [DeviceManager share].devices) {
            [self.btEnityList addObject:info.entity];
        }
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"mRSSI" ascending:NO];
        [self.btEnityList sortUsingDescriptors:@[sd]];
        
        [_subTableView reloadData];
    }
    
    if ([name isEqual:kBDM_BLE_CONNECTED]) {
        [_subTableView reloadData];
    }
    
    if ([name isEqual:kBDM_BLE_DISCONNECTED]) {
        [_subTableView reloadData];
    }
    
    if ([name isEqual:kBDM_BLE_PAIRED]) {
        [self startLoadingView:kJL_TXT("connect_ok") Delay:1.0];
        CBPeripheral *pl = [note object];
        NSLog(@"FTL BLE Paired ---> %@ UUID:%@",pl.name,pl.identifier.UUIDString);
        [_subTableView reloadData];
        [self hideLoadingView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startScanDevice];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _btEnityList.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    JLDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JLDeviceCell class])];
    if (cell == nil) {
        cell = [[JLDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(JLDeviceCell.class)];
    }
    cell.backgroundColor = [UIColor whiteColor];
    CBPeripheral *item;
    
    JLBleEntity *entity = _btEnityList[indexPath.row];
    cell.secondLab.text = [NSString stringWithFormat:@"rssi:%d EDR:%@",[entity.mRSSI intValue],entity.edrMacAddress];
    cell.secondLab.adjustsFontSizeToFitWidth = true;
    item = entity.mPeripheral;

    cell.name.text = entity.mName;
    cell.name.textColor = [UIColor blackColor];
    if (item.state == CBPeripheralStateConnected) {
        cell.isLinked = YES;
    } else {
        cell.isLinked = NO;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.subTableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[BroadcastBleManager sharedInstance] mBleManagerState] != CBManagerStatePoweredOn) {
        [DFUITools showText:kJL_TXT("ble_not_open") onView:self.view delay:1.0];
        return;
    }
    if (_btEnityList.count == 0) return;
//    __weak typeof(self) weakSelf = self;
    
    JLBleEntity *selectedItem = _btEnityList[indexPath.row];
    CBPeripheral *item = selectedItem.mPeripheral;
    
    if (item.state == CBPeripheralStateConnected || item.state == CBPeripheralStateConnecting) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@【%@】？",kJL_TXT("weather_disconnect_device"),item.name] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:kJL_TXT("cancel") style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:kJL_TXT("confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[BroadcastBleManager sharedInstance
             ] disconnectBLE:item];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    NSLog(@"蓝牙正在连接... ==> %@",item.name);
    [self startLoadingView:kJL_TXT("connecting") Delay:5.0];
    [[BroadcastBleManager sharedInstance] connectBLE:item];
    
}



@end
