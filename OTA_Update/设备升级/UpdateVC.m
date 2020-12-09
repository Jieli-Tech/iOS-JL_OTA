//
//  UpdateVC.m
//  OTA_Update
//
//  Created by DFung on 2019/8/21.
//  Copyright © 2019 DFung. All rights reserved.
//

#import "UpdateVC.h"
#import "JL_RunSDK.h"

@interface UpdateVC ()<UITableViewDelegate,
                       UITableViewDataSource>{
    JL_BLEUsage *JL_ug;
}
@property (weak,nonatomic) IBOutlet UIView      *subTitleView;
@property (weak,nonatomic) IBOutlet UILabel     *subLabel;
@property (weak, nonatomic) IBOutlet UIView     *fileView;
@property (weak, nonatomic) IBOutlet UILabel    *fileLb;
@property (weak, nonatomic) IBOutlet UILabel    *handshakeLb;

@property (weak, nonatomic) IBOutlet UITableView*fileTableView;
@property (weak, nonatomic) IBOutlet UILabel    *linkStatusLb;
@property (weak, nonatomic) IBOutlet UILabel    *linkLb;
@property (strong,nonatomic) NSArray            *dataArray;
@property (strong,nonatomic) NSString           *selectPath;
@property (assign,nonatomic) NSInteger          selectIndex;
@property (strong,nonatomic) NSData             *otaData;
@property (assign,nonatomic) float sw;
@property (assign,nonatomic) float sh;
@property (assign,nonatomic) float sGap_h;
@property (assign,nonatomic) float sGap_t;

@property (weak, nonatomic) IBOutlet UIButton   *updateBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *updateProgress;
@property (weak, nonatomic) IBOutlet UILabel *updateSeek;
@property (weak, nonatomic) IBOutlet UILabel *updateTxt;

@end

@implementation UpdateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *docPath = [DFFile listPath:NSDocumentDirectory MiddlePath:nil File:nil];
    _dataArray = [DFFile subPaths:docPath];
    
    [JL_Tools add:kUI_JL_OTA_UPDATE Action:@selector(noteOtaUpdate:) Own:self];
    [JL_Tools add:@"OTA_BLE_ALLOW_NO" Action:@selector(noteOtaBleAllowNO:) Own:self];
    [JL_Tools add:UIApplicationWillEnterForegroundNotification
           Action:@selector(noteAppForeground:) Own:self];
    [JL_Tools add:kUI_JL_BLE_DISCONNECTED Action:@selector(noteBleDisconnect:) Own:self];
    [self setupUI];
    
}


-(void)setupUI{
    _selectIndex = -1;
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
    _subLabel.center    = CGPointMake(_sw/2.0, _sGap_h - 25.0);
    _fileView.layer.cornerRadius = 10.0;
    _updateBtn.layer.cornerRadius= 22.5;
    
    _subLabel.text     = kJL_TXT("设备升级");
    _linkStatusLb.text = kJL_TXT("设备状态：");
    _fileLb.text       = kJL_TXT("文件选择");
    [DFUITools setButton:_updateBtn Text:kJL_TXT("设备升级")];
    
    _subLabel.textColor = [UIColor blackColor];
    _linkStatusLb.textColor = [UIColor blackColor];
    
    _fileTableView.tableFooterView = [UIView new];
    _fileTableView.dataSource = self;
    _fileTableView.delegate   = self;
    _fileTableView.rowHeight  = 50.0;
}

-(void)viewDidAppear:(BOOL)animated{
    JL_ug = [JL_BLEUsage sharedMe];
    if (JL_ug.bt_status_connect) {
        NSString *txt = [NSString stringWithFormat:@"%@ %@",kJL_TXT("已连接"),JL_ug.bt_name];
        _linkLb.text = txt;
    }else{
        _linkLb.text = kJL_TXT("未连接");
    }
}

