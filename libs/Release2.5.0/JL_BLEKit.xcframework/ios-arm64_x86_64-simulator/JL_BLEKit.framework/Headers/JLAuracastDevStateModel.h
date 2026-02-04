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
    JLAuracastDevStateTypeLogin     = 0x01,
};
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
