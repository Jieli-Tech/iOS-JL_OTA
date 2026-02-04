//
//  SettingTableViewCell.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/11.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "JLBleHandler.h"
#import "ServiceUUIDInputVC.h"
#import "ToolsHelper.h"

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)switchChangeAction:(id)sender {
    BOOL bol = self.switchBtn.on;
    if ([self.saveKey isEqualToString:@"GattOverEdr"]) {
        if (bol) {
            NSArray *uuids = [ToolsHelper getGattServuceUUIDs];
            ServiceUUIDInputVC *vc = [[ServiceUUIDInputVC alloc] initWithInitialUUIDs:uuids];
            vc.onSave = ^(NSArray<NSString *> *uuids) {
                [ToolsHelper setGattServuceUUIDs:uuids];
                self.switchBtn.on = YES;
                [ToolsHelper setGattOverEdr:YES];
            };
            vc.onCancel = ^{
                NSArray *uuids = [ToolsHelper getGattServuceUUIDs];
                if (uuids.count <= 0) {
                    self.switchBtn.on = NO;
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kJL_TXT("gatt_uuid_error_title") message:kJL_TXT("gatt_uuid_error_message") preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:kJL_TXT("ok_button") style:UIAlertActionStyleDefault handler:nil]];
                    [self.weakVc presentViewController:alert animated:YES completion:nil];
                    [ToolsHelper setGattOverEdr:NO];
                }
            };
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.weakVc presentViewController:vc animated:YES completion:nil];
            
        }else{
            [ToolsHelper setGattOverEdr:bol];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_SWITCH_CELL" object:self.saveKey];
        return;
    }
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
