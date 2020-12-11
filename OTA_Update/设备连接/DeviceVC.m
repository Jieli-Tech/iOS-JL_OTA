//
//  DeviceVC.m
//  OTA_Update
//
//  Created by DFung on 2019/8/21.
//  Copyright © 2019 DFung. All rights reserved.
//

#import "DeviceVC.h"
#import "MJRefresh.h"
#import "ItemCell.h"

#import "MJRefreshConst.h"

@interface DeviceVC ()<UITableViewDelegate,
                       UITableViewDataSource>
{
    DFTips              *loadingTip;
    JL_BLEUsage         *JL_ug;
    NSArray             *btEnityList;
    NSMutableArray      *uiEnityList;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footBar;
@property (weak, nonatomic) IBOutlet UIView   *subTitleView;
@property (weak, nonatomic) IBOutlet UILabel  *subLabel;
@property (weak, nonatomic) IBOutlet UITableView *subTableview;
@property (assign,nonatomic) float sw;
@property (assign,nonatomic) float sh;
@property (assign,nonatomic) float sGap_h;
@property (assign,nonatomic) float sGap_t;
@end

@implementation DeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNote];
    JL_ug = [JL_BLEUsage sharedMe];
    uiEnityList = [NSMutableArray new];
    
    [self setupUI];

    if (JL_ug.bt_status_connect) {
        [self noteBLEStatusAndDevices:nil];
    }else{
        [self refrash_btn:nil];
    }

}



-(void)viewDidAppear:(BOOL)animated{
    if (!JL_ug.bt_status_phone) {
        [DFUITools showText:kJL_TXT("蓝牙没有打开") onView:self.view delay:1.0];
        return;
    }
    /*--- 搜索蓝牙设备 ---*/
    [JL_Manager bleStartScan];
}

-(void)setupUI{
    
    self.headBar.constant = kJL_BarHead;
    self.footBar.constant = kJL_BarFoot+20;
    
    _subLabel.text = kJL_TXT("设备连接");
    _subLabel.textColor = [UIColor blackColor];

    _subTableview.tableFooterView = [UIView new];
    _subTableview.dataSource= self;
    _subTableview.delegate  = self;
    _subTableview.rowHeight = 50.0;
        
    __weak typeof(self) wSelf = self;
    [_subTableview addHeaderWithCallback:^{
        NSLog(@"--->开始刷新...");
        [wSelf refrash_btn:nil];
    }];
    
    BOOL ispair = JL_ug.bt_ble.BLE_PAIR_ENABLE;
    if (ispair) {
        [_subTableview setHeaderReleaseToRefreshText:@"APP会过滤部分不吻合的BLE外设。"];
    }else{
        [_subTableview setHeaderReleaseToRefreshText:@"APP会扫描所有BLE外设。"];
    }
    [_subTableview setHeaderPullToRefreshText:@"松手扫描设备"];
}

- (IBAction)tapSwitch:(UISwitch *)sender {
    NSString *txt = @"";
    JL_BLEUsage *usage = [JL_BLEUsage sharedMe];
    if (sender.isOn) {
        txt = @"APP会过滤部分不吻合的BLE外设。";
        usage.bt_ble.BLE_FILTER_ENABLE = YES;
    }else{
        txt = @"APP会扫描所有BLE外设。";
        usage.bt_ble.BLE_FILTER_ENABLE = NO;
    }
    [_subTableview setHeaderReleaseToRefreshText:txt];
    [DFUITools showText:txt onView:self.view delay:1.0];
    
    [self refrash_btn:nil];
}


