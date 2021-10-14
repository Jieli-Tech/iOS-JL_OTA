//
//  JLDeviceViewController.m
//  JL_OTA_InnerBle
//
//  Created by 凌煊峰 on 2021/10/12.
//

#import "JLDeviceViewController.h"
#import "JL_RunSDK.h"
#import "MJRefresh.h"
#import "JLDeviceCell.h"

@interface JLDeviceViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *switchLabel;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;

@property (strong, nonatomic) NSMutableArray<JL_EntityM *> *btEnityList;

@property (strong, nonatomic) JL_Timer *connectTimer;

@end

@implementation JLDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _subTableView.tableFooterView = [UIView new];
    _subTableView.dataSource= self;
    _subTableView.delegate  = self;
    _subTableView.rowHeight = 50.0;
    [_subTableView registerNib:[UINib nibWithNibName:NSStringFromClass(JLDeviceCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(JLDeviceCell.class)];
    
    self.connectTimer = [[JL_Timer alloc] init];
    self.btEnityList = [JL_RunSDK sharedInstance].mBleMultiple.blePeripheralArr;
    
    __weak typeof(self) weakSelf = self;
    [JL_RunSDK sharedInstance].mBleMultiple.BLE_FILTER_ENABLE = YES;        // 设置过滤不吻合的ble外设
    [_subTableView addHeaderWithCallback:^{
        NSLog(@"--->开始刷新...");
        [weakSelf startScanDevice];
    }];
    
    [JL_Tools add:kJL_BLE_M_ENTITY_CONNECTED Action:@selector(noteEntityConnected:) Own:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([JL_RunSDK sharedInstance].mBleMultiple.bleManagerState == CBManagerStatePoweredOn) {
        [self startScanDevice];
    }
}

/**
 *  是否过滤不吻合的ble外设
 */
- (IBAction)tapSwitchFunc:(UISwitch *)sender {
    NSString *txt = @"";
    if (sender.isOn) {
        txt = @"APP会过滤部分不吻合的BLE外设。";
        [JL_RunSDK sharedInstance].mBleMultiple.BLE_FILTER_ENABLE = YES;
    } else {
        txt = @"APP会扫描所有BLE外设。";
        [JL_RunSDK sharedInstance].mBleMultiple.BLE_FILTER_ENABLE = NO;
    }
    [_subTableView setHeaderReleaseToRefreshText:txt];
    [DFUITools showText:txt onView:self.view delay:1.0];

    [[JL_RunSDK sharedInstance].mBleMultiple scanStart];
}

/**
 *  刷新蓝牙设备
 */
- (void)startScanDevice {
    if ([JL_RunSDK sharedInstance].mBleMultiple.bleManagerState != CBManagerStatePoweredOn) {
        [DFUITools showText:@"蓝牙没有打开" onView:self.view delay:1.0];
        [self.subTableView headerEndRefreshing];
        return;
    }
    /*--- 搜索蓝牙设备 ---*/
    [[JL_RunSDK sharedInstance].mBleMultiple scanStart];
    __weak typeof(self) weakSelf = self;
    [JL_Tools delay:2.0 Task:^{
        NSLog(@"--->已刷完.");
        [[JL_RunSDK sharedInstance].mBleMultiple scanStop];
        [weakSelf.subTableView headerEndRefreshing];
        [weakSelf reloadTableView];
    }];
}

- (void)reloadTableView {
    self.btEnityList = [JL_RunSDK sharedInstance].mBleMultiple.blePeripheralArr;
    if ([JL_RunSDK sharedInstance].mBleEntityM && ![self.btEnityList containsObject:[JL_RunSDK sharedInstance].mBleEntityM]) {
        [self.btEnityList insertObject:[JL_RunSDK sharedInstance].mBleEntityM atIndex:0];
    }
    [self.subTableView reloadData];
}

- (void)connectToDevice:(JL_EntityM *)bleEntity withFilter:(BOOL)isFilter {
    [JL_RunSDK sharedInstance].mBleMultiple.BLE_FILTER_ENABLE = isFilter;
    [JL_Tools subTask:^{
        [[JL_RunSDK sharedInstance].mBleMultiple connectEntity:bleEntity Result:^(JL_EntityM_Status status) {
        }];
    }];
}


#pragma mark - 设备被连接
- (void)noteEntityConnected:(NSNotification*)note {
    CBPeripheral *pl = [note object];
    NSString *uuid = pl.identifier.UUIDString;
    
    /*--- 已连接的设备预处理 ---*/
    JL_EntityM *entity = [[JL_RunSDK sharedInstance] getEntity:uuid];
    
    NSLog(@"--->连接成功.");
    [JL_RunSDK sharedInstance].mBleEntityM = entity;
    [JL_Tools delay:0.5 Task:^{
        // 连接成功后需要获取设备信息
        [[JL_RunSDK sharedInstance] getDeviceInfo:^(BOOL needForcedUpgrade) {
            if (needForcedUpgrade) {
                NSLog(@"设备需要强制升级，请到升级界面选择ota升级文件进行升级！");
                [self startLoadingView:@"设备需要强制升级，请到升级界面选择ota升级文件进行升级！" Delay:1.0];
            }
        }];
    }];
    [self startLoadingView:[JL_RunSDK textEntityStatus:JL_EntityM_StatusPaired] Delay:1.0];
    [self reloadTableView];
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

    JL_EntityM *entity = _btEnityList[indexPath.row];
    CBPeripheral *item = entity.mPeripheral;
    cell.name.text = item.name;
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
    if ([JL_RunSDK sharedInstance].mBleMultiple.bleManagerState != CBManagerStatePoweredOn) {
        [DFUITools showText:@"蓝牙没有打开" onView:self.view delay:1.0];
        return;
    }
    if (_btEnityList.count == 0) return;
    JL_EntityM *selectedItem = _btEnityList[indexPath.row];
    CBPeripheral *item = selectedItem.mPeripheral;
    __weak typeof(self) weakSelf = self;
    if (item.state == CBPeripheralStateConnected || item.state == CBPeripheralStateConnecting) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"你是否要断开设备【%@】？", item.name] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"断开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[JL_RunSDK sharedInstance].mBleMultiple disconnectEntity:[JL_RunSDK sharedInstance].mBleEntityM Result:^(JL_EntityM_Status status) {
                if (JL_EntityM_StatusDisconnectOk == status) {
                    NSLog(@"断开设备成功");
                    [weakSelf startLoadingView:@"断开设备成功" Delay:1.0];
                    [JL_RunSDK sharedInstance].mBleEntityM = nil;
                }
                [weakSelf reloadTableView];
            }];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"APP是否通过认证方式连接BLE设备？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"认证连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"蓝牙正在连接... ==> %@",item.name);
        [weakSelf startLoadingView:@"连接中..." Delay:5.0];
        [weakSelf connectToDevice:selectedItem withFilter:YES];
    }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"直接连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [JL_RunSDK sharedInstance].mBleMultiple.BLE_FILTER_ENABLE = NO;
//        NSLog(@"蓝牙正在连接... ==> %@",item.name);
//        [weakSelf startLoadingView:@"连接中..." Delay:5.0];
//        [weakSelf connectToDevice:selectedItem withFilter:NO];
//    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
