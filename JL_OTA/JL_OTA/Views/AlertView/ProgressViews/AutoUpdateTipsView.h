//
//  AutoUpdateTipsView.h
//  JL_OTA
//
//  Created by EzioChan on 2022/10/26.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AutoUpdateTipsView : UIView

@property(nonatomic,strong)UILabel *updateProgressLab;
@property(nonatomic,strong)UIProgressView *progressView;
@property(nonatomic,strong)UIActivityIndicatorView *activeView;
@property(nonatomic,strong)UILabel *tipsLab;
@property(nonatomic,strong)UILabel *detailLab;
@property(nonatomic,strong)UILabel *autoLab;

-(void)reConnect;
-(void)normalStatus;

-(void)reConnectByAutoUpdate;

@end

NS_ASSUME_NONNULL_END
