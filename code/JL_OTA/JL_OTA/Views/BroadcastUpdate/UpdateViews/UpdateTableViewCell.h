//
//  UpdateTableViewCell.h
//  JL_OTA
//
//  Created by EzioChan on 2022/11/29.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface UpdateObjc : NSObject

@property(nonatomic,strong)JLDeviceInfo *info;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,strong)NSString *updatePath;
@property(nonatomic,assign)BOOL needUpdate;

@end

@protocol updateTableCellDelegate <NSObject>

-(void)updateDidSelectWithIndex:(NSInteger)index;

-(void)updateDidStartSelectUfw:(NSInteger)index;

@end

@interface UpdateTableViewCell : UITableViewCell

@property(nonatomic,weak)id<updateTableCellDelegate> delegate;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel *mainLab;
@property(nonatomic,strong)UIImageView *statusImgv;
@property(nonatomic,strong)UILabel *detailLab;
@property(nonatomic,strong)UIButton *selectFileBtn;
@property(nonatomic,strong)UIButton *chooseBtn;

@end

NS_ASSUME_NONNULL_END
