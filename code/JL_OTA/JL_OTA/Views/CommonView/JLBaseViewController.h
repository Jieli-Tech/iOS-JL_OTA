//
//  JLBaseViewController.h
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/12.
//

#import <UIKit/UIKit.h>
#import "JLHUD.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "Colours.h"



NS_ASSUME_NONNULL_BEGIN

@interface JLBaseViewController : UIViewController

@property (strong, nonatomic) JLHUD *loadingTip;

- (void)startLoadingView:(NSString*)text Delay:(NSTimeInterval)delay;
- (void)hideLoadingView;

@end

NS_ASSUME_NONNULL_END
