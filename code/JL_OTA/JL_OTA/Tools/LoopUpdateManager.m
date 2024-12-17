//
//  LoopUpdateManager.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/13.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "LoopUpdateManager.h"
#import "JLBleManager.h"
#import "ToolsHelper.h"

@interface LoopUpdateManager(){
    NSMutableArray *updatePath;
    
}
@end

@implementation LoopUpdateManager

+(instancetype)share{
    static LoopUpdateManager *loopMgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loopMgr = [LoopUpdateManager new];
    });
    return loopMgr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        updatePath = [NSMutableArray new];
        self.info = [LoopInfo new];
    }
    return self;
}

-(BOOL)shouldLoopUpdate{
    if(updatePath.count>1) return YES;
    return NO;
}

-(void)cleanList{
    [updatePath removeAllObjects];
}




-(BOOL)startLoopUpdate:(NSArray *)filePaths{
    if(updatePath.count > 0){
        [self toNextUpdate];
        return YES;
    }
    
    self.reConnectUUID = [JLBleManager sharedInstance].mBlePeripheral.identifier.UUIDString;
    kJLLog(JLLOG_DEBUG, @"self.reConnectUUID:%@",self.reConnectUUID);
    _finishNumber = 0;
    NSInteger number = [ToolsHelper getAutoTestOtaNumber];
    if(number == 0){
        return NO;
    }
    int count = 0;
    while(count < number){
        for (NSString *path in filePaths) {
            NSString *filePath = [DFFile listPath:NSDocumentDirectory MiddlePath:@"upgrade" File:path];
            [updatePath addObject:filePath];
            count++;
            if (count == number){
                break;
            }
        }
    }
    kJLLog(JLLOG_DEBUG, @"auto update count:%d",updatePath.count);
    
    [[JLBleManager sharedInstance] otaFuncWithFilePath:updatePath.firstObject];
    
    self.info.name = [updatePath.firstObject lastPathComponent];
    
    self.info.nowIndexStr = [NSString stringWithFormat:@"%d/%d",(int)self.finishNumber+1,(int)number];
    return YES;
    
    
}



-(BOOL)toNextUpdate{
    
    if([ToolsHelper getFaultTolerant]){
        if([ToolsHelper getFaultTolerantTimes] > self.failedNumber){
            if(_status == DeviceOtaStatusPrepare || _status == DeviceOtaStatusFinish){
                @try {
                    [updatePath removeObjectAtIndex:0];
                } @catch (NSException *exception) {
                    kJLLog(JLLOG_DEBUG, @"自动升级队列为空");
                    return NO;
                } @finally {
                    
                }
            }
        }else{
            
        }
    }else{
        @try {
            [updatePath removeObjectAtIndex:0];
        } @catch (NSException *exception) {
            kJLLog(JLLOG_DEBUG, @"自动升级队列为空");
            return NO;
        } @finally {
            
        }
    }
   
    if([ToolsHelper isAutoTestOta] && updatePath.count > 0){
        kJLLog(JLLOG_DEBUG, @"toNextUpdate 剩余:%d 次", updatePath.count);
        [[JLBleManager sharedInstance] otaFuncWithFilePath:updatePath.firstObject];
        self.info.name = [updatePath.firstObject lastPathComponent];
        NSInteger max = [ToolsHelper getAutoTestOtaNumber];
        self.info.nowIndexStr = [NSString stringWithFormat:@"%d/%d",(int)_finishNumber+1,(int)max];
        return true;
    }
    return NO;
}

-(void)startLoopOta{
    if([ToolsHelper isAutoTestOta]){
        
        if([ToolsHelper isSupportHID]){
            [[JLBleManager sharedInstance] findHid:self.reConnectUUID];
        }else{
            [[JLBleManager sharedInstance] connectPeripheralWithUUID:self.reConnectUUID];
        }
    }
}



@end


@implementation LoopInfo



@end
