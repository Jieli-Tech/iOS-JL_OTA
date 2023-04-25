//
//  JLSettingViewController.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/11.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "JLSettingViewController.h"
#import "SettingTableViewCell.h"
#import "TestNumberView.h"
#import "ToolsHelper.h"
#import "JLBleHandler.h"
#import "JLShareLogViewController.h"
#import "AppDelegate.h"
#import "JLAutoViewsController.h"
#import "BroadcastMainViewController.h"
#import "JLMainViewController.h"

@interface JLSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *subTable;
@property(nonatomic,strong)UILabel *logLab;
@property(nonatomic,strong)UIButton *sdkVersionBtn;
@property(nonatomic,strong)TestNumberView *testNumberView;

@property(nonatomic,strong)NSMutableArray *itemsArray;
@property(nonatomic,assign)NSInteger touchTime;
@end

@implementation JLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

-(void)initData{
    self.itemsArray = [NSMutableArray new];
    NSArray *pairArray = @[kJL_TXT("device_pair")];
    [_itemsArray addObject:pairArray];
    NSArray *useSDKArray = @[kJL_TXT("use_sdk_connect")];
    [_itemsArray addObject:useSDKArray];
    NSArray *logArray = @[kJL_TXT("log_file")];
    [_itemsArray addObject:logArray];
    NSArray *appVersion = @[kJL_TXT("app_version")];
    [_itemsArray addObject:appVersion];
}

-(void)initUI{
    self.title = kJL_TXT("setting");
    self.view.backgroundColor = [UIColor colorFromHexString:@"#F4F7FB"];

    _logLab = [UILabel new];
    _logLab.font = [UIFont systemFontOfSize:13];
    _logLab.textColor = [UIColor colorFromHexString:@"#6F6F6F"];
    _logLab.text = [NSString stringWithFormat:@"%@:../Document/JL_LOG_xxxx-xx-xx-xx-xx-xx.txt",kJL_TXT("log_file_path")];
    _logLab.numberOfLines = 0;
    [self.view addSubview:_logLab];
    [_logLab mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(8);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_top).offset(8);
        }
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.offset(50);
    }];
    
    _sdkVersionBtn = [UIButton new];
    _sdkVersionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_sdkVersionBtn setTitleColor:[UIColor colorFromHexString:@"#6F6F6F"] forState:UIControlStateNormal];
    [_sdkVersionBtn setBackgroundColor:[UIColor clearColor]];
    [_sdkVersionBtn addTarget:self action:@selector(sdkVersionBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_sdkVersionBtn setTitle:[NSString stringWithFormat:@"%@：%@",kJL_TXT("sdk_version"),[JL_OTAManager logSDKVersion]] forState:UIControlStateNormal];
    [self.view addSubview:_sdkVersionBtn];
    
    [_sdkVersionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.offset(50);
    }];
    
    
    _subTable = [UITableView new];
    _subTable.delegate = self;
    _subTable.dataSource = self;
    _subTable.rowHeight = 48;
    _subTable.backgroundColor = [UIColor clearColor];
    _subTable.tableFooterView = [UIView new];
    _subTable.scrollEnabled = NO;
    if (@available(iOS 15.0, *)) {
        _subTable.sectionHeaderTopPadding = 0;
    }
    _subTable.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    
    [_subTable registerNib:[UINib nibWithNibName:NSStringFromClass([SettingTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SettingTableViewCell class])];
    [self.view addSubview:_subTable];
    
    [_subTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logLab.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(_sdkVersionBtn.mas_top).offset(-8);
    }];
    
    _testNumberView = [TestNumberView new];
    UIWindow *windows = [[UIApplication sharedApplication] keyWindow];
    [windows addSubview:_testNumberView];
    _testNumberView.hidden = YES;
    [_testNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(windows.mas_top).offset(0);
        make.left.equalTo(windows.mas_left);
        make.right.equalTo(windows.mas_right);
        make.bottom.equalTo(windows.mas_bottom);
    }];
    [_testNumberView addObserver:self forKeyPath:@"numberText" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatusAction:) name:@"CHANGE_SWITCH_CELL" object:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"numberText"]){
        [_subTable reloadData];
    }
}

