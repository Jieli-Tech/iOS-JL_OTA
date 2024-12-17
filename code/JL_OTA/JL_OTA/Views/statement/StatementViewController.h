//
//  StatementViewController.h
//  JL_OTA
//
//  Created by 李放 on 2024/11/23.
//  Copyright © 2024 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol StatementViewControllerDelegate <NSObject>

-(void)confirmCancelBtnAction;
-(void)confirmDidSelect:(int)index;
-(void)confirmConfirmBtnAction;

@end

@interface StatementViewController : UIViewController

@property (weak, nonatomic) id<StatementViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
