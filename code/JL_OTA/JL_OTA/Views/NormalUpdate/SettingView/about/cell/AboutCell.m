//
//  AboutCell.m
//  JL_OTA
//
//  Created by 李放 on 2024/11/23.
//  Copyright © 2024 Zhuhia Jieli Technology. All rights reserved.
//

#import "AboutCell.h"

@interface AboutCell(){
    UIView *bgview;
}
@end

@implementation AboutCell

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       self.backgroundColor = [UIColor clearColor];
       
       bgview = [[UIView alloc] init];
       [self.contentView addSubview:bgview];
       
       self.mFuncName = [[UILabel alloc] init];
       self.mFuncName.numberOfLines = 1;
       self.mFuncName.textColor = kDF_RGBA(36, 36, 36, 1);
       self.mFuncName.font = FontMedium(15);
       
       UIButton *nextBtn = [UIButton new];
       [nextBtn setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
       
       [bgview addSubview:self.mFuncName];
       [bgview addSubview:nextBtn];
       
       [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
           make.height.mas_equalTo(48);
       }];
       
       [self.mFuncName mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(bgview).offset(14);
           make.left.equalTo(bgview).offset(20);
       }];
       
       [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(bgview).offset(16);
           make.right.equalTo(bgview).offset(-20);
       }];
   }
   return self;
}

@end

