//
//  JLAuracastLancerManager.h
//  JL_BLEKit
//
//  Created by EzioChan on 2025/11/17.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_BLEKit.h>
NS_ASSUME_NONNULL_BEGIN
@class JLAuracastLancerSettingMode;
@class JLAuracastLancerManager;

@protocol JLAuracastLancerManagerDelegate <NSObject>
@optional
-(void)lancerManager:(JLAuracastLancerManager *)mgr didUpdateSetting:(JLAuracastLancerSettingMode *)mode;
/// 设备状态更新
/// - Parameters:
///   - mgr: 管理器
///   - state: 最新设备状态
-(void)lancerManager:(JLAuracastLancerManager *)mgr didUpdateDeviceState:(JLAuracastDevStateModel *)state;
@end

/// Lancer 验证
typedef NS_ENUM(NSUInteger, JLAuracastLancerLoginVerifyType) {
    /// 验证成功
    JLLancerLoginVerifyTypeSuccess = 0x00,
    /// 验证失败
    JLLancerLoginVerifyTypeFail = 0x01,
    /// 已登录
    JLLancerLoginVerifyTypeLogined = 0x02
};

/// 修改密码结果
typedef NS_ENUM(NSUInteger, JLAuracastLancerChangePwdResult) {
    /// 修改成功
    JLAuracastLancerChangePwdSuccess = 0x00,
    /// 旧密码错误
    JLAuracastLancerChangePwdOldError = 0x01,
    /// 密码没有变化
    JLAuracastLancerChangePwdNoChange = 0x02,
    /// 新密码长度不对
    JLAuracastLancerChangePwdLengthError = 0x03
};



typedef void(^JLLancerLoginVerifyBlock)(JLAuracastLancerLoginVerifyType status);

typedef void(^JLLancerChangePwdBlock)(JLAuracastLancerChangePwdResult status);

@interface JLAuracastLancerManager : NSObject

@property(nonatomic, strong) JLAuracastLancerSettingMode *__nullable settingMode;

@property(nonatomic, weak) id<JLAuracastLancerManagerDelegate> delegate;


-(instancetype)initWithManager:(JL_ManagerM *)manager;

/// 设备状态
@property(nonatomic,strong)JLAuracastDevStateModel *devState;

/// 登录
/// - Parameters:
///   - password: 登录密码
///   - result: 结果
-(void)loginVerify:(NSString *)password Result:(JLLancerLoginVerifyBlock)result;

/// 修改密码
/// - Parameters:
///   - oldPwd: 旧密码
///   - newPwd: 新密码
///   - result: 结果
-(void)changePassword:(NSString *)oldPwd newPassword:(NSString *)newPwd Result:(JLLancerChangePwdBlock)result;


/// 获取Auracast设备状态
/// - Parameter state:
/// 0x01 == 电量
/// 0x02 == 音量
/// 0x03 == 通话
/// 0x04 == 工作模式
/// 0x06 == 登录状态
-(void)auracastGetDevState:(uint8_t)state;

/// 获取Auracast设备状态
-(void)auracastGetDevState;

/// 获取广播音频发射设置
/// - Parameter type: 类型
/// 0x01 == 广播名称
/// 0x02 == 音频格式序号
/// 0x03 == 加密信息
/// 0x04 == 发射功率
-(void)getBroadcastLancerSetting:(UInt8)type;

/// 获取广播音频发射设置
-(void)getBroadcastLancerSetting;

/// 单独设置广播名称
-(void)setBroadcastName:(NSString *)name;

/// 单独设置音频格式序号
-(void)setAudioFormatIndex:(JLBroadcastSetAudioFormat)index;

/// 单独设置加密与 Broadcast Code（长度16）
-(void)setEncryptEnabled:(BOOL)enabled code:(NSData *)code;

/// 单独设置发射功率（1~10）
-(void)setPowerLevel:(uint8_t)level;

/// 一次性下发全部设置（来自 settingMode 或参数）
-(void)setBroadcastLancerSetting:(JLAuracastLancerSettingMode *)mode;

///关机
-(void)shoudown;

///重启
-(void)restart;

///恢复出厂设置
-(void)reset;

/// 销毁
-(void)onDestory;

@end

NS_ASSUME_NONNULL_END
