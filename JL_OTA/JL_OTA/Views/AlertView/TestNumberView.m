//
//  TestNumberView.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/12.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "TestNumberView.h"
#import "ToolsHelper.h"
#import "EcEditView.h"

@interface TestNumberView()<UITextFieldDelegate>{
    UIView *bgView;
    UIView *centerView;
    UILabel *titleLab;
    EcEditView *textfixed;
    UIImageView *line0;
    UIImageView *line1;
    UIButton *cancelBtn;
    UIButton *confirmBtn;

    int modelType;
}

@end

@implementation TestNumberView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        modelType = 0;
        [self initUI];
    }
    return self;
}


-(void)initUI{
    bgView = [UIView new];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    centerView = [UIView new];
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.cornerRadius = 12;
    centerView.layer.masksToBounds = true;
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(170);
        make.left.equalTo(self.mas_left).offset(24);
        make.right.equalTo(self.mas_right).offset(-24);
        make.height.offset(206);
    }];
    
    titleLab = [UILabel new];
    titleLab.font = FontMedium(16);
    titleLab.text = kJL_TXT("test_number");
    titleLab.textColor = [UIColor darkTextColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_top).offset(36);
        make.centerX.offset(0);
        make.height.offset(30);
    }];
    
    textfixed = [EcEditView new];
    textfixed.borderStyle = UITextBorderStyleNone;
    textfixed.layer.cornerRadius = 4;
    textfixed.layer.masksToBounds = true;
    textfixed.backgroundColor = [UIColor colorFromHexString:@"#EFEFEF"];
    textfixed.clearButtonMode = UITextFieldViewModeAlways;
    textfixed.font = FontMedium(15);
    textfixed.textColor = [UIColor colorFromHexString:@"#242424"];
    textfixed.tintColor = [UIColor colorFromHexString:@"#398BFF"];
    textfixed.delegate = self;
    textfixed.keyboardType = UIKeyboardTypeNumberPad;
    textfixed.text = [NSString stringWithFormat:@"%d",(int)[ToolsHelper getAutoTestOtaNumber]];
    [centerView addSubview:textfixed];
    [textfixed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.equalTo(centerView.mas_left).offset(24);
        make.right.equalTo(centerView.mas_right).offset(-24);
        make.height.offset(48);
    }];
    
    cancelBtn = [UIButton new];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:kJL_TXT("cancel") forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorFromHexString:@"#242424"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = FontMedium(15);
    [centerView addSubview:cancelBtn];
    
    confirmBtn = [UIButton new];
    [confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:kJL_TXT("confirm") forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorFromHexString:@"#398BFF"] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    confirmBtn.titleLabel.font = FontMedium(15);
    [centerView addSubview:confirmBtn];
    
    line0 = [UIImageView new];
    line0.backgroundColor = [UIColor colorFromHexString:@"#F5F5F5"];
    [centerView addSubview:line0];
    
    line1 = [UIImageView new];
    line1.backgroundColor = [UIColor colorFromHexString:@"#F5F5F5"];
    [centerView addSubview:line1];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerView.mas_bottom).offset(0);
        make.left.equalTo(centerView.mas_left).offset(0);
        make.right.equalTo(confirmBtn.mas_left).offset(0);
        make.width.equalTo(confirmBtn.mas_width);
        make.height.offset(50);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerView.mas_bottom).offset(0);
        make.right.equalTo(centerView.mas_right).offset(0);
        make.left.equalTo(cancelBtn.mas_right).offset(0);
        make.width.equalTo(cancelBtn.mas_width);
        make.height.offset(50);
    }];
    
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.equalTo(centerView.mas_left).offset(0);
        make.right.equalTo(centerView.mas_right).offset(0);
        make.bottom.equalTo(cancelBtn.mas_top).offset(0);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(1);
        make.left.equalTo(cancelBtn.mas_right).offset(0);
        make.bottom.equalTo(centerView.mas_bottom).offset(0);
        make.height.offset(50);
    }];
    
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeEdit)];
    [bgView addGestureRecognizer:tapges];
    
    
}

-(void)cancelBtnAction{
    self.hidden = YES;
    [textfixed endEditing:YES];
}

-(void)confirmBtnAction{
    int value = [textfixed.text intValue];
    if(value<1 || value > 999){
        [DFUITools showText:@"Between 1~999" onView:self.superview delay:2];
        if(value<1){
            value = 1;
        }
        if(value>999){
            value = 999;
        }
        [textfixed setText:[NSString stringWithFormat:@"%d",value]];
    }
    if(modelType == 0){
        [ToolsHelper setAutoTestOtaNumber:value];
    }else{
        [ToolsHelper setFaultTolerantTimes:value];
    }
    self.numberText = textfixed.text;
    self.hidden = YES;
    [textfixed endEditing:YES];
}


-(void)faultTolerant{
    modelType = 1;
    titleLab.text = kJL_TXT("fault_tolerant_times");
    textfixed.text = [NSString stringWithFormat:@"%d",(int)[ToolsHelper getFaultTolerantTimes]];
}
-(void)autoTest{
    modelType = 0;
    titleLab.text = kJL_TXT("test_number");
    textfixed.text = [NSString stringWithFormat:@"%d",(int)[ToolsHelper getAutoTestOtaNumber]];
}


-(void)closeEdit{
    [textfixed endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [ToolsHelper setAutoTestOtaNumber:[textfixed.text intValue]];
//    self.numberText = textfixed.text;
    [textfixed endEditing:YES];
    return true;
}


@end
