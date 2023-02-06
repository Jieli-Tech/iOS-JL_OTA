//
//  TipsDeleteView.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/17.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "TipsDeleteView.h"

@interface TipsDeleteView()

@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UIView      *centerView;
@property(nonatomic,strong)UILabel     *mainLab;
@property(nonatomic,strong)UIButton    *cancelBtn;
@property(nonatomic,strong)UIButton    *confirmBtn;
@property(nonatomic,strong)UIView      *line0;
@property(nonatomic,strong)UIView      *line1;


@end

@implementation TipsDeleteView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initUI];
    }
    return self;
}


-(void)initUI{
    self.backgroundColor = [UIColor clearColor];
    _bgView = [UIImageView new];
    _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
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
        make.height.offset(130);
        make.left.equalTo(self.mas_left).offset(45);
        make.right.equalTo(self.mas_right).offset(-45);
        make.centerY.offset(-70);
    }];
    
    
    _mainLab = [UILabel new];
    _mainLab.font = FontMedium(16);
    _mainLab.textColor = [UIColor colorFromHexString:@"#242424"];
    _mainLab.text = [NSString stringWithFormat:@"%@",kJL_TXT("weather_delete_all_logs")];
    _mainLab.textAlignment = NSTextAlignmentCenter;
    [_centerView addSubview:_mainLab];
    [_mainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerView.mas_top).offset(32);
        make.height.offset(32);
        make.centerX.offset(0);
    }];
    
    
    _cancelBtn = [UIButton new];
    [_cancelBtn setTitle:kJL_TXT("cancel") forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorFromHexString:@"#558CFF"] forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorFromHexString:@"#A4A4A4"] forState:UIControlStateHighlighted];
    [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_centerView addSubview:_cancelBtn];
    
    _confirmBtn = [UIButton new];
    [_confirmBtn setTitle:kJL_TXT("delete") forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor colorFromHexString:@"#558CFF"] forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor colorFromHexString:@"#A4A4A4"] forState:UIControlStateHighlighted];
    [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_centerView addSubview:_confirmBtn];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_centerView.mas_bottom).offset(0);
        make.left.equalTo(_centerView.mas_left).offset(0);
        make.right.equalTo(_confirmBtn.mas_left).offset(0);
        make.height.offset(50);
        make.width.equalTo(_confirmBtn.mas_width);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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

-(void)setHidenStatus:(BOOL)hidenStatus{
    _hidenStatus = hidenStatus;
    self.hidden = hidenStatus;
}

-(void)cancelBtnAction{
    self.hidenStatus = YES;
}
-(void)confirmBtnAction{
    NSString *basicPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:basicPath error:nil];
    for (NSString *path in files) {
        if([path hasSuffix:@".txt"]){
            NSString *newPath = [NSString stringWithFormat:@"%@/%@",basicPath,path];
            [fileManager removeItemAtPath:newPath error:nil];
        }
    }
    self.hidenStatus = YES;
}

@end
