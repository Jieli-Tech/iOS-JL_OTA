//
//  UpdateTableViewCell.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/29.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "UpdateTableViewCell.h"

@interface UpdateTableViewCell()



@property(nonatomic,strong)UIView *centerView;
@end

@implementation UpdateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        _centerView = [UIView new];
        _centerView.backgroundColor = [UIColor whiteColor];
        _centerView.layer.cornerRadius = 6.0;
        _centerView.layer.masksToBounds = true;
        [self.contentView addSubview:_centerView];
        
        _mainLab = [UILabel new];
        _mainLab.font = FontMedium(17);
        _mainLab.textColor = [UIColor colorFromHexString:@"#242424"];
        [_centerView addSubview:_mainLab];
        
        _statusImgv = [UIImageView new];
        _statusImgv.image = [UIImage imageNamed:@"icon_file_02"];
        [_centerView addSubview:_statusImgv];
        
        _detailLab = [UILabel new];
        _detailLab.font = FontMedium(13);
        _detailLab.textColor  = [UIColor colorFromHexString:@"#BBBBBB"];
        _detailLab.adjustsFontSizeToFitWidth = true;
        _detailLab.numberOfLines = 0;
        [_centerView addSubview:_detailLab];
        
        _chooseBtn = [UIButton new];
        [_chooseBtn setImage:[UIImage imageNamed:@"icon_choose_02_nol"] forState:UIControlStateNormal];
        [_chooseBtn addTarget:self action:@selector(chooseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_centerView addSubview:_chooseBtn];
        
        _selectFileBtn = [UIButton new];
        [_selectFileBtn setTitle:kJL_TXT("file_select") forState:UIControlStateNormal];
        _selectFileBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_selectFileBtn setTitleColor:[UIColor colorFromHexString:@"#398BFF"] forState:UIControlStateNormal];
        [_selectFileBtn setTitleColor:[UIColor colorFromHexString:@"#949494"] forState:UIControlStateHighlighted];
        [_selectFileBtn addTarget:self action:@selector(selectBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_centerView addSubview:_selectFileBtn];
        
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView).inset(8);
            make.left.right.equalTo(self.contentView).inset(16);
        }];
        
        [_mainLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_centerView.mas_left).offset(20);
            make.right.equalTo(_chooseBtn.mas_left).offset(-20);
            make.top.equalTo(_centerView.mas_top).offset(12);
            make.height.offset(26);
        }];
        
        [_statusImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_centerView).offset(20);
            make.bottom.equalTo(_centerView.mas_bottom).offset(-17);
            make.width.height.offset(16);
        }];
        
        [_selectFileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_centerView.mas_right).offset(-16);
            make.height.offset(26);
            make.bottom.equalTo(_centerView.mas_bottom).offset(-12);
        }];
        
        [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_statusImgv.mas_right).offset(8);
            make.right.equalTo(_selectFileBtn.mas_left).offset(-10);
            make.height.offset(26);
            make.bottom.equalTo(_centerView.mas_bottom).offset(-12);
        }];
        
        
        [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_centerView).offset(12);
            make.right.equalTo(_centerView.mas_right).offset(-16);
            make.height.width.offset(26);
        }];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
}




-(void)chooseBtnAction{
    if([_delegate respondsToSelector:@selector(updateDidSelectWithIndex:)]){
        [_delegate updateDidSelectWithIndex:self.index];
    }
}

-(void)selectBtnAction{
    if([_delegate respondsToSelector:@selector(updateDidStartSelectUfw:)]){
        [_delegate updateDidStartSelectUfw:self.index];
    }
}


@end

@implementation UpdateObjc



@end
