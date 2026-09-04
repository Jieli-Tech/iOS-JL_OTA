//
//  JLHashHandler.h
//  JL_BLEKit
//
//  Created by EzioChan on 2023/1/30.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JLLogHelper/JLLogHelper.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLHashBlock)(BOOL ret);

@protocol JLHashHandlerDelegate <NSObject>

/// 需要发送到设备校验认证的数据
/// - Parameter data: 数据
-(void)hashOnPairOutputData:(NSData*)data;

@end


/// 设备认证
///
/// 使用示例 (Objective-C):
/// ```objective-c
/// JLHashHandler *handler = [[JLHashHandler alloc] init];
/// handler.delegate = self; // 必须实现 hashOnPairOutputData: 代理方法
///
/// // 发起认证
/// [handler bluetoothPairingKey:nil Result:^(BOOL ret) {
///     if (ret) { NSLog(@"认证成功"); }
/// }];
///
/// // 代理回调：将 SDK 生成的验证数据发往设备
/// - (void)hashOnPairOutputData:(NSData *)data {
///     [peripheral writeValue:data forCharacteristic:authChar type:CBCharacteristicWriteWithoutResponse];
/// }
///
/// // 收到设备回复：将设备数据回传给 SDK
/// - (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
///     if ([characteristic.UUID isEqual:authChar.UUID]) {
///         [handler inputPairData:characteristic.value];
///     }
/// }
/// ```
@interface JLHashHandler : NSObject

@property(nonatomic,weak)id<JLHashHandlerDelegate> delegate;


/// APP端发起设备认证
/// - Parameters:
///   - pKey: 加密Key（默认为空）
///   - bk: 配对认证回调结果
-(void)bluetoothPairingKey:(NSData *__nullable)pKey Result:(JLHashBlock)bk;


/// 重置设备认证过程
-(void)hashResetPair;


/// 填入设备回复数据
/// - Parameter rData: 数据
-(void)inputPairData:(NSData*)rData;


/// 停止设备认证过程
/// stop device pairing
-(void)stopAuthPair;


/// 打印当前SDK的版本
+(void)sdkVersion;



@end

NS_ASSUME_NONNULL_END
