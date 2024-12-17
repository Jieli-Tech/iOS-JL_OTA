//
//  AboutViewController.m
//  JL_OTA
//
//  Created by 李放 on 2024/11/23.
//  Copyright © 2024 Zhuhia Jieli Technology. All rights reserved.
//

#import "AboutViewController.h"
#import "JL_RunSDK.h"
#import "AboutCell.h"
#import "WebViewController.h"

#define POSITION_FIRST  0
#define POSITION_SECOND 1
#define ICP_FILING_INFORMATION @"粤ICP备18069041号-15A"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *dataArray;
    
    UIImageView *topImageView;
    UILabel     *appNameLabel;
    UILabel     *versionLabel;
    UITableView *aboutTableView;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI{
    self.title = kJL_TXT("about_app");
    UIImage *img = [[UIImage imageNamed:@"icon_return_nol"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction)];
    leftBtn.tintColor = [UIColor grayColor];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    self.view.backgroundColor = kDF_RGBA(244, 247, 251, 1);
    dataArray = @[kJL_TXT("user_agreement"),kJL_TXT("privacy_policy")];
    
    [self.view addSubview:[self topImageView]];
    [self.view addSubview:[self appNameLabel]];
    [self.view addSubview:[self versionLabel]];
    [self.view addSubview:[self aboutTableView]];
    
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(kJL_HeightNavBar+72);
    }];
    
    [appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(topImageView.mas_bottom).offset(16);
    }];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(appNameLabel.mas_bottom).offset(2);
    }];
    
    [aboutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(versionLabel.mas_bottom).offset(36);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(96);
    }];
    
    UILabel *bottomLab = [[UILabel alloc] init];
    bottomLab.font = FontMedium(11);
    bottomLab.text = kJL_TXT("copy_right");
    bottomLab.textColor = kDF_RGBA(0, 0, 0, 0.3);
    bottomLab.textAlignment = NSTextAlignmentCenter;
    bottomLab.numberOfLines = 0;
    bottomLab.adjustsFontSizeToFitWidth = true;
    [self.view addSubview:bottomLab];
    [bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-42);
        make.centerX.equalTo(self.view);
    }];
    
    UIButton *bottomLabBtn = [UIButton new];
    NSString *bottomLabBtnName = [NSString stringWithFormat:@"%@:%@",kJL_TXT("icp_filing_information"),ICP_FILING_INFORMATION];
    [bottomLabBtn setTitle:bottomLabBtnName forState:UIControlStateNormal];
    bottomLabBtn.titleLabel.font = FontMedium(11);
    [bottomLabBtn setTitleColor:kDF_RGBA(0, 0, 0, 0.3) forState:UIControlStateNormal];
    [bottomLabBtn addTarget:self action:@selector(icpInfoClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomLabBtn];
    [bottomLabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomLab.mas_top);
        make.centerX.equalTo(self.view);
    }];
    
    UIImageView *bottomLabImv = [UIImageView new];
    bottomLabImv.image = [UIImage imageNamed:@"icon_bottom_next"];
    bottomLabImv.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:bottomLabImv];
    [bottomLabImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomLabBtn.mas_right);
        make.width.height.equalTo(@12);
        make.centerY.equalTo(bottomLabBtn);
    }];
}

-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark <- tableView Delegate ->
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CELL_ID = @"AboutCell";
    AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (!cell) {
        cell = [[AboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.mFuncName.text = dataArray[indexPath.row];
    
    if (indexPath.row == dataArray.count - POSITION_SECOND) {
        cell.separatorInset = UIEdgeInsetsMake(0,[UIScreen mainScreen].bounds.size.width, 0, 0);
        cell.layoutMargins = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
    }else{
        UIView *separatorView = [[UIView alloc] init];
        separatorView.frame = CGRectMake(20,49,aboutTableView.frame.size.width-20,1);
        separatorView.backgroundColor = kDF_RGBA(0, 0, 0, 0.06);
        [cell addSubview:separatorView];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case POSITION_FIRST:
        {
            WebViewController *vc = [[WebViewController alloc] init];
            vc.webType = UserProfileType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case POSITION_SECOND:
        {
            WebViewController *vc = [[WebViewController alloc] init];
            vc.webType = PrivacyPolicyType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)icpInfoClickEvent {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.webType = ICPType;
    vc.icpTitleName = ICP_FILING_INFORMATION;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIImageView *)topImageView{
    if(!topImageView){
        topImageView = [[UIImageView alloc] init];
        topImageView.image = [UIImage imageNamed:@"icon_logo"];
    }
    return topImageView;
}

-(UILabel *)appNameLabel{
    if(!appNameLabel){
        appNameLabel = [[UILabel alloc] init];
        appNameLabel.numberOfLines = 1;
        appNameLabel.text = kJL_TXT("ota_update");
        appNameLabel.textColor = kDF_RGBA(0, 0, 0, 0.9);
        appNameLabel.font = FontMedium(16);
        appNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return appNameLabel;
}

-(UILabel *)versionLabel{
    if(!versionLabel){
        versionLabel = [[UILabel alloc] init];
        versionLabel.numberOfLines = 1;
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        versionLabel.text = [NSString stringWithFormat:@"%@%@%@",kJL_TXT("current_version"),@" V",appVersion];
        versionLabel.textColor = kDF_RGBA(0, 0, 0, 0.6);
        versionLabel.font = FontMedium(13);
        versionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return versionLabel;
}

-(UITableView *)aboutTableView{
    if(!aboutTableView){
        aboutTableView = [[UITableView alloc] init];
        aboutTableView.backgroundColor = [UIColor whiteColor];
        aboutTableView.tableFooterView = [UIView new];
        aboutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        aboutTableView.showsVerticalScrollIndicator = NO;
        aboutTableView.rowHeight  = 48;
        aboutTableView.dataSource = self;
        aboutTableView.delegate   = self;
        aboutTableView.scrollEnabled = NO;
    }
    return aboutTableView;
}

@end
