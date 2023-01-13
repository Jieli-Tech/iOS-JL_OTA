//
//  JLBleHandler.h
//  JL_OTA
//
//  Created by EzioChan on 2022/10/12.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLBleManager.h"
#import "JL_RunSDK.h"

NS_ASSUME_NONNULL_BEGIN


@protocol JLBleHandlDelegate <NSObject>

@required
/**
 *  ota升级过程状态回调
 */
- (void)otaProgressOtaResult:(JL_OTAResult)result withProgress:(float)progress;

@end

@interface JLBleHandler : NSObject

@property(nonatomic,weak)id<JLBleHandlDelegate> delegate;

+(instancetype)share;

-(BOOL)isConnected;

-(BOOL)handleGetBleStatus;

-(BOOL)handleWeatherNeedUpdate;

-(NSString *)handleDeviceNowUUID;

-(void)handleScanDevice;

-(void)handleStopScanDevice;

-(void)handleDisconnect;

-(void)handleReconnectByMac;

-(void)handleReconnectByUUID;

-(void)handleConnectWithUUID:(NSString *)uuid;

- (void)handleOtaFuncWithFilePath:(NSString *)otaFilePath;

-(void)handleOtaCancelUpdate:(void(^)(JL_CMDStatus status))block;

+(NSString *)deviceType;

@end

NS_ASSUME_NONNULL_END
