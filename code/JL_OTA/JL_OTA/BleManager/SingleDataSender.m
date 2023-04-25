//
//  SingleDataSender.m
//  JL_OTA
//
//  Created by EzioChan on 2023/3/8.
//  Copyright © 2023 Zhuhia Jieli Technology. All rights reserved.
//

#import "SingleDataSender.h"


@interface SingleDataSender(){
    dispatch_semaphore_t semaphore;
    dispatch_queue_t sendQueue;
    NSMutableArray *sendDataArray;
    NSLock *lock;
}
@end

@implementation SingleDataSender


+(instancetype)share{
    static SingleDataSender *sender;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sender = [[SingleDataSender alloc] init];
    });
    return sender;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        sendDataArray = [NSMutableArray new];
        semaphore = dispatch_semaphore_create(1);
        sendQueue = dispatch_queue_create("sendqueue.jlota", NULL);
        lock = [NSLock new];
        dispatch_async(sendQueue, ^{
            [self sendQueueAction];
        });
    }
    return self;
}

-(void)appendSend:(NSData *)data{
    
    NSData *dt = [data mutableCopy];
    [lock lock];
    [sendDataArray addObject:dt];
    [lock unlock];
    if (sendDataArray.count == 1){
        [self sendSingle];
    }
}


-(void)sendQueueAction{
    while (1) {
        if(sendDataArray.count>=1){
            [lock lock];
            NSData *data = sendDataArray[0];
            dispatch_async(dispatch_get_main_queue(), ^{
                for (id<SingleSendDelegate>objc in self.delegates) {
                    [objc singleDidSendData:data];
                }
            });
            [sendDataArray removeObjectAtIndex:0];
            [lock unlock];
        }else{
            NSLog(@"single wait:%d",(int)sendDataArray.count);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    }
}

-(void)sendSingle{
    
    dispatch_semaphore_signal(semaphore);
    NSLog(@"single send");
    
}


@end
