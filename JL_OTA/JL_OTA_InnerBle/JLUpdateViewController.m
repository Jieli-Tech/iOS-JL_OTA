//
//  JLUpdateViewController.m
//  JL_OTA_InnerBle
//
//  Created by 凌煊峰 on 2021/10/12.
//

#import "JLUpdateViewController.h"
#import "JLDeviceCell.h"
#import "JL_RunSDK.h"
#import "UITableViewCell+JLCustom.h"
#import "GCDWebKit.h"


@interface JLUpdateViewController () <JL_RunSDKOtaDelegate, UITableViewDataSource, UITableViewDelegate>

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
@property (weak, nonatomic) IBOutlet UILabel *wifiText;

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
    
    //增加浏览器传文件功能
    [GCDWebKit startWithResult:^(GCDWebKitStatus status,
                                 NSString *__nullable ipAdress,
                                 NSInteger port) {
        if (status == GCDWebKitStatusStart) {
            self.wifiText.text = [NSString stringWithFormat:@"提示：电脑与手机处于相同WiFi，浏览器登录http://%@:%zd/  即可导入OTA升级文件。",ipAdress,port];
            [self reflashFileArray];
            [self.fileTableView reloadData];
        }
        if (status == GCDWebKitStatusFail) {
            self.wifiText.text = kJL_TXT("提示：电脑与手机处于相同WiFi，可从电脑浏览器添加升级文件。");
        }
        
        if (status == GCDWebKitStatusUpload) {
            [self reflashFileArray];
            [self.fileTableView reloadData];
        }
        if (status == GCDWebKitStatusMove) {
            [self.fileTableView reloadData];
        }
        if (status == GCDWebKitStatusDelete) {
            [self reflashFileArray];
            [self.fileTableView reloadData];
        }
        if (status == GCDWebKitStatusCreate) {
            [self.fileTableView reloadData];
        }
        if (status == GCDWebKitStatusWifiDisable) {
            self.wifiText.text = kJL_TXT("提示：电脑与手机处于相同WiFi，可从电脑浏览器添加升级文件。");
        }
    }];
    
    // 设置ota升级过程状态回调代理
    [JL_RunSDK sharedInstance].otaDelegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reflashFileArray];
    [self.fileTableView reloadData];
    
    [self checkDeviceConnected];
}

- (void)reflashFileArray {
    // 获取沙盒升级文件
    NSString *docPath = [DFFile listPath:NSDocumentDirectory MiddlePath:@"upgrade" File:nil];
    _fileArray = [DFFile subPaths:docPath];
}

/**
 *  选择文件后，点击启动OTA升级
 */
- (IBAction)updateBtnFunc:(id)sender {
    if (![JL_RunSDK sharedInstance].mBleEntityM) {
        self.updateSeekLabel.text = @"";
        [DFUITools showText:kJL_TXT("请先连接设备") onView:self.view delay:1.0];
        return;
    }
    
    /*--- 获取设备信息 ---*/
    [[JL_RunSDK sharedInstance] otaFuncWithFilePath:_selectFilePath];
}

#pragma mark - Private Method

- (void)checkDeviceConnected {
    if ([JL_RunSDK sharedInstance].mBleEntityM) {
        _linkStatusLabel.text = kJL_TXT("设备已连接");
    } else {
        _linkStatusLabel.text = kJL_TXT("设备未连接");
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

#pragma mark - JL_RunSDKOtaDelegate

/**
 *  ota升级过程状态回调
 */
- (void)otaProgressWithOtaResult:(JL_OTAResult)result withProgress:(float)progress {
    if (result == JL_OTAResultUpgrading || result == JL_OTAResultPreparing) {
        [self isUpgradingUI:YES];
        NSString *txt = [NSString stringWithFormat:@"%.1f%%",progress*100.0f];
        self.updateSeekLabel.text = txt;
        self.updateProgressView.progress = progress;
        
        if (result == JL_OTAResultPreparing) self.updateLabel.text = kJL_TXT("校验文件中");
        if (result == JL_OTAResultUpgrading) self.updateLabel.text = kJL_TXT("正在升级");
        
    } else if (result == JL_OTAResultPrepared) {
        NSLog(@"---> 检验文件【完成】");
        self.updateLabel.text = kJL_TXT("校验文件完成");
    } else if (result == JL_OTAResultReconnect) {
        NSLog(@"---> OTA正在回连设备... %@", [JL_RunSDK sharedInstance].mBleEntityM.mPeripheral.name);
    } else if (result == JL_OTAResultReconnectWithMacAddr) {
        NSLog(@"---> OTA正在通过Mac Addr方式回连设备... %@", [JL_RunSDK sharedInstance].mBleEntityM.mPeripheral.name);
    } else if (result == JL_OTAResultSuccess) {
        NSLog(@"--->升级成功.");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.updateSeekLabel.text = @"100%";
            self.updateProgressView.progress = 1.0;
            self.updateLabel.text = kJL_TXT("升级完成");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:kJL_TXT("升级完成") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:confirmAction];
            [self presentViewController:alertController animated:YES completion:nil];
            [DFAction delay:1.5 Task:^{
                [self isUpgradingUI:NO];
            }];
        });
    } else if (result == JL_OTAResultReboot) {
        NSLog(@"--->设备重启.");
        [self checkDeviceConnected];
        [self isUpgradingUI:NO];
    } else if (result == JL_OTAResultFail) {
        
        self.updateLabel.text = @"";
        [DFUITools showText:kJL_TXT("升级失败") onView:self.view delay:1.0];
        [self isUpgradingUI:NO];
        
    }else {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.fileTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.updateBtn.hidden) {
        return;
    }
    _selectIndex = indexPath.row;
    _selectFilePath = [DFFile listPath:NSDocumentDirectory MiddlePath:@"upgrade" File:_fileArray[indexPath.row]];
    [tableView reloadData];
}

@end
