//
//  AutoFinishView.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/27.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "AutoFinishView.h"
#import "LoopUpdateManager.h"

@implementation AutoFinishView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        
        
        _autoLab = [UILabel new];
        _autoLab.font = [UIFont systemFontOfSize:17];
        _autoLab.textAlignment = NSTextAlignmentCenter;
        _autoLab.text = kJL_TXT("auto_test_progress");
        _autoLab.textColor = [UIColor colorFromHexString:@"#242424"];
        [self addSubview:_autoLab];
        [_autoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(20);
            make.centerX.equalTo(self);
            make.height.offset(30);
        }];
        
        _finishImgv = [UIImageView new];
        _finishImgv.image = [UIImage imageNamed:@"icon_success_nol"];
        [self addSubview:_finishImgv];
        [_finishImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_autoLab.mas_bottom).offset(10);
            make.centerX.offset(0);
            make.width.height.offset(48);
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
        _errorLab.textColor = [UIColor colorFromHexString:@"#242424"];
        _errorLab.font = [UIFont systemFontOfSize:15];
        _errorLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_errorLab];
        [_errorLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_updateFinishLab.mas_bottom).offset(5);
            make.left.equalTo(self.mas_left).offset(5);
            make.right.equalTo(self.mas_right).offset(-5);
            make.height.offset(0);
        }];
        
        _testNumberLab = [UILabel new];
        _testNumberLab.text = [NSString stringWithFormat:@"%@;%@",kJL_TXT("number_of_test_tasks"),kJL_TXT("number_of_successful_tests")];
        _testNumberLab.textColor = [UIColor colorFromHexString:@"#919191"];
        _testNumberLab.font = [UIFont systemFontOfSize:15];
        _testNumberLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_testNumberLab];
        [_testNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_errorLab.mas_bottom).offset(5);
            make.left.equalTo(self.mas_left).offset(5);
            make.right.equalTo(self.mas_right).offset(-5);
            make.height.offset(25);
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
    if ([[LoopUpdateManager share] shouldLoopUpdate]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:kJL_TXT("tips") message:kJL_TXT("current_update_task") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:kJL_TXT("cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.hidden = YES;
            self.hiddOrNot = YES;
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:kJL_TXT("confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[LoopUpdateManager share] cleanList];
            self.hidden = YES;
            self.hiddOrNot = YES;
        }]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    } else {
        self.hidden = YES;
        self.hiddOrNot = YES;
    }
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
    _autoLab.text = [NSString stringWithFormat:@"%@%@",kJL_TXT("auto_test_progress"),kJL_TXT("end_update")];
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
    _autoLab.text = kJL_TXT("auto_test_progress");
}



@end
