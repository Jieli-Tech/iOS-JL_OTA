//
//  OneVC.h
//  QCY_Demo
//
//  Created by 杰理科技 on 2020/3/17.
//  Copyright © 2020 杰理科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DFUnits/DFUnits.h>
#import <JL_BLEKit/JL_BLEKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OneVC : UIViewController
@property(nonatomic,assign)BOOL bt_status_phone;            //手机蓝牙是否开启
@property(nonatomic,assign)BOOL bt_status_connect;          //设备是否连接
@end

NS_ASSUME_NONNULL_END
