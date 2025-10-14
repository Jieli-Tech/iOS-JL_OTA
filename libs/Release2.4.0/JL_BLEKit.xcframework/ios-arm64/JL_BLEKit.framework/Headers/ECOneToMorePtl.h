//
//  ECOneToMorePtl.h
//  JL_BLEKit
//
//  Created by EzioChan on 2021/10/27.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+ToUnit.h"
#import "JL_ManagerM.h"

NS_ASSUME_NONNULL_BEGIN

@interface ECOneToMorePtl : NSObject

@property(nonatomic,strong,readonly)NSHashTable         *delegates;
@property(nonatomic,strong)NSLock                       *delegateLock;

-(void)addDelegate:(id)delegate;
-(void)removeDelegate:(id)delegate;
-(void)removeAll;
-(void)inputPKG:(JL_PKG*)pkg;
-(void)inputPKG:(JL_PKG *)pkg Manager:(JL_ManagerM *)mgr;

@end

NS_ASSUME_NONNULL_END
