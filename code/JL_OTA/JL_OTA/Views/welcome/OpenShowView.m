//
//  OpenShowView.m
//  JL_OTA
//
//  Created by 李放 on 2024/11/26.
//  Copyright © 2024 Zhuhia Jieli Technology. All rights reserved.
//

#import "OpenShowView.h"
#import "JL_RunSDK.h"

@interface OpenShowView()

@end


@implementation OpenShowView

static OpenShowView *openView = nil;
static UIImageView  *centerImageView = nil;
static UILabel      *centerLabel = nil;

-(void)actionAnimationDuration:(float)duration{
    
    [UIView animateWithDuration:duration animations:^{
        [self initAnimate];
    }];
    [JL_Tools delay:duration+1.0 Task:^{
        [UIView animateWithDuration:1.0 animations:^{
            self.alpha = 0.0;
        }];
    }];
    [JL_Tools delay:duration+2.0 Task:^{
        [self removeFromSuperview];
        openView = nil;
    }];
}

-(void)initAnimate{
    centerImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    centerLabel.transform = CGAffineTransformMakeScale(1.1, 1.1);
    centerImageView.alpha = 1.0;
    centerLabel.alpha = 1.0;
}

+(void)startOpenAnimation{
    UIWindow *win = [DFUITools getWindow];
    
    openView = [[OpenShowView alloc] initWithFrame:win.bounds];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:openView.bounds];
    bgImageView.image = [UIImage imageNamed:@"background"];
    [openView addSubview:bgImageView];
    [win addSubview:openView];
    
    [bgImageView addSubview:[self initCenterImageView]];
    [bgImageView addSubview:[self initCenterLabel]];
    
    [centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(openView);
        make.centerY.equalTo(openView).offset(-100);
    }];
    
    [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(openView);
        make.top.equalTo(centerImageView.mas_bottom).offset(20);
    }];
    
    [openView actionAnimationDuration:1.5];
}

+(UIImageView *)initCenterImageView{
    if(!centerImageView){
        centerImageView = [[UIImageView alloc] init];
        centerImageView.image = [UIImage imageNamed:@"logo"];
        centerImageView.transform = CGAffineTransformMakeScale(0, 0);
        centerImageView.alpha = 0.0;
    }
    return centerImageView;
}

+(UILabel *)initCenterLabel{
    if(!centerLabel){
        centerLabel = [[UILabel alloc] init];
        centerLabel.text = kJL_TXT("ota_update");
        centerLabel.font = FontMedium(20);
        centerLabel.textColor =kDF_RGBA(255, 255, 255, 1);
        centerLabel.transform = CGAffineTransformMakeScale(0, 0);
        centerLabel.alpha = 0.0;
    }
    return centerLabel;
}

@end
