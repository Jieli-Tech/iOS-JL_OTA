//
//  AutoUpdateTipsView.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/26.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "AutoUpdateTipsView.h"

@implementation AutoUpdateTipsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        
        _autoLab = [UILabel new];
        _autoLab.textColor = [UIColor colorFromHexString:@"#242424"];
        _autoLab.font = [UIFont systemFontOfSize:17];
        _autoLab.textAlignment = NSTextAlignmentCenter;
        _autoLab.text = kJL_TXT("auto_test_progress");
        [self addSubview:_autoLab];
        [_autoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(28);
            make.height.offset(30);
            make.centerX.offset(0);
        }];
        
        _updateProgressLab = [UILabel new];
        _updateProgressLab.font = [UIFont systemFontOfSize:16];
        _updateProgressLab.textColor = [UIColor colorFromHexString:@"#242424"];
        _updateProgressLab.text = [NSString stringWithFormat:@"%@",kJL_TXT("updateing")];
        _updateProgressLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_updateProgressLab];
        [_updateProgressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_autoLab.mas_bottom).offset(25);
            make.height.offset(25);
            make.centerX.offset(0);
        }];
        
        _progressView = [UIProgressView new];
        [self addSubview:_progressView];
        _detailLab = [UILabel new];
        _detailLab.textColor = [UIColor colorFromHexString:@"#919191"];
        _detailLab.font = [UIFont systemFontOfSize:15];
        _detailLab.textAlignment = NSTextAlignmentCenter;
        _detailLab.text = @"";
        _detailLab.numberOfLines = 0;
        [self addSubview:_detailLab];
        [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_updateProgressLab.mas_bottom).offset(5);
            make.centerX.offset(0);
            make.height.offset(40);
        }];
        
        
        
        [_progressView setProgress:0.0];
        [_progressView setProgressTintColor:[UIColor colorFromHexString:@"#398BFF"]];
        
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_detailLab.mas_bottom).offset(5);
            make.left.equalTo(self.mas_left).offset(28);
            make.right.equalTo(self.mas_right).offset(-28);
        }];
        
        
        _activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activeView startAnimating];
        _activeView.hidden = YES;
        [self addSubview:_activeView];
        [_activeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-20);
            make.width.height.offset(40);
        }];
        
        _tipsLab = [UILabel new];
        _tipsLab.font = [UIFont systemFontOfSize:14];
        _tipsLab.textColor = [UIColor colorFromHexString:@"#919191"];
        _tipsLab.text = kJL_TXT("while_update_please_keep_open_ble_and_network");
        _tipsLab.numberOfLines = 0;
        _tipsLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipsLab];
        [_tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_progressView.mas_bottom).offset(5);
            make.left.equalTo(self.mas_left).offset(28);
            make.right.equalTo(self.mas_right).offset(-28);
            make.bottom.equalTo(self.mas_bottom).offset(-20);
        }];
        
    }
    return self;
}

-(void)reConnect{
    _activeView.hidden = NO;
    _progressView.hidden = YES;
    _tipsLab.hidden = YES;
    _updateProgressLab.hidden = YES;
    _detailLab.text = [NSString stringWithFormat:@"\n%@",kJL_TXT("checked_reconnecting")];
}

-(void)normalStatus{
    _activeView.hidden = YES;
    _progressView.hidden = NO;
    _tipsLab.hidden = NO;
    _updateProgressLab.hidden = NO;
}

-(void)reConnectByAutoUpdate{
    _activeView.hidden = NO;
    _progressView.hidden = YES;
    _tipsLab.hidden = YES;
    _updateProgressLab.hidden = YES;
}


@end
