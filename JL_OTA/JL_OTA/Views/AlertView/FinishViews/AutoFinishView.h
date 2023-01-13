//
//  AutoFinishView.h
//  JL_OTA
//
//  Created by EzioChan on 2022/10/27.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface AutoFinishView : UIView

@property(nonatomic,strong)UILabel *autoLab;
@property(nonatomic,strong)UILabel *errorLab;
@property(nonatomic,strong)UILabel *testNumberLab;
@property(nonatomic,strong)UIImageView *finishImgv;
@property(nonatomic,strong)UILabel *updateFinishLab;
@property(nonatomic,strong)UIButton *confirmBtn;
@property(nonatomic,assign)BOOL hiddOrNot;

-(void)failedStatus;

-(void)successStatus;


@end

NS_ASSUME_NONNULL_END
