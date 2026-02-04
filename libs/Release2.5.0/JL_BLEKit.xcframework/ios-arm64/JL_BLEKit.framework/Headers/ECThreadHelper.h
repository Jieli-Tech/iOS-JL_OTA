//
//  ECThreadHelper.h
//  JL_BLEKit
//
//  Created by EzioChan on 2023/11/20.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ECThreadHelperPtl <NSObject>

-(void)startAction:(id)objc;
-(void)finishThreadTaskAction;

@end

typedef void(^EcThreadAction)(id objc);

@interface ECThreadHelper : NSObject


@property (nonatomic, weak) id<ECThreadHelperPtl> delegate;

@property (nonatomic, copy) EcThreadAction action;

+(instancetype)share;

-(instancetype)init;

-(void)addTask:(id<NSCopying>)any;

-(void)nextTask;

-(void)clean;

@end

NS_ASSUME_NONNULL_END
