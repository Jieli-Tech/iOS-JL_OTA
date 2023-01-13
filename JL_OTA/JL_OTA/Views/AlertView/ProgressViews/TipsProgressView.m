//
//  TipsProgressView.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/11.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "TipsProgressView.h"
#import "NormalUpdateTipsView.h"
#import "AutoUpdateTipsView.h"
#import "ToolsHelper.h"
#import "LoopUpdateManager.h"


@interface TipsProgressView()

@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)NormalUpdateTipsView *normalView;
@property(nonatomic,strong)AutoUpdateTipsView   *autoView;

@end

@implementation TipsProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initUI];
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
    
    _normalView = [[NormalUpdateTipsView alloc] initWithFrame:CGRectZero];
    [self addSubview:_normalView];
    
    [_normalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(148);
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }
    }];
    _normalView.hidden = YES;
    
    _autoView = [[AutoUpdateTipsView alloc] initWithFrame:CGRectZero];
    [self addSubview:_autoView];
    
    [_autoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(225);
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }
    }];
    
    _autoView.hidden = YES;
    
    
}


-(void)setWithOtaResult:(JL_OTAResult)result withProgress:(float)progress{
    
    self.hidden = NO;
    if([ToolsHelper isAutoTestOta]){
        self.autoView.hidden = NO;
        self.normalView.hidden = YES;
    }else{
        self.autoView.hidden = YES;
        self.normalView.hidden = NO;
    }
    
    if (result == JL_OTAResultUpgrading || result == JL_OTAResultPreparing) {
        [self.normalView normalStatus];
        [self.autoView normalStatus];
        
        self.autoView.autoLab.text = [NSString stringWithFormat:@"%@%@",kJL_TXT("auto_test_progress"),[[LoopUpdateManager share] info].nowIndexStr];
        self.autoView.detailLab.text = [[LoopUpdateManager share] info].name;
        
        NSString *txt = [NSString stringWithFormat:@"%.1f%%",progress*100.0f];
        self.normalView.updateProgressLab.text = [NSString stringWithFormat:@"%@ %@%%",kJL_TXT("updateing"),txt];
        self.autoView.updateProgressLab.text = [NSString stringWithFormat:@"%@ %@%%",kJL_TXT("updateing"),txt];
        
        self.normalView.progressView.progress = progress;
        self.autoView.progressView.progress = progress;
        
        if (result == JL_OTAResultPreparing){
            self.normalView.updateProgressLab.text = [NSString stringWithFormat:@"%@ %@",kJL_TXT("verify_file_ing"),txt];
            self.autoView.updateProgressLab.text = [NSString stringWithFormat:@"%@ %@",kJL_TXT("verify_file_ing"),txt];
        }
            
        if (result == JL_OTAResultUpgrading){
            self.normalView.updateProgressLab.text = [NSString stringWithFormat:@"%@ %@",kJL_TXT("updateing"),txt];
            self.autoView.updateProgressLab.text = [NSString stringWithFormat:@"%@ %@",kJL_TXT("updateing"),txt];
        }
    } else if (result == JL_OTAResultPrepared) {
        
        self.normalView.updateProgressLab.text = kJL_TXT("verify_file_finish");
        self.autoView.updateProgressLab.text = kJL_TXT("verify_file_finish");
        
    } else if (result == JL_OTAResultReconnect) {
        [self.autoView reConnect];
        [self.normalView reConnect];
        
    } else if (result == JL_OTAResultReconnectWithMacAddr) {
        [self.autoView reConnect];
        [self.normalView reConnect];
        
    } else if (result == JL_OTAResultSuccess) {
        self.normalView.progressView.progress = 1.0;
        self.normalView.updateProgressLab.text = kJL_TXT("update_finish");
        
        self.autoView.progressView.progress = 1.0;
        self.autoView.updateProgressLab.text = kJL_TXT("update_finish");
        
        if([ToolsHelper isAutoTestOta]){
            if([[LoopUpdateManager share] shouldLoopUpdate]){
                [self.autoView reConnectByAutoUpdate];
                self.autoView.detailLab.text = [NSString stringWithFormat:@"%@%d%@%@,%@"
                                                ,kJL_TXT("the")
                                                ,(int)[[LoopUpdateManager share] finishNumber]
                                                ,kJL_TXT("th")
                                                ,kJL_TXT("update_finish")
                                                ,kJL_TXT("reconnecting_back")];
            }else{
                self.hidden = YES;
            }
        }else{
            self.hidden = YES;
        }
        
    } else if (result == JL_OTAResultReboot) {
        if([ToolsHelper isAutoTestOta]){
            if([[LoopUpdateManager share] shouldLoopUpdate]){
                [self.autoView reConnectByAutoUpdate];
                self.autoView.detailLab.text = [NSString stringWithFormat:@"%@%d%@%@,%@"
                                                ,kJL_TXT("the")
                                                ,(int)[[LoopUpdateManager share] finishNumber]
                                                ,kJL_TXT("th")
                                                ,kJL_TXT("update_finish")
                                                ,kJL_TXT("reconnecting_back")];
            }else{
                self.hidden = YES;
            }
        }else{
            self.hidden = YES;
        }
    } else if (result == JL_OTAResultFail) {
        self.hidden = YES;
    }else {
        // 其余错误码详细 Command+点击JL_OTAResult 查看说明
        NSLog(@"ota update result: %d", result);
        
    }
    
}




-(void)timeOutShow{
    self.normalView.updateProgressLab.text = kJL_TXT("update_timeout");
    self.autoView.updateProgressLab.text = kJL_TXT("update_timeout");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}

@end
