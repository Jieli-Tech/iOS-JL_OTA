//
//  PopoverViewCell.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/28.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "PopoverViewCell.h"
#import "Masonry.h"

@implementation PopoverViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.backgroundColor = [UIColor clearColor];
        self.mainLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.mainLabel];
        _mainLabel.adjustsFontSizeToFitWidth = YES;
        _mainLabel.font = FontMedium(14);
        _mainLabel.textColor = [UIColor whiteColor];
        _mainLabel.adjustsFontSizeToFitWidth = true;
        self.rightImgv = [[UIImageView alloc] init];
        [self.contentView addSubview:self.rightImgv];
        
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).inset(8);
            make.right.equalTo(self.rightImgv.mas_left).offset(-10);
        }];
        
        [self.rightImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.height.offset(20);
            make.right.equalTo(self.contentView).inset(8);
        }];
    }
    return self;
}


@end
