//
//  BroadcastThread.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/24.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "BroadcastThread.h"
#import "DeviceManager.h"
#import "BroadcastBleManager.h"

@interface BroadcastThread()

@property(nonatomic,strong)NSMutableDictionary *reconnectDict;
@property(nonatomic,strong)dispatch_queue_t senderThread;


@property(nonatomic,strong)NSMutableArray *verifyList;
@property(nonatomic,assign)NSInteger maxVerify;
@end

@implementation BroadcastThread

+(instancetype)share{
    static BroadcastThread *bt;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bt = [[BroadcastThread alloc] init];
    });
    return bt;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _reconnectDict = [NSMutableDictionary new];
        self.senderThread = dispatch_queue_create("ota_thread", NULL);
        self.verifyList = [NSMutableArray new];
        
    }
    return self;
}


-(void)next{
    self.maxVerify--;
    if(self.verifyList.count>0){
        BroadcastOtaInfo *objc = self.verifyList[0];
        [self threadRun:objc];
        [self.verifyList removeObject:objc];
    }
}


-(void)startOta:(NSArray <BroadcastOtaInfo*>*)items{
    
    self.verifyList = [NSMutableArray new];
    self.maxVerify = 1;
    
    for (BroadcastOtaInfo *objc in items) {
        if(self.maxVerify>1){
            [self.verifyList addObject:objc];
        }else{
            [self threadRun:objc];
        }

    }
    
}


-(void)threadRun:(BroadcastOtaInfo *)info{
    
    self.maxVerify++;
    JLDeviceInfo *device = [[DeviceManager share] checkoutWith:info.cbp];

    JL_Assist *assist = [[BroadcastBleManager sharedInstance] assistDicts][info.cbp.identifier.UUIDString];
    
    for (id<OtaUpdatePtl>item in self.delegates) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([item respondsToSelector:@selector(otaResultIsBegin:)]){
                [item otaResultIsBegin:info.cbp];
            }
        });
    }
    
    if(info){
        __weak typeof(self) wself = self;
        NSData *data = [NSData dataWithContentsOfFile:info.updatePath];
        if(assist == nil){
            for (id<OtaUpdatePtl>objc in self.delegates) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([objc respondsToSelector:@selector(otaResult:Status:Progress:)]){
                        [objc otaResult:info.cbp Status:JL_OTAResultFailTWSDisconnect Progress:0.0];
                    }
                });
            }
            NSLog(@"assist is null");
            return;
        }
        [assist.mCmdManager.mOTAManager cmdOTAData:data Result:^(JL_OTAResult result, float progress) {
            
            for (id<OtaUpdatePtl>objc in self.delegates) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([objc respondsToSelector:@selector(otaResult:Status:Progress:)]){
                        [objc otaResult:info.cbp Status:result Progress:progress];
                    }
                });
            }
            
            
            //NSLog(@"cbp:%@ ,progress:%f",info.cbp.identifier.UUIDString,progress);
            
            if(result == JL_OTAResultReconnectWithMacAddr){
                JLModel_Device *dev = [device.manager outputDeviceModel];
                BroadcastOtaInfo *cpInfo = [info copy];
                [wself.reconnectDict setValue:cpInfo forKey:dev.bleAddr];
                NSLog(@"ToReconnect:%@",dev.bleAddr);
                [[BroadcastBleManager sharedInstance] connectPeripheralWithMacAddr:dev.bleAddr];
            }
            
        }];
    }else{
        NSLog(@"找不到该内容，进行升级失败");
    }
}



-(void)otaUpdateStepII:(NSString *)mac Info:(CBPeripheral*)cbp{
    
    [self threadRun2:@[cbp,mac]];
    
}

-(void)threadRun2:(NSArray *)items{
   
    CBPeripheral *cbp = items.firstObject;
    NSString *key = items.lastObject;
    BroadcastOtaInfo *oldInfo = self.reconnectDict[key];

    JL_Assist *assist = [[BroadcastBleManager sharedInstance] assistDicts][cbp.identifier.UUIDString];
    
    NSLog(@"startOtaII:%@ \nByUUID:%@\noldUUID:%@",oldInfo.updatePath,cbp.identifier.UUIDString,oldInfo.cbp.identifier.UUIDString);
    
    if(oldInfo.updatePath){
        //        __weak typeof(self) wself = self;
        NSData *data = [NSData dataWithContentsOfFile:oldInfo.updatePath];
        [assist.mCmdManager.mOTAManager cmdOTAData:data Result:^(JL_OTAResult result, float progress) {
            
            for (id<OtaUpdatePtl>objc in self.delegates) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([objc respondsToSelector:@selector(otaResult:Old:Status:Progress:)]){
                        [objc otaResult:cbp Old:oldInfo.cbp Status:result Progress:progress];
                    }
                });
            }
           
        }];
    }else{
        NSLog(@"找不到该内容，进行升级失败");
    }
    
}




@end

@implementation BroadcastOtaInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    BroadcastOtaInfo *info = [[self class] allocWithZone:zone];
    info.cbp = self.cbp;
    info.updatePath = self.updatePath;
    return info;
}

@end


