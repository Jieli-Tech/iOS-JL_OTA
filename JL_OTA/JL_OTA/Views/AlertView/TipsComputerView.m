//
//  TipsComputerView.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/11.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "TipsComputerView.h"
#import "GCDWebKit.h"

@interface TipsComputerView()

@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UIView *centerView;
@property(nonatomic,strong)UILabel *titleStatusLab;
@property(nonatomic,strong)UILabel *tipsLab;
@property(nonatomic,strong)UIImageView *cpImgv;
@property(nonatomic,strong)UILabel *addressLab;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *cpyBtn;
@property(nonatomic,strong)UIView *line0;
@property(nonatomic,strong)UIView *line1;

@end

@implementation TipsComputerView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initUI];
        [self observerValueForWifiStatus];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor = [UIColor clearColor];
    _bgView = [UIImageView new];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.3;
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    _centerView = [UIView new];
    _centerView.backgroundColor = [UIColor whiteColor];
    _centerView.layer.cornerRadius = 15;
    _centerView.layer.masksToBounds = YES;
    [self addSubview:_centerView];
    
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(325);
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }
    }];
    
    _titleStatusLab = [UILabel new];
    _titleStatusLab.font = FontMedium(16);
    _titleStatusLab.textColor = [UIColor colorFromHexString:@"#398BFF"];
    _titleStatusLab.textAlignment = NSTextAlignmentCenter;
    _titleStatusLab.text = kJL_TXT("server_started");
    [_centerView addSubview:_titleStatusLab];
    [_titleStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerView.mas_top).offset(20);
        make.centerX.offset(0);
        make.height.offset(30);
    }];
    
    _tipsLab = [UILabel new];
    _tipsLab.font = FontMedium(14);
    _tipsLab.textColor = [UIColor colorFromHexString:@"#A4A4A4"];
    _tipsLab.textAlignment = NSTextAlignmentCenter;
    _tipsLab.numberOfLines = 0;
    _tipsLab.text = kJL_TXT("please_confirm_computer_phone_in_same_wifi_or_computer_connect_to_phone_hotspot");
    [_centerView addSubview:_tipsLab];
    [_tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleStatusLab.mas_bottom).offset(8);
        make.left.equalTo(_centerView.mas_left).offset(30);
        make.right.equalTo(_centerView.mas_right).offset(-30);
        make.height.offset(60);
    }];
    
    _cpImgv = [UIImageView new];
    _cpImgv.image = [UIImage imageNamed:@"img_02"];
    [_centerView addSubview:_cpImgv];
    [_cpImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipsLab.mas_bottom).offset(8);
        make.centerX.offset(0);
        make.height.offset(90);
        make.width.offset(182);
    }];
    
    _addressLab = [UILabel new];
    _addressLab.font = FontMedium(15);
    _addressLab.textColor = [UIColor colorFromHexString:@"#398BFF"];
    _addressLab.textAlignment = NSTextAlignmentCenter;
    _addressLab.numberOfLines = 0;
    _addressLab.text = @"http://192.168.1.1:8080/update";
    [_centerView addSubview:_addressLab];
    [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cpImgv.mas_bottom).offset(8);
        make.left.equalTo(_centerView.mas_left).offset(30);
        make.right.equalTo(_centerView.mas_right).offset(-30);
        make.height.offset(30);
    }];
    
    _cancelBtn = [UIButton new];
    [_cancelBtn setTitle:kJL_TXT("close_it") forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorFromHexString:@"#242424"] forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorFromHexString:@"#A4A4A4"] forState:UIControlStateHighlighted];
    [_cancelBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_centerView addSubview:_cancelBtn];
    
    _cpyBtn = [UIButton new];
    [_cpyBtn setTitle:kJL_TXT("copy_address") forState:UIControlStateNormal];
    [_cpyBtn setTitleColor:[UIColor colorFromHexString:@"#398BFF"] forState:UIControlStateNormal];
    [_cpyBtn setTitleColor:[UIColor colorFromHexString:@"#A4A4A4"] forState:UIControlStateHighlighted];
    [_cpyBtn addTarget:self action:@selector(copyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_centerView addSubview:_cpyBtn];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_centerView.mas_bottom).offset(0);
        make.left.equalTo(_centerView.mas_left).offset(0);
        make.right.equalTo(_cpyBtn.mas_left).offset(0);
        make.height.offset(50);
        make.width.equalTo(_cpyBtn.mas_width);
    }];
    
    [_cpyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_centerView.mas_bottom).offset(0);
        make.left.equalTo(_cancelBtn.mas_right).offset(0);
        make.right.equalTo(_centerView.mas_right).offset(0);
        make.height.offset(50);
        make.width.equalTo(_cancelBtn.mas_width);
    }];
    
    _line0 = [UIView new];
    _line0.backgroundColor = [UIColor colorFromHexString:@"#F5F5F5"];
    [_centerView addSubview:_line0];
    _line1 = [UIView new];
    _line1.backgroundColor = [UIColor colorFromHexString:@"#F5F5F5"];
    [_centerView addSubview:_line1];
    
    [_line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_cancelBtn.mas_top).offset(0);
        make.left.equalTo(_centerView.mas_left).offset(0);
        make.right.equalTo(_centerView.mas_right).offset(0);
        make.height.offset(1);
    }];
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_centerView.mas_bottom).offset(0);
        make.left.equalTo(_cancelBtn.mas_right).offset(0);
        make.height.offset(50);
        make.width.offset(1);
    }];
    
}


-(void)observerValueForWifiStatus{
    //增加浏览器传文件功能
    [GCDWebKit startWithResult:^(GCDWebKitStatus status,
                                 NSString *__nullable ipAdress,
                                 NSInteger port) {
        if (status == GCDWebKitStatusStart) {
            self.titleStatusLab.text = kJL_TXT("server_started");
            self.addressLab.text = [NSString stringWithFormat:@"http://%@:%zd/  ",ipAdress,port];
        }
        if (status == GCDWebKitStatusFail) {
            self.titleStatusLab.text = kJL_TXT("server_closed");
            self.addressLab.text = @"";
        }
        
        if (status == GCDWebKitStatusUpload) {
            
        }
        if (status == GCDWebKitStatusMove) {
            
        }
        if (status == GCDWebKitStatusDelete) {
            
        }
        if (status == GCDWebKitStatusCreate) {
            
        }
        if (status == GCDWebKitStatusWifiDisable) {
            self.titleStatusLab.text = kJL_TXT("server_closed");
            self.addressLab.text = @"";
        }
    }];
}


-(void)closeBtnAction{
    self.hidden = YES;
}

-(void)copyBtnAction{
    UIPasteboard *appPasteBoard =  [UIPasteboard generalPasteboard];
    [appPasteBoard setString:_addressLab.text];
    [DFUITools showText:kJL_TXT("copy_text_finish") onView:self delay:1];
}



@end
