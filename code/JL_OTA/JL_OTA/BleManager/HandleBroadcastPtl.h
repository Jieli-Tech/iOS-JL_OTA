//
//  HandleBroadcastPtl.h
//  JL_OTA
//
//  Created by EzioChan on 2023/1/30.
//  Copyright © 2023 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HandleBroadcastPtl : NSObject
@property(nonatomic,strong,readonly)NSHashTable         *delegates;
@property(nonatomic,strong)NSLock                       *delegateLock;

-(void)addDelegate:(id)delegate;
-(void)removeDelegate:(id)delegate;
-(void)removeAll;
@end

NS_ASSUME_NONNULL_END
