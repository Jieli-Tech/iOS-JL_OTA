//
//  PopoverView.h
//  JL_OTA
//
//  Created by EzioChan on 2022/11/4.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadView.h"
#import "ScanQRCodeVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PopoverType) {
    PopoverTypeAdd,
    PopoverTypeBrowseCast,
};

@interface PopoverView : UIView

@property(nonatomic,assign)NSInteger selectIndex;
@property(nonatomic,assign)PopoverType type;

@property(nonatomic,strong)NSArray *itemList;
@property(nonatomic,strong)NSArray *imageList;
@property(nonatomic,strong)UITableView *listTable;
@property(nonatomic,strong)UIImage *popBgImg;


@end

NS_ASSUME_NONNULL_END
