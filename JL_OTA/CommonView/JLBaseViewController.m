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
    // Do any additional setup after loading the view.
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
