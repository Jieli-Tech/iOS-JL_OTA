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

/// 是否支持多媒体(视频/GIF）
/// is support medias
@property(nonatomic, assign) BOOL isSupportMedias;

/// 最大帧率(当支持多媒体时才有意义）
/// max fps
@property(nonatomic, assign) NSInteger maxFPS;

/// 最大时长
/// max duration
@property(nonatomic, assign) NSInteger maxDuration;

/// 是否支持动画 ani 格式
/// is support animation
@property(nonatomic, assign) BOOL isSupportAni;

/// 是否支持视频 avi 格式
@property(nonatomic, assign) BOOL isSupportAvi;

/// 是否支持 Gif 格式
/// is support gif
@property(nonatomic, assign) BOOL isSupportGif;


/// 初始化
/// initialize
/// - Parameter data: 数据 data
/// - Returns: 实例
-(instancetype)initWithData:(NSData *)data Manager:(JL_ManagerM*)manager;

@end

NS_ASSUME_NONNULL_END
