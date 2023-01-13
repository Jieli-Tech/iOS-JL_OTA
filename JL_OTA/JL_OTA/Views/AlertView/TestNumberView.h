//
//  TestNumberView.h
//  JL_OTA
//
//  Created by EzioChan on 2022/10/12.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestNumberView : UIView

@property(nonatomic,strong)NSString *numberText;

-(void)autoTest;

-(void)faultTolerant;

@end

NS_ASSUME_NONNULL_END
