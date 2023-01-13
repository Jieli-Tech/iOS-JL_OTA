//
//  TipsProgressView.h
//  JL_OTA
//
//  Created by EzioChan on 2022/10/11.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TipsProgressView : UIView

-(void)setWithOtaResult:(JL_OTAResult)result withProgress:(float)progress;

-(void)timeOutShow;
@end

NS_ASSUME_NONNULL_END
