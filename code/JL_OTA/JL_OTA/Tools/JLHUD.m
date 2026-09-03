//
//  JLHUD.m
//  JL_OTA
//
//  Created by JL_OTA on 2026/9/3.
//

#import "JLHUD.h"

static NSInteger const kJLToastTag = 0x5A5A01;

@implementation JLHUD

+ (instancetype)showHUDWithLabel:(NSString *)labelText
                          onView:(UIView *)view
                           color:(UIColor *)color
                  labelTextColor:(UIColor *)textColor
          activityIndicatorColor:(UIColor *)actIndicatorColor {
    if (view == nil) return nil;

    CGSize hudSize = CGSizeMake(120, 100);
    JLHUD *hud = [[JLHUD alloc] initWithFrame:CGRectMake(0, 0, hudSize.width, hudSize.height)];
    hud.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    hud.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                           UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    hud.layer.cornerRadius = 8.0;
    hud.layer.masksToBounds = YES;
    hud.backgroundColor = color ? [color colorWithAlphaComponent:0.8] : [[UIColor blackColor] colorWithAlphaComponent:0.8];

    UIActivityIndicatorView *indicator =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.color = actIndicatorColor ?: [UIColor whiteColor];
    indicator.center = CGPointMake(hudSize.width / 2.0, 32);
    indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [indicator startAnimating];
    [hud addSubview:indicator];

    if (labelText.length > 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(6, 56, hudSize.width - 12, 34)];
        label.text = labelText;
        label.textColor = textColor ?: [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [hud addSubview:label];
    }

    [view addSubview:hud];
    return hud;
}

+ (void)showText:(NSString *)text onView:(UIView *)view delay:(NSTimeInterval)time {
    if (view == nil || text.length == 0) return;

    dispatch_async(dispatch_get_main_queue(), ^{
        // 同一 view 上旧的 toast 先移除，避免叠加
        UIView *old = [view viewWithTag:kJLToastTag];
        if (old) [old removeFromSuperview];

        UILabel *toast = [[UILabel alloc] init];
        toast.tag = kJLToastTag;
        toast.text = text;
        toast.textColor = [UIColor whiteColor];
        toast.font = [UIFont systemFontOfSize:14];
        toast.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
        toast.textAlignment = NSTextAlignmentCenter;
        toast.numberOfLines = 0;
        toast.layer.cornerRadius = 6.0;
        toast.layer.masksToBounds = YES;

        CGFloat maxWidth = CGRectGetWidth(view.bounds) - 60;
        CGFloat toastWidth = MIN(maxWidth, 220);
        CGSize size = [text boundingRectWithSize:CGSizeMake(toastWidth - 24, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName : toast.font}
                                         context:nil].size;
        toast.frame = CGRectMake(0, 0, ceil(size.width) + 24, ceil(size.height) + 16);
        toast.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));

        toast.alpha = 0;
        [view addSubview:toast];
        [UIView animateWithDuration:0.25 animations:^{
            toast.alpha = 1.0;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    toast.alpha = 0;
                } completion:^(BOOL finished2) {
                    [toast removeFromSuperview];
                }];
            });
        }];
    });
}

- (void)hide:(BOOL)animated {
    [self removeFromSuperview];
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

@end
