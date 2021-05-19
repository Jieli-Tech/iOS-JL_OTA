//
//  ItemCell.m
//  OTA_Update
//
//  Created by DFung on 2019/8/21.
//  Copyright © 2019 DFung. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)init
{
    self = [DFUITools loadNib:@"ItemCell"];
    if (self) {
        
    }
    return self;
}

+(NSString*)ID{
    return @"ITEMCELL";
}

- (void)setIsLinked:(BOOL)isLinked{
    if (isLinked) {
        _subImage.image = [UIImage imageNamed:@"xuanzhong"];
    }else{
        _subImage.image = [UIImage imageNamed:@"weixuanzhong"];
    }
}


@end
