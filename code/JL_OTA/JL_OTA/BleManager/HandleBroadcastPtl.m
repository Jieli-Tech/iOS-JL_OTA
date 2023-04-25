//
//  HandleBroadcastPtl.m
//  JL_OTA
//
//  Created by EzioChan on 2023/1/30.
//  Copyright © 2023 Zhuhia Jieli Technology. All rights reserved.
//

#import "HandleBroadcastPtl.h"

@interface HandleBroadcastPtl()

@end

@implementation HandleBroadcastPtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegates = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    return self;
}

-(NSLock *)delegateLock{
    if (_delegateLock == nil) {
        _delegateLock = [NSLock new];
    }
    return _delegateLock;
}

-(void)addDelegate:(id)delegate{
    [self.delegateLock lock];
    if (![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
    [self.delegateLock unlock];
}
-(void)removeDelegate:(id)delegate{
    [self.delegateLock lock];
    if ([self.delegates containsObject:delegate]) {
        [self.delegates removeObject:delegate];
    }
    [self.delegateLock unlock];
}
-(void)removeAll{
    [self.delegateLock lock];
    [self.delegates removeAllObjects];
    [self.delegateLock unlock];
}

@end
