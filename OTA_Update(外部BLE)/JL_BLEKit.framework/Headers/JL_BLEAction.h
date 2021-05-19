//
//  JL_BLEAction.h
//  JL_BLEKit
//
//  Created by zhihui liang on 2018/11/10.
//  Copyright © 2018 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ATC_Block)(BOOL ret);

@interface JL_BLEAction : NSObject

+(id)sharedMe;

/**
 过滤其余蓝牙设备
 
 @param key 过滤码
 @param advertData 蓝牙广播字典
 @return YES：认证设备 NO：杂余设备
 */
+(BOOL)bluetoothKey:(NSData*)key Filter:(NSDictionary*)advertData;
+(NSDictionary*)bluetoothKey_1:(NSData*)key Filter:(NSDictionary*)advertData;
/**
 *  蓝牙设备配对
 *  @param 配对码
 *  @param BLE_Block 配对回调YES：成功 NO：失败
 */

/**
 蓝牙设备配对
 
 @param pKey 配对码
 @param bk   配对回调YES：成功 NO：失败
 */
-(void)bluetoothPairingKey:(NSData*)pKey Result:(ATC_Block)bk;
@end

NS_ASSUME_NONNULL_END