//MARK: - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemsArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.itemsArray[section];
    return array.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *hview = [UIView new];
    hview.backgroundColor = [UIColor clearColor];
    return hview;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SettingTableViewCell class]) forIndexPath:indexPath];
    cell.switchBtn.hidden = YES;
    cell.endLab.hidden = YES;
    cell.endLab.textAlignment = NSTextAlignmentRight;
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSArray *array = self.itemsArray[indexPath.section];
    cell.mainLab.text = array[indexPath.row];
    switch (indexPath.section) {
        case 0:{
            cell.switchBtn.hidden = NO;
            [cell.switchBtn setOn:[ToolsHelper isSupportPair]];
            cell.saveKey = @"SupportPair";
        }break;
        case 1:{
            cell.switchBtn.hidden = NO;
            [cell.switchBtn setOn:[ToolsHelper isConnectBySDK]];
            cell.saveKey = @"ConnectBySDK";
        }break;
        case 2:{
            if(indexPath.row == 0){
                cell.saveKey = @"LogFile";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }break;
        case 3:{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }break;
        case 4:{
            cell.endLab.hidden = NO;
        }break;
        default:
            break;
    }
    if([cell.mainLab.text isEqualToString:kJL_TXT("app_version")]){
        cell.endLab.hidden = NO;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.endLab.text = [NSString stringWithFormat:@"V%@",app_Version];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section == self.itemsArray.count-2){
        JLShareLogViewController *vc = [[JLShareLogViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(indexPath.section == self.itemsArray.count-1){
        [self touchToShow];
    }
}


-(void)sdkVersionBtnAction{
    if(self.touchTime == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkOverTouchNumber:1];
        });
    }
    
    self.touchTime++;
}





-(void)touchToShow{
    if(self.touchTime == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkOverTouchNumber:0];
        });
    }
    
    self.touchTime++;
    
}
-(void)checkOverTouchNumber:(NSInteger)type{
    
    if(_touchTime > 10){
        [[JLBleHandler share] handleDisconnect];
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        if(type == 0){
            [DFUITools showText:@"Add auto test model" onView:self.view delay:2];
            [ToolsHelper setAutoTestOta:YES];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Add auto test model" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                delegate.window.rootViewController = [JLAutoViewsController prepareViewControllers];
                [delegate.window makeKeyAndVisible];
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:true completion:nil];
        }else if(type == 1){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Boradcast ota open/close" preferredStyle:UIAlertControllerStyleAlert];
            if([ToolsHelper isBroadcast]){
                [ToolsHelper setBroadcast:NO];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    delegate.window.rootViewController = [JLMainViewController prepareViewControllers];
                    [delegate.window makeKeyAndVisible];
                }];
                [alert addAction:cancel];
            }else{
                [ToolsHelper setBroadcast:YES];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    delegate.window.rootViewController = [BroadcastMainViewController prepareViewControllers];
                    [delegate.window makeKeyAndVisible];
                }];
                [alert addAction:cancel];
            }
            
            [self presentViewController:alert animated:true completion:nil];
        }
        self.touchTime = 0;
    }else{
        _touchTime = 0;
    }
    NSLog(@"end of touch check");
    
}

-(void)changeStatusAction:(NSNotification *)note{
    NSString *str = note.object;
    if([str isEqualToString:@"AutoTestOta"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Close auto test,if you want use it again,check 'app versions' cell more then 10th in 4 sec." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [ToolsHelper setAutoTestOta:NO];
            [self.itemsArray removeAllObjects];
            [self initData];
            [self.subTable reloadData];
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:true completion:nil];
    }
}


@end
