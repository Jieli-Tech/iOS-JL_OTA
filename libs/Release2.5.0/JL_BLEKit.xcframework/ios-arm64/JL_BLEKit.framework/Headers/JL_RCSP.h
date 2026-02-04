//
//  JL_RCSP.h
//  JL_BLEKit
//
//  Created by zhihui liang on 2018/11/9.
//  Copyright © 2018 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_OpCode.h>

NS_ASSUME_NONNULL_BEGIN



@class JL_PKG;
@interface JL_RCSP : NSObject

/**
 解析JL数据包
 
 @param data 把数据转成JL_PKG模型。
 @return JL_PKG数据模型
 */
+(JL_PKG*)rcspAnalysisData:(NSData*)data;

/**
 生成XM数据包
 
 @param pkg 把JL_PKG模型转成data。
 @return 数据
 */
+(NSData*)rcspMakePackage:(JL_PKG*)pkg;

/**
 分析JL_PKG参数
 
 @param pkg 把JL_PKG的xmData参数部分解析成一列数组。
 @return 参数数组
 */
+(NSArray*)rcspAnalysisParams:(JL_PKG*)pkg;

/**
 分解dJL_PKG信息

 @param data JL_PKG中的信息数据
 @return 参数c数组
 */
+(NSArray*)rcspInfoArrFromData:(NSData*)data;

/// 拆分LTV数据
/// 当前方法针对的是 L 长度为 2Byte
/// @param data LTV数据
+(NSArray*)rcspInfoFromData2ByteSize:(NSData*)data;

/**
 生成JL_PKG参数
 
 @param array 把参数数组变成data（注意：数组元素必须是NSData类型）。
 @return 数据
 */
+(NSData*)rcspMakeParams:(NSArray*)array;
@end

@interface JL_PKG : NSObject
@property(assign,nonatomic) uint16_t pkgIsCommand;       //1Bit
@property(assign,nonatomic) uint16_t pkgNeedResponse;    //1Bit
@property(assign,nonatomic) uint16_t pkgUnused;          //6Bits
@property(assign,nonatomic) uint16_t pkgOpCode;          //8Bits
@property(assign,nonatomic) uint16_t pkgLength;          //参数长度(本身不计)
@property(strong,nonatomic) NSData   *pkgData;           //参数数据
@end
NS_ASSUME_NONNULL_END
