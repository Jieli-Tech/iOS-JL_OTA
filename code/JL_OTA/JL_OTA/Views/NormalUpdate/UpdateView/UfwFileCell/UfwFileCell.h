//
//  UfwFileCell.h
//  JL_OTA
//
//  Created by EzioChan on 2022/10/8.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UfwFileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *centerImgv;
@property (weak, nonatomic) IBOutlet UILabel *mainLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImgv;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;

@property (assign, nonatomic) BOOL isLinked;
@end

NS_ASSUME_NONNULL_END
