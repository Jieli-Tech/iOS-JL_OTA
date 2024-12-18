//
//  SettingTableViewCell.h
//  JL_OTA
//
//  Created by EzioChan on 2022/10/11.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainLab;
@property (weak, nonatomic) IBOutlet UILabel *endLab;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (strong,nonatomic) NSString *saveKey;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endLeftLayout;

@end

NS_ASSUME_NONNULL_END
