//
//  LoopUpdateManager.h
//  JL_OTA
//
//  Created by EzioChan on 2022/10/13.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, DeviceOtaStatus) {
    DeviceOtaStatusPrepare,//第一阶段，数据头以及信息校对
    DeviceOtaStatusStepI,//下载Loader阶段
    DeviceOtaStatusStepII,//处于Loader阶段，等待回连完成升级
    DeviceOtaStatusFinish
};

NS_ASSUME_NONNULL_BEGIN

@interface LoopInfo : NSObject

@property(strong,nonatomic)NSString *nowIndexStr;

@property(strong,nonatomic)NSString *name;

@end

@interface LoopUpdateManager : NSObject

@property(nonatomic,strong)NSString *reConnectUUID;

@property(nonatomic,strong)LoopInfo *info;

@property(nonatomic,assign)NSInteger finishNumber;

@property(nonatomic,assign)DeviceOtaStatus status;

@property(nonatomic,strong)NSString *reConnectMac;

@property(nonatomic,assign)NSInteger failedNumber;

+(instancetype)share;

-(BOOL)toNextUpdate;

-(BOOL)startLoopUpdate:(NSArray *)filePaths;

-(void)startLoopOta;

-(BOOL)shouldLoopUpdate;

-(void)cleanList;



@end




NS_ASSUME_NONNULL_END
