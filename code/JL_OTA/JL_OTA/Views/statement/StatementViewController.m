//
//  StatementViewController.m
//  JL_OTA
//
//  Created by 李放 on 2024/11/23.
//  Copyright © 2024 Zhuhia Jieli Technology. All rights reserved.
//

#import "StatementViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "JL_RunSDK.h"

@interface StatementViewController (){
    UIImageView *bgImv;
    UIView      *bgView;
    UIView      *contentView;
    UILabel     *titleLabel;
    UILabel     *contentLabel;
    UIButton    *confirmBtn;
    UIButton    *cancelBtn;
}

@end

@implementation StatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initContentUI];
}

-(void)initContentUI{
    [self.view addSubview:[self bgImv]];
    [self.view addSubview:[self bgView]];
    [self.view addSubview:[self contentView]];
    [self.view addSubview:[self titleLabel]];
    [self.view addSubview:[self contentLabel]];
    [self.view addSubview:[self confirmBtn]];
    [self.view addSubview:[self cancelBtn]];
    
    [bgImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImv);
        make.centerY.equalTo(bgImv);
        make.left.right.equalTo(bgImv).inset(32);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView.mas_top).offset(28);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(6);
        make.left.equalTo(contentView.mas_left).offset(16);
        make.right.equalTo(contentView.mas_right).offset(-16);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(21);
        make.left.equalTo(contentView.mas_left).offset(16);
        make.right.equalTo(contentView.mas_right).offset(-16);
        make.height.offset(44);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(contentView.mas_safeAreaLayoutGuideBottom).offset(-67);
        } else {
            make.bottom.equalTo(contentView.mas_bottom).offset(-67);
        }
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.right.equalTo(contentView.mas_right).offset(-16);
        make.height.offset(44);
        make.top.equalTo(confirmBtn.mas_bottom).offset(12);
    }];
}

- (void)confirmBtnFunc{
    [JL_Tools setUser:kJL_AGRESS_PROTOCOL forKey:KEY_COMMIT_PROTOCOL];
    if ([_delegate respondsToSelector:@selector(confirmConfirmBtnAction)]) {
        [_delegate confirmConfirmBtnAction];
    }
}

- (void)cancelBtnFunc{
    if ([_delegate respondsToSelector:@selector(confirmCancelBtnAction)]) {
        [_delegate confirmCancelBtnAction];
    }
}

-(UIImageView *)bgImv{
    if(!bgImv){
        bgImv = [[UIImageView alloc] init];
        bgImv.image = [UIImage imageNamed:@"background"];
    }
    return bgImv;
}

-(UIView *)bgView{
    if(!bgView){
        bgView = [[UIView alloc] init];
        bgView.backgroundColor = kDF_RGBA(0, 0, 0, 0.3);
    }
    return bgView;
}

-(UIView *)contentView{
    if(!contentView){
        contentView = [[UIView alloc] init];
        contentView.layer.backgroundColor = kDF_RGBA(255, 255, 255, 1.0).CGColor;
        contentView.layer.cornerRadius = 16;
    }
    return contentView;
}

-(UILabel *)titleLabel{
    if(!titleLabel){
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 1;
        titleLabel.text = kJL_TXT("declaration");
        titleLabel.textColor = kDF_RGBA(36, 36, 36, 1);
        titleLabel.font = FontMedium(17);
        titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return titleLabel;
}

-(UILabel *)contentLabel{
    if(!contentLabel){
        contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines = 0;
        UIColor *colorFirst = kDF_RGBA(0, 0, 0, 0.8);
        UIColor *colorSecond = kDF_RGBA(0, 121, 255, 1.0);
        
        NSString *showText = [NSString stringWithFormat:@"%@",  kJL_TXT("statement_first")];
        NSArray  *array = @[kJL_TXT("statement_second"), kJL_TXT("statement_third")];
        contentLabel.attributedText = [JL_RunSDK getAttributeWith:array string:showText orginFont:14 orginColor:colorFirst attributeFont:14 attributeColor:colorSecond];
        __weak typeof(self) weakSelf = self;
        [contentLabel yb_addAttributeTapActionWithStrings:array tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            if ([weakSelf.delegate respondsToSelector:@selector(confirmDidSelect:)]) {
                [weakSelf.delegate confirmDidSelect:(int)index];
            }
        }];
    }
    return contentLabel;
}

-(UIButton *)confirmBtn{
    if(!confirmBtn){
        confirmBtn = [[UIButton alloc] init];
        confirmBtn.layer.cornerRadius = 8;
        confirmBtn.layer.masksToBounds = YES;
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        confirmBtn.titleLabel.font = FontMedium(15);
        [confirmBtn addTarget:self action:@selector(confirmBtnFunc) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn setBackgroundColor:kDF_RGBA(57, 139, 255, 1)];
        [confirmBtn setTitle:kJL_TXT("ok") forState:UIControlStateNormal];
    }
    return confirmBtn;
}

-(UIButton *)cancelBtn{
    if(!cancelBtn){
        cancelBtn = [[UIButton alloc] init];
        cancelBtn.layer.cornerRadius = 8;
        cancelBtn.layer.masksToBounds = YES;
        [cancelBtn setTitleColor:kDF_RGBA(0, 0, 0, 0.50) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        cancelBtn.titleLabel.font = FontMedium(15);
        [cancelBtn addTarget:self action:@selector(cancelBtnFunc) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setBackgroundColor:kDF_RGBA(255, 255, 255, 1)];
        [cancelBtn setTitle:kJL_TXT("rejected") forState:UIControlStateNormal];
    }
    return cancelBtn;
}

@end
