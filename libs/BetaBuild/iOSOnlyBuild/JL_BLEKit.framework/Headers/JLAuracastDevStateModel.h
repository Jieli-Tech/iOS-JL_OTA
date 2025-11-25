//
//  JLAuracastDevStateModel.h
//  JL_BLEKit
//
//  Created by EzioChan on 2025/11/17.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Auracast 设备状态数据模型
 
 */
@interface JLAuracastDevStateModel : NSObject

typedef NS_ENUM(uint8_t, JLAuracastDevStateType) {
    JLAuracastDevStateTypeBattery   = 0x01,
    JLAuracastDevStateTypeVolume    = 0x02,
    JLAuracastDevStateTypeCall      = 0x03,
    JLAuracastDevStateTypeWorkMode  = 0x04,
    JLAuracastDevStateTypeLogin     = 0x06,
};

/// 电量
@property(nonatomic, assign) uint8_t batteryValue;
/// 是否在充电
@property(nonatomic, assign) BOOL isCharging;
/// 音量
@property(nonatomic, assign) uint8_t volume;
/// 是否支持音量同步
@property(nonatomic, assign) BOOL supportVolumeSync;

typedef NS_ENUM(uint8_t, JLAuracastCallState) {
    JLAuracastCallStateNone = 0,
    JLAuracastCallStateActive = 1,
};
/// 通话状态
@property(nonatomic, assign) JLAuracastCallState callState;
/// 工作模式
@property(nonatomic, assign) uint8_t workMode;

typedef NS_ENUM(uint8_t, JLAuracastLoginState) {
    JLAuracastLoginStateLogout = 0,
    JLAuracastLoginStateLogin = 1,
};
/// 登录状态
@property(nonatomic, assign) JLAuracastLoginState loginState;

- (instancetype)initParseData:(NSData *)data;

- (void)updateParseData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
