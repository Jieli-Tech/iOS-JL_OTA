//
//  UITableViewCell+JLCustom.m
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/11.
//

#import "UITableViewCell+JLCustom.h"

@implementation UITableViewCell (JLCustom)

- (void)setCustomStyle {
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.font = [UIFont systemFontOfSize:14.0];
    self.tintColor = [UIColor blueColor];
    self.backgroundColor = [UIColor whiteColor];
}

@end
