//
//  SettingTableViewCell.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/11.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "JLBleHandler.h"

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)switchChangeAction:(id)sender {
    BOOL bol = self.switchBtn.on;
    [DFTools setUser:[NSNumber numberWithBool:bol] forKey:self.saveKey];
    if([self.saveKey isEqualToString:@"ConnectBySDK"]){
        [[JLBleHandler share] handleDisconnect];
        [[NSNotificationCenter defaultCenter] postNotificationName:JL_BLE_CONNECTWAY_CHANGE object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_SWITCH_CELL" object:self.saveKey];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
