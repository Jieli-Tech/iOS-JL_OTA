//
//  JLDeviceCell.h
//  OTA_Update
//
//  Created by DFung on 2019/8/21.
//  Copyright © 2019 DFung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DFUnits/DFUnits.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLDeviceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *subImage;
@property (assign, nonatomic) BOOL isLinked;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;

@end

NS_ASSUME_NONNULL_END
