//
//  JLDeviceViewController.m
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/9.
//

#import "JLDeviceViewController.h"
#import <JL_BLEKit/JL_BLEKit.h>

#import "MJRefresh.h"
#import "JLDeviceCell.h"
#import "JLBleManager.h"
#import "JLBleEntity.h"

@interface JLDeviceViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *switchLabel;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
@property (strong, nonatomic) NSMutableArray<JLBleEntity *> *btEnityList;
@property (strong, nonatomic) JLBleManager *bleManager;
@property (strong, nonatomic) JLBleEntity *currentEntity;

@end

@implementation JLDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bleManager = [JLBleManager sharedInstance];
    _btEnityList = [NSMutableArray new];
    
    _subTableView.tableFooterView = [UIView new];
    _subTableView.dataSource= self;
    _subTableView.delegate  = self;
    _subTableView.rowHeight = 50.0;
    [_subTableView registerNib:[UINib nibWithNibName:NSStringFromClass(JLDeviceCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(JLDeviceCell.class)];
        
    __weak typeof(self) weakSelf = self;
    [_subTableView addHeaderWithCallback:^{
        NSLog(@"--->开始刷新...");
        [weakSelf startScanDevice];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allNoteListen:) name:nil object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startScanDevice];
}

/**
 *  是否过滤不吻合的ble外设
 */
- (IBAction)tapSwitchFunc:(UISwitch *)sender {
    NSString *txt = @"";
    if (sender.isOn) {
        txt = @"APP会过滤部分不吻合的BLE外设。";
        self.bleManager.isFilter = YES;
    } else {
        txt = @"APP会扫描所有BLE外设。";
        self.bleManager.isFilter = NO;
    }
    [_subTableView setHeaderReleaseToRefreshText:txt];
    [DFUITools showText:txt onView:self.view delay:1.0];
    
    [self startScanDevice];
}

/**
 *  刷新蓝牙设备
 */
- (void)startScanDevice {
    if ([JLBleManager sharedInstance].mBleManagerState != CBManagerStatePoweredOn) {
        [DFUITools showText:@"蓝牙没有打开" onView:self.view delay:1.0];
        [self.subTableView headerEndRefreshing];
        return;
    }
    /*--- 搜索蓝牙设备 ---*/
    [self.bleManager startScanBLE];
    [JL_Tools delay:2.0 Task:^{
        NSLog(@"--->已刷完.");
        [self.bleManager stopScanBLE];
        [self.subTableView headerEndRefreshing];
    }];
}

#pragma mark - 通知

- (void)allNoteListen:(NSNotification*)note {
    NSString *name = note.name;
        
    if ([name isEqual:kFLT_BLE_FOUND]) {
        /*--- 按信号强度排序 ---*/
        NSArray *bleArray = [note object];
        self.btEnityList = [NSMutableArray arrayWithArray:bleArray];
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"mRSSI" ascending:NO];
        [self.btEnityList sortUsingDescriptors:@[sd]];
        
        if (self.currentEntity && ![self.btEnityList containsObject:self.currentEntity]) {
            [self.btEnityList insertObject:self.currentEntity atIndex:0];
        }
        
        [_subTableView reloadData];
    }
    
    if ([name isEqual:kFLT_BLE_CONNECTED]) {
        [_subTableView reloadData];
    }
    
    if ([name isEqual:kFLT_BLE_DISCONNECTED]) {
        self.currentEntity = nil;
        [_subTableView reloadData];
    }
    
    if ([name isEqual:kFLT_BLE_PAIRED]) {
        [self startLoadingView:@"连接成功." Delay:1.0];
        
        CBPeripheral *pl = [note object];

        NSLog(@"BLE Paired ---> %@ UUID:%@",pl.name,pl.identifier.UUIDString);
        [_subTableView reloadData];
        [self hideLoadingView];
        
        [JL_Tools delay:0.5 Task:^{
            [self.bleManager getDeviceInfo:^(BOOL needForcedUpgrade) {
                if (needForcedUpgrade) {
                    NSLog(@"设备需要强制升级，请到升级界面选择ota升级文件进行升级！");
                    [self startLoadingView:@"设备需要强制升级，请到升级界面选择ota升级文件进行升级！" Delay:1.0];
                }
            }];
        }];
    }
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

    JLBleEntity *entity = _btEnityList[indexPath.row];
    CBPeripheral *item = entity.mPeripheral;
    cell.name.text = item.name;
    cell.name.textColor = [UIColor blackColor];

    if (item.state == CBPeripheralStateConnected) {
        self.currentEntity = entity;
        cell.isLinked = YES;
    } else {
        cell.isLinked = NO;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.subTableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([JLBleManager sharedInstance].mBleManagerState != CBManagerStatePoweredOn) {
        [DFUITools showText:@"蓝牙没有打开" onView:self.view delay:1.0];
        return;
    }
    if (_btEnityList.count == 0) return;
    JLBleEntity *selectedItem = _btEnityList[indexPath.row];
    CBPeripheral *item = selectedItem.mPeripheral;
    
    if (item.state == CBPeripheralStateConnected || item.state == CBPeripheralStateConnecting) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"你是否要断开设备【%@】？", item.name] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"断开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.bleManager disconnectBLE];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"APP是否通过认证方式连接BLE设备？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"认证连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.bleManager.isPaired = YES;
        NSLog(@"蓝牙正在连接... ==> %@",item.name);
        [self startLoadingView:@"连接中..." Delay:5.0];
        [self.bleManager connectBLE:item];
    }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"直接连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        self.bleManager.isPaired = NO;
//        NSLog(@"蓝牙正在连接... ==> %@",item.name);
//        [self startLoadingView:@"连接中..." Delay:5.0];
//        [self.bleManager connectBLE:item];
//    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
