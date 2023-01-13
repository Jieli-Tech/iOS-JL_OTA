//
//  NormalUpdateTipsView.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/27.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "NormalUpdateTipsView.h"

@implementation NormalUpdateTipsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        _updateProgressLab = [UILabel new];
        _updateProgressLab.font = [UIFont systemFontOfSize:16];
        _updateProgressLab.textColor = [UIColor colorFromHexString:@"#242424"];
        _updateProgressLab.text = [NSString stringWithFormat:@"%@",kJL_TXT("updateing")];
        _updateProgressLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_updateProgressLab];
        [_updateProgressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(20);
            make.height.offset(25);
            make.centerX.offset(0);
        }];
        
        _progressView = [UIProgressView new];
        [_progressView setProgress:0.0];
        [_progressView setProgressTintColor:[UIColor colorFromHexString:@"#398BFF"]];
        [self addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_updateProgressLab.mas_bottom).offset(20);
            make.left.equalTo(self.mas_left).offset(28);
            make.right.equalTo(self.mas_right).offset(-28);
        }];
        
        _activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activeView startAnimating];
        _activeView.hidden = YES;
        [self addSubview:_activeView];
        [_activeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-10);
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
            make.top.equalTo(_updateProgressLab.mas_bottom).offset(6);
            make.left.equalTo(self.mas_left).offset(28);
            make.right.equalTo(self.mas_right).offset(-28);
            make.bottom.equalTo(self.mas_bottom).offset(-1);
        }];
    }
    return self;
}

-(void)reConnect{
    _updateProgressLab.hidden = YES;
    _progressView.hidden = YES;
    _activeView.hidden = NO;
    _tipsLab.text = [NSString stringWithFormat:@"%@",kJL_TXT("checked_reconnecting")];
}

-(void)normalStatus{
    _updateProgressLab.hidden = NO;
    _progressView.hidden = NO;
    _activeView.hidden = YES;
    _tipsLab.text = kJL_TXT("while_update_please_keep_open_ble_and_network");
}



@end
