//
//  FittingView.h
//  JL_OTA
//
//  Created by EzioChan on 2022/10/8.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FittingView : UIView

@property(nonatomic,strong)NSString *fitterKey;

+(void)saveFitterKey:(NSString *)fitter;

+(NSString *)getFitterKey;

@end

NS_ASSUME_NONNULL_END
