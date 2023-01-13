//
//  JLBaseViewController.m
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/12.
//

#import "JLBaseViewController.h"


@interface JLBaseViewController ()

@end

@implementation JLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:@"#F4F7FB"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    if(@available(iOS 15.0, *)) {
        //设置导航颜色
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor whiteColor];
        //设置标题字体颜色
        [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkTextColor], NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:18]}];
        //去掉导航栏线条
        appearance.shadowColor= [UIColor clearColor];
    }
}

#pragma mark - Public Methods
- (void)startLoadingView:(NSString*)text Delay:(NSTimeInterval)delay {
    [_loadingTip hide:YES ];
    _loadingTip = [DFUITools showHUDWithLabel:text onView:self.view color:[UIColor blackColor] labelTextColor:[UIColor whiteColor] activityIndicatorColor:[UIColor whiteColor]];
    [_loadingTip hide:YES afterDelay:delay];
}

- (void)hideLoadingView {
    [_loadingTip hide:YES];
}

@end
