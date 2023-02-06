//
//  NormalFinishView.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/27.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "NormalFinishView.h"

@implementation NormalFinishView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        
        _finishImgv = [UIImageView new];
        _finishImgv.image = [UIImage imageNamed:@"icon_success_nol"];
        [self addSubview:_finishImgv];
        [_finishImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(24);
            make.centerX.offset(0);
        }];
        
        
        
        _updateFinishLab = [UILabel new];
        _updateFinishLab.font = [UIFont systemFontOfSize:16];
        _updateFinishLab.textAlignment = NSTextAlignmentCenter;
        _updateFinishLab.textColor = [UIColor colorFromHexString:@"#242424"];
        _updateFinishLab.text = kJL_TXT("update_finish");
        [self addSubview:_updateFinishLab];
        [_updateFinishLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_finishImgv.mas_bottom).offset(8);
            make.centerX.offset(0);
            make.height.offset(25);
        }];
        
        _errorLab = [UILabel new];
        _errorLab.text = kJL_TXT("reason");
        _errorLab.textColor = [UIColor colorFromHexString:@"#808080"];
        _errorLab.font = [UIFont systemFontOfSize:15];
        _errorLab.numberOfLines = 0;
        _errorLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_errorLab];
        [_errorLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_updateFinishLab.mas_bottom).offset(5);
            make.left.equalTo(self.mas_left).offset(5);
            make.right.equalTo(self.mas_right).offset(-5);
            make.height.offset(0);
        }];
        
        _confirmBtn = [UIButton new];
        [_confirmBtn setTitle:kJL_TXT("confirm") forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_confirmBtn setTitleColor:[UIColor colorFromHexString:@"#398BFF"] forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmBtn];
        
        [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(40);
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(-5);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorFromHexString:@"#F7F7F7"];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(_confirmBtn.mas_top).offset(-1);
            make.height.offset(1);
        }];
    }
    return self;
}

-(void)confirmBtnAction{
    self.hidden = YES;
    self.hiddOrNot = YES;
    
}

-(void)failedStatus{
    [_errorLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_updateFinishLab.mas_bottom).offset(5);
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.offset(25);
    }];
    _finishImgv.image = [UIImage imageNamed:@"icon_fail_nol"];
    _updateFinishLab.text = kJL_TXT("update_failed");
}

-(void)successStatus{
    [_errorLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_updateFinishLab.mas_bottom).offset(5);
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.offset(0);
    }];
    _finishImgv.image = [UIImage imageNamed:@"icon_success_nol"];
    _updateFinishLab.text = kJL_TXT("update_finish");
}
@end
