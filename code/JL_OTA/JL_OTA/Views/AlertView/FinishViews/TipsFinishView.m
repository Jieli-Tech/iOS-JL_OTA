//
//  TipsFinishView.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/11.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "TipsFinishView.h"
#import "AutoFinishView.h"
#import "NormalFinishView.h"
#import "ToolsHelper.h"
#import "LoopUpdateManager.h"

@interface TipsFinishView()

@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)AutoFinishView *autoView;
@property(nonatomic,strong)NormalFinishView *normalView;
@property(nonatomic,assign)JLTipsViewType tipsType;
@end

@implementation TipsFinishView

-(instancetype)init:(JLTipsViewType) type {
    self = [super init];
    _tipsType = type;
    [self initUI];
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
    
    if (_tipsType == JLTipsNormal) {
        _normalView = [[NormalFinishView alloc] initWithFrame:CGRectZero];
        [self addSubview:_normalView];
        [_normalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(196);
            make.left.equalTo(self.mas_left).offset(12);
            make.right.equalTo(self.mas_right).offset(-12);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
            } else {
                // Fallback on earlier versions
                make.bottom.equalTo(self.mas_bottom).offset(-10);
            }
        }];
    }
    
    
    if (_tipsType == JLTipsAuto) {
        _autoView = [[AutoFinishView alloc] initWithFrame:CGRectZero];
        [self addSubview:_autoView];
        [_autoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(254);
            make.left.equalTo(self.mas_left).offset(12);
            make.right.equalTo(self.mas_right).offset(-12);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
            } else {
                // Fallback on earlier versions
                make.bottom.equalTo(self.mas_bottom).offset(-10);
            }
        }];
    }
    _autoView.hidden = true;
    _normalView.hidden = true;
    
    [_autoView addObserver:self forKeyPath:@"hiddOrNot" options:NSKeyValueObservingOptionNew context:nil];
    [_normalView addObserver:self forKeyPath:@"hiddOrNot" options:NSKeyValueObservingOptionNew context:nil];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"hiddOrNot"]){
        NSNumber *objc = change[NSKeyValueChangeNewKey];
        BOOL value = [objc boolValue];
        self.hidden = value;
    }
}


-(void)succeed{
    self.hidden = false;
    if([ToolsHelper isAutoTestOta]){
        _autoView.hidden = false;
        _normalView.hidden = true;
        [_autoView successStatus];
        _autoView.autoLab.text = [NSString stringWithFormat:@"%@%d/%d",kJL_TXT("auto_test_progress"),(int)([[LoopUpdateManager share] finishNumber]+[[LoopUpdateManager share] failedNumber]),(int)[ToolsHelper getAutoTestOtaNumber]];
        _autoView.testNumberLab.text = [NSString stringWithFormat:@"%@%d,%@%d",kJL_TXT("number_of_test_tasks"),(int)[ToolsHelper getAutoTestOtaNumber],kJL_TXT("number_of_successful_tests"),(int)[[LoopUpdateManager share] finishNumber]];
    }else{
        _autoView.hidden = true;
        _normalView.hidden = false;
        [_normalView successStatus];
    }
}

-(void)failed:(JL_OTAResult)result{
    self.hidden = false;
    if([ToolsHelper isAutoTestOta]){
        _autoView.hidden = false;
        _normalView.hidden = true;
        [_autoView failedStatus];
        _autoView.errorLab.text = [NSString stringWithFormat:@"%@:%@",kJL_TXT("reason"),[ToolsHelper errorReason:result]];
        if(![ToolsHelper getFaultTolerant]){
            kJLLog(JLLOG_ERROR, @"发生错误导致关闭自动化升级！！！");
            [[LoopUpdateManager share] cleanList];
        }
        _autoView.testNumberLab.text = [NSString stringWithFormat:@"%@%d,%@%d",kJL_TXT("number_of_test_tasks"),(int)[ToolsHelper getAutoTestOtaNumber],kJL_TXT("number_of_successful_tests"),(int)[[LoopUpdateManager share] finishNumber]];
    }else{
        _autoView.hidden = true;
        _normalView.hidden = false;
        [_normalView failedStatus];
        _normalView.errorLab.text = [NSString stringWithFormat:@"%@:%@",kJL_TXT("reason"),[ToolsHelper errorReason:result]];
    }
    
}




@end
