//
//  TipsFinishView.h
//  JL_OTA
//
//  Created by EzioChan on 2022/10/11.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    JLTipsNormal,
    JLTipsAuto,
} JLTipsViewType;

@interface TipsFinishView : UIView

-(instancetype)init:(JLTipsViewType) type;

-(void)succeed;

-(void)failed:(JL_OTAResult)result;

@end

NS_ASSUME_NONNULL_END