- (void)refrash_btn:(id)sender {
    
    if (!JL_ug.bt_status_phone) {
        [DFUITools showText:kJL_TXT("蓝牙没有打开") onView:self.view delay:1.0];
        return;
    }
    /*--- 搜索蓝牙设备 ---*/
    [JL_Manager bleStartScan];
    [JL_Tools delay:2.0 Task:^{
        NSLog(@"--->已刷完.");
        [JL_Manager bleStopScan];
        [self.subTableview headerEndRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return btEnityList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[ItemCell ID]];
    if (cell == nil) {
        cell = [[ItemCell alloc] init];
    }
    cell.backgroundColor = [UIColor whiteColor];

    JL_Entity *entity = btEnityList[indexPath.row];
    CBPeripheral *item = entity.mPeripheral;
    cell.name.text = item.name;
    cell.name.textColor = [UIColor blackColor];

    if (item.state == CBPeripheralStateConnected) {
        cell.isLinked = YES;
    }else{
        cell.isLinked = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!JL_ug.bt_status_phone) {
        [DFUITools showText:kJL_TXT("蓝牙没有打开") onView:self.view delay:1.0];
        return;
    }
    if (btEnityList.count == 0) return;
    JL_Entity *selectedItem = btEnityList[indexPath.row];
    CBPeripheral *item = selectedItem.mPeripheral;
    
    if (item.state == CBPeripheralStateConnected || item.state == CBPeripheralStateConnecting) {
        NSString *txt = [NSString stringWithFormat:kJL_TXT("你是否要断开设备【%@】？"),item.name];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:txt
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:kJL_TXT("取消") style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:kJL_TXT("断开") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action)
        {
            [JL_Manager bleDisconnect];
            [JL_Manager bleClean];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (JL_ug.bt_status_paired == NO ) {
        if (item.state == CBPeripheralStateConnected) {
            [JL_Manager bleDisconnect];
            [JL_Manager bleClean];
        }
        JL_BLEUsage *usage = [JL_BLEUsage sharedMe];
        NSString *txt = @"APP是否通过认证方式连接BLE设备？";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:txt
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"认证连接" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action)
        {
            usage.bt_ble.BLE_PAIR_ENABLE = YES;
            NSLog(@"蓝牙正在连接... ==> %@",item.name);
            [self startLoadingView:kJL_TXT("连接中...") Delay:5.0];
            [JL_Manager bleConnectToDevice:item];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"直接连接" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
            
            usage.bt_ble.BLE_PAIR_ENABLE = NO;
            NSLog(@"蓝牙正在连接... ==> %@",item.name);
            [self startLoadingView:kJL_TXT("连接中...") Delay:5.0];
            [JL_Manager bleConnectToDevice:item];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive
                                                          handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }else{
        
    }
}


-(void)noteBLEStatusAndDevices:(NSNotification*)note{
    NSDictionary *dic = [note object];
    NSArray * btArray = dic[@"DEVICE"];
    JL_BLEStatus st = [dic[@"STATUS"] intValue];
    
    if (st == JL_BLEStatusFound) {
        btEnityList = btArray;
        
        /*--- 暂存已连接的BLE ---*/
        if (JL_ug.bt_status_connect) {
            if (JL_ug.bt_Entity) {
                JL_Entity *firstBle = [JL_Entity new];
                firstBle.mPeripheral     = JL_ug.bt_Entity.mPeripheral;
                firstBle.mItem           = JL_ug.bt_Entity.mPeripheral.name;
                firstBle.isSelectedStatus= YES;
                firstBle.mIndex          = 0;

                int flag = 0;
                for (JL_Entity *item in btEnityList) {
                    if (item.mPeripheral.identifier == firstBle.mPeripheral.identifier ) {
                        flag = 1;
                        break;
                    }
                }
                NSMutableArray *mutableBtEnityList = [btEnityList mutableCopy];
                if (flag == 0){
                    [mutableBtEnityList insertObject:firstBle atIndex:0];
                    btEnityList = [mutableBtEnityList copy];
                }
            }
        }
        [_subTableview reloadData];
        [self endLoadingView];
    }
    
    if (st == JL_BLEStatusPaired) {
        /*--- 提示已连接的设备 ---*/
        [JL_Manager bleStopScan];
        
        [self endLoadingView];
        [_subTableview reloadData];
        [DFUITools showText:@"连接成功" onView:self.view delay:1.0];
        [DFAction delay:1.1 Task:^{
            [JL_Tools post:@"UI_CHANEG_VC" Object:@(0)];
        }];
    }
    
    if (st == JL_BLEStatusDisconnected) {
        [_subTableview reloadData];
    }
    
    if (st == JL_BLEStatusOff) {
        [_subTableview reloadData];
    }
}




-(void)addNote{
    [JL_Tools add:kUI_JL_BLE_STATUS_DEVICE
           Action:@selector(noteBLEStatusAndDevices:)
              Own:self];
    [JL_Tools add:@"OTA_BLE_ALLOW_NO" Action:@selector(noteOtaBleAllowNO:) Own:self];
}

-(void)startLoadingView:(NSString*)text Delay:(NSTimeInterval)delay{
    [loadingTip hide:YES ];
    loadingTip = [DFUITools showHUDWithLabel:text onView:self.view
                                       color:[UIColor blackColor]
                              labelTextColor:[UIColor whiteColor]
                      activityIndicatorColor:[UIColor whiteColor]];
    [loadingTip hide:YES afterDelay:delay];
}

-(void)endLoadingView{
    [loadingTip hide:YES];
}


-(void)noteOtaBleAllowNO:(NSNotification*)note{
    [self showTips:@"The device refused to connect.Please first open Alexa to connect the device."];
}

-(void)showTips:(NSString*)text{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:text
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
