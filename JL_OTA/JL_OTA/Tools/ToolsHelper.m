//
//  ToolsHelper.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/10.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "ToolsHelper.h"

@interface ToolsHelper()

@property(nonatomic,strong)NSTimer *logTimer;
@property(nonatomic,strong)NSString *targetPath;
@property(nonatomic,assign)NSInteger maxSize;

@end

@implementation ToolsHelper

+(instancetype)share{
    static ToolsHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ToolsHelper alloc] init];
    });
    return helper;
}


-(void)countLogSize{
    NSData *data = [NSData dataWithContentsOfFile:_targetPath];
    if(data.length > _maxSize){
        [[NSData new] writeToFile:_targetPath atomically:true];
    }
}






+(BOOL)isSupportSelectMore{
    if([DFTools getUserByKey:@"SupportSelectMore"]){
        return [[DFTools getUserByKey:@"SupportSelectMore"] boolValue];
    }else{
        return NO;
    }
}

+(void)setSupportSelect:(BOOL)status{
    [DFTools setUser:[NSNumber numberWithBool:status] forKey:@"SupportSelectMore"];
}


+(BOOL)isSupportPair{
    if([DFTools getUserByKey:@"SupportPair"]){
        return [[DFTools getUserByKey:@"SupportPair"] boolValue];
    }else{
        [self setSupportPari:YES];
        return YES;
    }
}



+(void)setSupportPari:(BOOL)status{
    [DFTools setUser:[NSNumber numberWithBool:status] forKey:@"SupportPair"];
}

/// 设置是否HID
/// - Parameter status: 是否HID
+(void)setSupportHID:(BOOL)status{
    [DFTools setUser:[NSNumber numberWithBool:status] forKey:@"SupportHID"];
}

/// 获取是否HID
+(BOOL)isSupportHID{
    
    if([DFTools getUserByKey:@"SupportHID"]){
        return [[DFTools getUserByKey:@"SupportHID"] boolValue];
    }else{
        [self setSupportHID:NO];
        return NO;
    }
}

/// 设置是否需要广播音箱过滤
/// - Parameter status: 是否广播音箱过滤
+(void)setBroadcastFitter:(BOOL)status{
    [DFTools setUser:[NSNumber numberWithBool:status] forKey:@"BroadcastFitter"];
}

/// 获取是否需要广播音箱过滤
+(BOOL)isBroadcastFitter{
    if([DFTools getUserByKey:@"BroadcastFitter"]){
        return [[DFTools getUserByKey:@"BroadcastFitter"] boolValue];
    }else{
        [self setBroadcastFitter:YES];
        return YES;
    }
}

/// 设置是否开启广播音箱
/// - Parameter status: 是否广播音箱
+(void)setBroadcast:(BOOL)status{
    [DFTools setUser:[NSNumber numberWithBool:status] forKey:@"Broadcast_tag"];
}

/// 获取是否开启广播音箱
+(BOOL)isBroadcast{
    if([DFTools getUserByKey:@"Broadcast_tag"]){
        return [[DFTools getUserByKey:@"Broadcast_tag"] boolValue];
    }else{
        [self setBroadcastFitter:NO];
        return NO;
    }
}



+(BOOL)isConnectBySDK{
    if([DFTools getUserByKey:@"ConnectBySDK"]){
        return [[DFTools getUserByKey:@"ConnectBySDK"] boolValue];
    }else{
        [self setConnectBySDK:NO];
        return NO;
    }
}

+(void)setConnectBySDK:(BOOL)status{
    [DFTools setUser:[NSNumber numberWithBool:status] forKey:@"ConnectBySDK"];
}


+(BOOL)isAutoTestOta{
    if([DFTools getUserByKey:@"AutoTestOta"]){
        return [[DFTools getUserByKey:@"AutoTestOta"] boolValue];
    }else{
        return NO;
    }
}

+(void)setAutoTestOta:(BOOL)status{
    [DFTools setUser:[NSNumber numberWithBool:status] forKey:@"AutoTestOta"];
    [self setSupportSelect:status];
}


