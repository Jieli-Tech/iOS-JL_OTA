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
    if(updatePath.count>0){
        [self toNextUpdate];
        return YES;
    }
    
    self.reConnectUUID = [JLBleManager sharedInstance].mBlePeripheral.identifier.UUIDString;
    NSLog(@"self.reConnectUUID:%@",self.reConnectUUID);
    _finishNumber = 0;
    NSInteger number = [ToolsHelper getAutoTestOtaNumber];
    if(number == 0){
        return NO;
    }
    int index = 0;
    for (int i = 0; i<number; i++) {
        if(index>(filePaths.count-1)){
            index = 0;
        }
        NSString *path = [DFFile listPath:NSDocumentDirectory MiddlePath:@"upgrade" File:filePaths[index]];
        index+=1;
        [updatePath addObject:path];
        
    }
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
                    NSLog(@"自动升级队列为空");
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
            NSLog(@"自动升级队列为空");
            return NO;
        } @finally {
            
        }
    }
   
    if([ToolsHelper isAutoTestOta] && updatePath.count>0){
        
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