-(void)noteBleDisconnect:(NSNotification*)note{
    _linkLb.text = kJL_TXT("未连接");
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IDCell = @"BTCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:IDCell];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.tintColor = [UIColor blueColor];
    cell.backgroundColor = [UIColor whiteColor];

    
    if (_selectIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectIndex = indexPath.row;
    _selectPath = [DFFile listPath:NSDocumentDirectory MiddlePath:nil
                              File:_dataArray[indexPath.row]];
    [tableView reloadData];
}



- (IBAction)btn_update:(id)sender {
    
    JL_ug = [JL_BLEUsage sharedMe];
    if (JL_ug.bt_status_paired == NO) {
        self.updateTxt.text = @"";
        [DFUITools showText:kJL_TXT("请先连接设备") onView:self.view delay:1.0];
        return;
    }
    
    NSLog(@"---> %@",_selectPath);
    
    /*--- 获取设备信息 ---*/
    [JL_Manager cmdTargetFeatureResult:^(NSArray *array) {
        JL_CMDStatus st = [array[0] intValue];
        if (st == JL_CMDStatusSuccess) {
            
            JLDeviceModel *md = [JL_Manager outputDeviceModel];
            if (md.otaBleAllowConnect == JL_OtaBleAllowConnectNO) {
                //OTA 禁止连接后，断开连接清楚连接记录。
                [JL_Manager bleClean];
                [JL_Manager bleDisconnect];

                [JL_Tools post:@"OTA_BLE_ALLOW_NO" Object:nil];
            }else{
                [self isUpdatingUI:YES];
                self.updateSeek.text = @"";
                self.updateProgress.progress = 0;
                self.updateTxt.text = kJL_TXT("正在校验升级文件");

                [self noteOtaUpdate:nil];
            }
        }else{
            NSLog(@"---> 错误提示：%d",st);
        }
    }];
}

-(void)noteOtaUpdate:(NSNotification*)note{
    if (_selectPath.length == 0) return;
    _otaData = [NSData dataWithContentsOfFile:_selectPath];
    
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
        }else if(result == JL_OTAResultReconnect){
            [self otaTimeClose];//关闭超时检测
            
            //1、前提：若没有使用SDK内的蓝牙连接流程。
            //   则需用外部蓝牙API连接设备，再走获取设备信息，然后判断到强制升级的标志
            //   继续调用此API进行OTA升级。(此处必须重连设备，否则升级无法成功!!!)
          
            //2、前提：若使用了SDK内部的蓝牙连接流程，则此处无需做任何连接操作。
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
}

-(void)isUpdatingUI:(BOOL)is{
    if (is) {
        _updateBtn.hidden = YES;
        _updateProgress.hidden = NO;
        _updateSeek.hidden = NO;
        _updateTxt.hidden = NO;
    }else{
        _updateBtn.hidden = NO;
        _updateProgress.hidden = YES;
        _updateSeek.hidden = YES;
        _updateTxt.hidden = YES;
    }
}

#pragma mark - OTA升级失败
static NSTimer  *otaTimer = nil;
static int      otaTimeout= 0;
-(void)otaTimeCheck{
    otaTimeout = 0;
    if (otaTimer == nil) {
        otaTimer = [JL_Tools timingStart:@selector(otaTimeAdd)
                                  target:self Time:1.0];
    }
}

-(void)otaTimeClose{
    [JL_Tools timingStop:otaTimer];
    otaTimeout = 0;
    otaTimer = nil;
}

-(void)otaTimeAdd{
    otaTimeout++;
    //NSLog(@"OTA ---> otaTimeAdd！");

    if (otaTimeout == 10) {
        [self otaTimeClose];
        NSLog(@"OTA ---> 超时了！！！");
        self.updateTxt.text = @"";
        [DFUITools showText:kJL_TXT("升级超时") onView:self.view delay:1.0];
        [self isUpdatingUI:NO];
    }
}

-(void)noteAppForeground:(NSNotification*)note{
    JL_ug = [JL_BLEUsage sharedMe];
    if (JL_ug.bt_status_paired == NO) {
        NSLog(@"---> App Foreground.");
        [self isUpdatingUI:NO];
        [self otaTimeClose];//关闭超时检测
    }
}

@end
