//
//  UpdateStatusCell.h
//  JL_OTA
//
//  Created by EzioChan on 2022/11/30.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UpdateStateCellPtl <NSObject>

-(void)updateStatusDidShowErrorMsg:(NSString *)msg;

-(void)updateStatusDidFinishWithCbp:(CBPeripheral *)cbp;

@end


@interface UpdateStatusCell : UIView

@property(nonatomic,strong)UILabel *mainLab;
@property(nonatomic,strong)UIProgressView *progress;
@property(nonatomic,strong)UILabel *proLab;
@property(nonatomic,strong)UIButton *statusBtn;
@property(nonatomic,weak)CBPeripheral *mainCbp;

@property(nonatomic,strong)NSString *deviceName;
@property(nonatomic,strong)NSString *updateName;

@property(nonatomic,weak)id<UpdateStateCellPtl> delegate;


@end

NS_ASSUME_NONNULL_END
