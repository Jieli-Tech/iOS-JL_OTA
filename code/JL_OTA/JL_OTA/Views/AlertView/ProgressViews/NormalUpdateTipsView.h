//
//  NormalUpdateTipsView.h
//  JL_OTA
//
//  Created by EzioChan on 2022/10/27.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NormalUpdateTipsView : UIView

@property(nonatomic,strong)UILabel *updateProgressLab;
@property(nonatomic,strong)UIProgressView *progressView;
@property(nonatomic,strong)UILabel *tipsLab;
@property(nonatomic,strong)UIActivityIndicatorView *activeView;

-(void)reConnect;
-(void)normalStatus;

@end

NS_ASSUME_NONNULL_END
