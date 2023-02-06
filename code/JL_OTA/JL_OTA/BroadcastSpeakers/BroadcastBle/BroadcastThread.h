//
//  BroadcastThread.h
//  JL_OTA
//
//  Created by EzioChan on 2022/11/24.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_BLEKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BroadcastOtaInfo : NSObject

@property(nonatomic,strong)CBPeripheral *cbp;

@property(nonatomic,strong)NSString *updatePath;

@end


@protocol OtaUpdatePtl <NSObject>

-(void)otaResult:(CBPeripheral *)cbp Status:(JL_OTAResult)result Progress:(float) progress;
-(void)otaResult:(CBPeripheral *)cbp Old:(CBPeripheral *)oldCbp Status:(JL_OTAResult)result Progress:(float) progress;
-(void)otaResultIsBegin:(CBPeripheral *)cbp;

@end



@interface BroadcastThread : ECOneToMorePtl

+(instancetype)share;

-(void)startOta:(NSArray <BroadcastOtaInfo*>*)items;

-(void)otaUpdateStepII:(NSString *)mac Info:(CBPeripheral*)cbp;

-(void)next;


@end

NS_ASSUME_NONNULL_END
