//
//  JLHUD.h
//  JL_OTA
//
//  Created by JL_OTA on 2026/9/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 轻量 HUD（替代原 DFUITools/DFTips 的 loading 与 toast）
@interface JLHUD : UIView

/// 显示带文字的 loading 指示器（黑底白字圆角视图，挂到 onView 上）
+ (instancetype)showHUDWithLabel:(NSString *)labelText
                          onView:(UIView *)view
                           color:(UIColor *)color
                  labelTextColor:(UIColor *)textColor
          activityIndicatorColor:(UIColor *)actIndicatorColor;

/// 显示文字 toast（onView 居中，delay 秒后消失）
+ (void)showText:(NSString *)text onView:(UIView *)view delay:(NSTimeInterval)time;

/// 隐藏（带动画与否均可）
- (void)hide:(BOOL)animated;

/// 延时隐藏
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
