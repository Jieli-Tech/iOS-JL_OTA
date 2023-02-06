//
//  NoFileView.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/28.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "NoFileView.h"


@interface NoFileView ()

@property(nonatomic,strong)UIImageView *imgv;
@property(nonatomic,strong)UILabel *label1;
@property(nonatomic,strong)UILabel *label2;

@end

@implementation NoFileView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _imgv = [UIImageView new];
        _imgv.image = [UIImage imageNamed:@"img_01"];
        [self addSubview:_imgv];
        _label1 = [UILabel new];
        _label1.textAlignment = NSTextAlignmentCenter;
        _label1.text = kJL_TXT("no_ufw_file");
        _label1.textColor = [UIColor colorFromHexString:@"#242424"];
        _label1.font = FontMedium(15);
        [self addSubview:_label1];
        
        _label2 = [UILabel new];
        _label2.textAlignment = NSTextAlignmentCenter;
        _label2.text = kJL_TXT("please_upload_ufw");
        _label2.textColor = [UIColor colorFromHexString:@"#808080"];
        _label2.font = FontMedium(14);
        [self addSubview:_label2];
        
        
        [_imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).inset(10);
            make.centerX.equalTo(self);
            make.width.offset(200);
            make.height.offset(138);
        }];
        
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imgv.mas_bottom).offset(18);
            make.centerX.equalTo(self);
            make.height.offset(24);
        }];
        
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label1.mas_bottom).offset(5);
            make.centerX.equalTo(self);
            make.height.offset(25);
        }];
    
    }
    return self;
}

@end
