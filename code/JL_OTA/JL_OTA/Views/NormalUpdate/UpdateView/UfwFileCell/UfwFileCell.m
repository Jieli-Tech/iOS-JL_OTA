//
//  UfwFileCell.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/8.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "UfwFileCell.h"

@implementation UfwFileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsLinked:(BOOL)isLinked {
    if (isLinked) {
        _selectedImgv.image = [UIImage imageNamed:@"selected"];
    } else {
        _selectedImgv.image = [UIImage imageNamed:@"icon_choose_nol"];
    }
}


@end