+(NSInteger)getAutoTestOtaNumber{
    if([DFTools getUserByKey:@"AutoTestOtaNumber"]){
        return [[DFTools getUserByKey:@"AutoTestOtaNumber"] intValue];
    }else{
        return 1;
    }
}

+(void)setAutoTestOtaNumber:(NSInteger)number{
    [DFTools setUser:[NSNumber numberWithInt:(int)number] forKey:@"AutoTestOtaNumber"];
}

+(void)setFaultTolerant:(BOOL)status{
    [DFTools setUser:[NSNumber numberWithBool:status] forKey:@"fault_tolerant"];
}

+(BOOL)getFaultTolerant{
    if([DFTools getUserByKey:@"fault_tolerant"]){
        return [[DFTools getUserByKey:@"fault_tolerant"] boolValue];
    }else{
        return NO;
    }
}


+(NSInteger)getFaultTolerantTimes{
    if([DFTools getUserByKey:@"fault_tolerant_times"]){
        return [[DFTools getUserByKey:@"fault_tolerant_times"] intValue];
    }else{
        return 5;
    }
}

+(void)setFaultTolerantTimes:(NSInteger)number{
    [DFTools setUser:[NSNumber numberWithInt:(int)number] forKey:@"fault_tolerant_times"];
}









+(NSString *)errorReason:(JL_OTAResult)result{
    switch (result) {
        case JL_OTAResultSuccess:
            return  @"升级成功";
            break;
        case JL_OTAResultFail:
            return @"升级失败";
            break;
        case JL_OTAResultDataIsNull:
            return @"升级数据为空";
            break;
        case JL_OTAResultCommandFail:
            return @"指令失败";
            break;
        case JL_OTAResultSeekFail:
            return @"标示偏移查找失败";
            break;
        case JL_OTAResultInfoFail:
            return @"固件信息错误";
            break;
        case JL_OTAResultLowPower:
            return @"电量低";
            break;
        case JL_OTAResultEnterFail:
            return @"无法进入OTA升级";
            break;
        case JL_OTAResultUpgrading:
            return @"正在升级";
            break;
        case JL_OTAResultReconnect:
            return @"回连中";
            break;
        case JL_OTAResultReboot:
            return @"设备重启中";
            break;
        case JL_OTAResultPreparing:
            return @"准备中...";
            break;
        case JL_OTAResultPrepared:
            return @"准备完毕...";
            break;
        case JL_OTAResultFailVerification:
            return @"固件认证失败";
            break;
        case JL_OTAResultFailCompletely:
            return @"数据校验失败";
            break;
        case JL_OTAResultFailKey:
            return @"升级文件的生成Key不正确";
            break;
        case JL_OTAResultFailErrorFile:
            return @"升级文件错误";
            break;
        case JL_OTAResultFailUboot:
            return @"uboot内容不匹配";
            break;
        case JL_OTAResultFailLenght:
            return @"传输长度出错 ";
            break;
        case JL_OTAResultFailFlash:
            return @"升级过程中flash读写失败";
            break;
        case JL_OTAResultFailCmdTimeout:
            return @"命令发送设备，回复超时";
            break;
        case JL_OTAResultFailSameVersion:
            return @"相同的固件";
            break;
        case JL_OTAResultFailTWSDisconnect:
            return @"tws 耳机未连接";
            break;
        case JL_OTAResultFailNotInBin:
            return @"耳机未在充电仓内";
            break;
        case JL_OTAResultReconnectWithMacAddr:
            return @"通过mac回连设备";
            break;
        case JL_OTAResultUnknown:
            return @"未知错误";
            break;
    }
}

+(void)setProductType:(ProductType)type{
    [DFTools setUser:[NSNumber numberWithInt:(int)type] forKey:@"ProductType"];
}

+(ProductType)getproductType{
    if([DFTools getUserByKey:@"ProductType"]){
        return [[DFTools getUserByKey:@"ProductType"] intValue];
    }else{
        return ProductTypeNormal;
    }
}





@end
