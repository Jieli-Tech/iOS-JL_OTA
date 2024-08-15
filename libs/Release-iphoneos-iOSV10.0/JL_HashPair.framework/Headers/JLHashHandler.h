//
//  JLHashHandler.h
//  JL_BLEKit
//
//  Created by EzioChan on 2023/1/30.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSInteger, HASH_LEVEL) {
    HASH_DEBUG = 0,
    HASH_INFO  = 1,
    HASH_WARN  = 2,
    HASH_ERROR = 3,
};
typedef void(^JLHashBlock)(BOOL ret);

@protocol JLHashHandlerDelegate <NSObject>

/// 需要发送到设备校验认证的数据
/// - Parameter data: 数据
-(void)hashOnPairOutputData:(NSData*)data;

@end


/// 设备认证
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


/// 打印当前SDK的版本
+(void)sdkVersion;


///LOG使能与等级，默认开启且debug等级。
/// @param enable LOG使能
/// @param isMore 是否打印【函数名&行号】
/// @param level   LOG等级
+(void)setLog:(BOOL)enable IsMore:(BOOL)isMore Level:(HASH_LEVEL)level;

/// 打印宏
#define kHashLog(level,fmt...) [JLHashHandler Log:level Func:__FUNCTION__ Line:__LINE__ format:fmt]
/// 打印函数
/// @param level     LOG等级
/// @param func       函数名
/// @param line       行号
/// @param format   内容
+(void)Log:(HASH_LEVEL)level
          Func:(const char* _Nullable)func
          Line:(const int)line
        format:(NSString * _Nonnull)format,...;

@end

NS_ASSUME_NONNULL_END
