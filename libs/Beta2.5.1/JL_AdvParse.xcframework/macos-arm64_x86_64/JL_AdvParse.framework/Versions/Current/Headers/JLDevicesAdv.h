//
//  JLDevicesAdv.h
//  JL_AdvParse
//
//  Created by EzioChan on 2023/12/12.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLAdvParse.h"


NS_ASSUME_NONNULL_BEGIN

@interface JLDevicesAdv : NSObject

/// 客户唯一标识
@property(nonatomic,assign)uint16_t uid;

/// 产品唯一标识
@property(nonatomic,assign)uint16_t pid;

/// 设备类型
///JL_DeviceTypeSoundBox           = 0,     //AI音箱类型
///JL_DeviceTypeChargingBin        = 1,     //充电仓类型
///JL_DeviceTypeTWS                = 2,     //TWS耳机类型
///JL_DeviceTypeHeadset            = 3,     //普通耳机类型
///JL_DeviceTypeSoundCard          = 4,     //声卡类型
///JL_DeviceTypeWatch              = 5,     //手表类型
///JL_DeviceTypeTradition          = -1,    //传统设备类型
@property(nonatomic,assign)JL_DeviceType type;

/// 协议版本
@property(nonatomic,assign)uint8_t version;

/// 可变数据段
@property(nonatomic,copy)NSData *variableData;

- (instancetype)initWithData:(NSData *)data;


/// 转成model类型
/// @param basicData 蓝牙广播数据
+(JLDevicesAdv *__nullable)advertDataToModel:(NSData *)basicData;

/// 转成model类型
/// @param basicHexStr 蓝牙广播数据
+(JLDevicesAdv *__nullable)advertDataHexStrToModel:(NSString *)basicHexStr;

@end



NS_ASSUME_NONNULL_END
