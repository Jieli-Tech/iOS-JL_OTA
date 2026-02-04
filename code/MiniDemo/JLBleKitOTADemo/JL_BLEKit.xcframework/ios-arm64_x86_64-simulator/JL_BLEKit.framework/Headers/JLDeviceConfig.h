//
//  JLDeviceConfig.h
//  JL_BLEKit
//
//  Created by EzioChan on 2022/10/31.
//  Copyright © 2022 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_TypeEnum.h>

@class JL_ManagerM;
@class JLDeviceConfigModel;
@class JLDeviceConfigTws;
@class JLDeviceConfigDongle;
@class JLDeviceConfigSoundBox;

NS_ASSUME_NONNULL_BEGIN
typedef void(^JLConfigRsp)(JL_CMDStatus status, uint8_t sn, JLDeviceConfigModel* __nullable config);

typedef void(^JLConfigTwsRsp)(JL_CMDStatus status, uint8_t sn, JLDeviceConfigTws* __nullable config);

typedef void(^JLConfigAuracastRsp)(JL_CMDStatus status, uint8_t sn, JLDeviceConfigDongle* __nullable config);

typedef void (^JLConfigSoundBoxRsp)(JL_CMDStatus status, uint8_t sn, JLDeviceConfigSoundBox* __nullable config);


/// 固件设置配置回调协议
/// 遵循时，可通过父类的- (void)addDelegate:(id)delegate方法添加遵循
@protocol JLConfigPtl <NSObject>

@optional
/// 监听回调协议
/// - Parameter configModel: 固件设置配置回调
-(void)deviceConfigWith:(JLDeviceConfigModel *)configModel;

/// TWS监听回调协议
/// - Parameter configModel: 固件设置配置回调
-(void)deviceTwsConfigWith:(JLDeviceConfigTws *)configModel;

/// SoundBox监听回调协议
/// - Parameter configModel: 固件设置配置回调
-(void)deviceSoundBoxConfigWith:(JLDeviceConfigSoundBox *)configModel;

/// Dongle 监听回调协议
/// - Parameter configModel: 固件设置配置回调
-(void)deviceAuracastConfigWith:(JLDeviceConfigDongle *)configModel;

@end

@interface JLDeviceConfig : NSObject


@property(nonatomic,weak) id<JLConfigPtl> _Nullable delegate;

+(instancetype)share;

/// 获取设备配置信息
-(void)deviceConfigGet:(JL_ManagerM *)manager;


/// 手表查询设备当前固件配置内容
/// - Parameters:
///   - manager: manager
///   - result: 回调功能配置内容
-(void)deviceGetConfig:(JL_ManagerM *)manager result:(JLConfigRsp)result;

/// 手表多设备管理时，可通过对应的设备UUID 获取相关的设备配置
/// - Parameter entity: 设备uuidStr
-(JLDeviceConfigModel *_Nullable)deviceGetConfigWithUUID:(NSString *)uuidStr;

/// TWS查询设备当前固件配置内容
/// - Parameters:
///   - manager: manager
///   - result: 回调功能配置内容
-(void)deviceTwsGetConfig:(JL_ManagerM *)manager result:(JLConfigTwsRsp)result;

/// Dongle 查询设备当前固件配置内容
/// - Parameters:
///   - manager: manager
///   - result: 回调功能配置内容
-(void)deviceDongleGetConfig:(JL_ManagerM *)manager result:(JLConfigAuracastRsp)result;

/// SoundBox 查询设备当前固件配置内容
/// - Parameters:
///   - manager: manager
///   - result: 回调功能配置内容
-(void)deviceSoundBoxGetConfig:(JL_ManagerM *)manager result:(JLConfigSoundBoxRsp)result;


/// Tws多设备管理时，可通过对应的设备UUID 获取相关的设备配置
/// - Parameter entity: 设备uuidStr
-(JLDeviceConfigTws *)deviceGetTwsConfigWithUUID:(NSString *)uuidStr;

/// Dongle 查询设备当前固件配置内容
/// - Parameters:
///     - uuidStr: 设备uuidStr
-(JLDeviceConfigDongle *)deviceGetAuracastConfigWithUUID:(NSString *)uuidStr;


/// SoundBox 多设备管理时，可通过对应的设备 UUID 获取相关的设备配置信息
/// - Parameter uuidStr: 设备 uuid
-(JLDeviceConfigSoundBox *)deviceGetSoundBoxConfigWithUUID:(NSString *)uuidStr;


/// 私有测试接口请勿使用
/// - Parameter data: 用于测试数据
/// - Parameter st: 是否开启测试模式
-(void)pDeviceTest:(NSData *)data Status:(BOOL)st;

@end

NS_ASSUME_NONNULL_END
