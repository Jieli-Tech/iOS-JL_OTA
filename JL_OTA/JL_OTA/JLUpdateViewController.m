//
//  JLUpdateViewController.m
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/9.
//

#import "JLUpdateViewController.h"
#import "JLDeviceCell.h"
#import "JLBleManager.h"
#import "UITableViewCell+JLCustom.h"

@interface JLUpdateViewController () <JLBleManagerOtaDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *fileView;
@property (weak, nonatomic) IBOutlet UILabel *fileLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkStatusLabel;

@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *updateProgressView;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateSeekLabel;
@property (weak, nonatomic) IBOutlet UITableView *fileTableView;

@property (strong, nonatomic) NSString *selectFilePath;
@property (assign, nonatomic) NSInteger selectIndex;
@property (strong, nonatomic) NSArray *fileArray;

@end

@implementation JLUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectIndex = -1;
    _fileView.layer.cornerRadius = 10.0;
    _updateBtn.layer.cornerRadius= 22.5;
    _fileTableView.tableFooterView = [UIView new];
    _fileTableView.dataSource = self;
    _fileTableView.delegate   = self;
    _fileTableView.rowHeight  = 50.0;
    
    // 获取沙盒升级文件
    NSString *docPath = [DFFile listPath:NSDocumentDirectory MiddlePath:@"upgrade" File:nil];
    _fileArray = [DFFile subPaths:docPath];
    
    // 设置ota升级过程状态回调代理
    [JLBleManager sharedInstance].otaDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noteAppForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkDeviceConnected];
}

/**
 *  选择文件后，点击启动OTA升级
 */
- (IBAction)updateBtnFunc:(id)sender {
    if (![JLBleManager sharedInstance].mBlePeripheral) {
        self.updateSeekLabel.text = @"";
        [DFUITools showText:@"请先连接设备" onView:self.view delay:1.0];
        return;
    }
    
    /*--- 获取设备信息 ---*/
    [[JLBleManager sharedInstance] otaFuncWithFilePath:_selectFilePath];
}

#pragma mark - Private Method

- (void)checkDeviceConnected {
    if ([JLBleManager sharedInstance].mBlePeripheral) {
        _linkStatusLabel.text = @"设备已连接";
    } else {
        _linkStatusLabel.text = @"设备未连接";
    }
}

- (void)isUpgradingUI:(BOOL)is {
    if (is) {
        // 升级时候的样式
        _updateBtn.hidden = YES;
        _updateProgressView.hidden = NO;
        _updateSeekLabel.hidden = NO;
        _updateLabel.hidden = NO;
    } else {
        // 非升级时候的样式
        _updateBtn.hidden = NO;
        _updateProgressView.hidden = YES;
        _updateSeekLabel.hidden = YES;
        _updateLabel.hidden = YES;
    }
}

#pragma mark - JLBleManagerOtaDelegate

/**
 *  ota升级过程状态回调
 */
- (void)otaProgressWithOtaResult:(JL_OTAResult)result withProgress:(float)progress {
    if (result == JL_OTAResultUpgrading || result == JL_OTAResultPreparing) {
        [self isUpgradingUI:YES];
        NSString *txt = [NSString stringWithFormat:@"%.1f%%",progress*100.0f];
        self.updateSeekLabel.text = txt;
        self.updateProgressView.progress = progress;
        
        if (result == JL_OTAResultPreparing) self.updateLabel.text = @"校验文件中";
        if (result == JL_OTAResultUpgrading) self.updateLabel.text = @"正在升级";

        [self otaTimeCheck];//增加超时检测
    } else if (result == JL_OTAResultPrepared) {
        NSLog(@"---> 检验文件【完成】");
        self.updateLabel.text = @"校验文件完成";
        [self otaTimeCheck];//增加超时检测
    } else if (result == JL_OTAResultReconnect) {
        NSLog(@"---> OTA正在回连设备... %@", [JLBleManager sharedInstance].mBlePeripheral.name);
        [[JLBleManager sharedInstance] connectPeripheralWithUUID:[JLBleManager sharedInstance].lastUUID];
        [self otaTimeClose];//关闭超时检测
    } else if (result == JL_OTAResultReconnectWithMacAddr) {
        NSLog(@"---> OTA正在通过Mac Addr方式回连设备... %@", [JLBleManager sharedInstance].mBlePeripheral.name);
        JLModel_Device *model = [[JLBleManager sharedInstance].mAssist.mCmdManager outputDeviceModel];
        [JLBleManager sharedInstance].lastBleMacAddress = model.bleAddr;
        [[JLBleManager sharedInstance] startScanBLE];
        
        [self otaTimeClose];//关闭超时检测
    } else if (result == JL_OTAResultSuccess) {
        NSLog(@"--->升级成功.");
        self.updateSeekLabel.text = @"100%";
        self.updateProgressView.progress = 1.0;
        self.updateLabel.text = @"升级完成";
        [DFAction delay:1.5 Task:^{
            [self isUpgradingUI:NO];
        }];
        [self otaTimeClose];//关闭超时检测
    } else if (result == JL_OTAResultReboot) {
        NSLog(@"--->设备重启.");
        [self checkDeviceConnected];
        [self isUpgradingUI:NO];
        [self otaTimeClose];//关闭超时检测
    } else {
        // 其余错误码详细 Command+点击JL_OTAResult 查看说明
        NSLog(@"ota update result: %d", result);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fileArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    [cell setCustomStyle];
    
    cell.textLabel.text = _fileArray[indexPath.row];
    if (_selectIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

/**
 *  选择升级文件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.fileTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.updateBtn.hidden) {
        return;
    }
    _selectIndex = indexPath.row;
    _selectFilePath = [DFFile listPath:NSDocumentDirectory MiddlePath:@"upgrade" File:_fileArray[indexPath.row]];
    [tableView reloadData];
}
     
#pragma mark - OTA升级监听超时定时器（也可不监听超时）
static NSTimer  *otaTimer = nil;
static int      otaTimeout= 0;
- (void)otaTimeCheck {
    otaTimeout = 0;
    if (otaTimer == nil) {
        otaTimer = [JL_Tools timingStart:@selector(otaTimeAdd) target:self Time:1.0];
    }
}

- (void)otaTimeClose {
    [JL_Tools timingStop:otaTimer];
    otaTimeout = 0;
    otaTimer = nil;
}

- (void)otaTimeAdd {
    otaTimeout++;
    if (otaTimeout == 10) {
        [self otaTimeClose];
        NSLog(@"OTA ---> 超时了！！！");
        self.updateLabel.text = @"";
        [DFUITools showText:kJL_TXT("升级超时") onView:self.view delay:1.0];
        [self isUpgradingUI:NO];
    }
}

#pragma mark - 通知

- (void)noteAppForeground:(NSNotification*)note {
    NSLog(@"---> App Foreground.");
    if ([JLBleManager sharedInstance].mBlePeripheral == nil) {
        [self isUpgradingUI:NO];
        [self otaTimeClose];//关闭超时检测
    }
}

@end
