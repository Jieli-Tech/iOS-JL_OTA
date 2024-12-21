//
//  JLDialInfoExtentedModel.h
//  JL_BLEKit
//
//  Created by EzioChan on 2024/2/20.
//  Copyright © 2024 www.zh-jieli.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JL_ManagerM;

/// 设备表盘拓展信息
/// device dial information extended model
@interface JLDialInfoExtentedModel : NSObject


/// 屏幕形状
/// shape of screen
/// 默认形状 0x01
/// default 0x01 circular
/// 0x01 - 圆形 circular
/// 0x02 - 矩形 rectangle
/// 0x03 - 圆角矩形 rounded rectangle
@property(nonatomic, assign) uint8_t shape;


/// 圆形半径
/// radius of circle
@property(nonatomic, assign) CGFloat radius;

/// 背景颜色
/// background color
/// default is clean color
@property(nonatomic, strong) UIColor *backgroundColor;

/// 屏幕尺寸
/// 此项默认值为（240 * 240）
/// default is (240 * 240)
/// device screen sice
@property(nonatomic, assign) CGSize size;


/// 初始化
/// initialize
/// - Parameter data: 数据 data
/// - Returns: 实例
-(instancetype)initWithData:(NSData *)data Manager:(JL_ManagerM*)manager;

@end

NS_ASSUME_NONNULL_END
