//
//  UfwSelectView.h
//  JL_OTA
//
//  Created by EzioChan on 2022/11/29.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLBleEntity.h"

NS_ASSUME_NONNULL_BEGIN

@class UfwSelectView;

@protocol UfwSelectPtl <NSObject>

-(void)ufwSelectViewDelegate:(UfwSelectView *)ufwSwr;

@end

@interface UfwSelectView : UIView


@property(nonatomic,strong)NSString *updatePath;
@property(nonatomic,strong)JLBleEntity *entity;
@property(nonatomic,weak)id<UfwSelectPtl> delegate;

@end

NS_ASSUME_NONNULL_END
