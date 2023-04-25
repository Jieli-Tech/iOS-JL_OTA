//
//  SingleDataSender.h
//  JL_OTA
//
//  Created by EzioChan on 2023/3/8.
//  Copyright © 2023 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_BLEKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SingleSendDelegate <NSObject>

-(void)singleDidSendData:(NSData *)data;

@end

@interface SingleDataSender : ECOneToMorePtl

+(instancetype)share;

-(void)appendSend:(NSData *)data;

-(void)sendSingle;

@end

NS_ASSUME_NONNULL_END
