//
//  ToolsHelper.h
//  JL_OTA
//
//  Created by EzioChan on 2022/10/10.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDKBleHelper.h"

typedef NS_ENUM(NSUInteger, ProductType) {
    ProductTypeNormal = 0,
    ProductTypeBroadcast = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface ToolsHelper : NSObject


+(instancetype)share;



/// 设置是否可以多选
/// - Parameter status: 是否多选
+(void)setSupportSelect:(BOOL)status;

/// 获取是否支持多选
+(BOOL)isSupportSelectMore;

/// 设置是否需要广播音箱过滤
/// - Parameter status: 是否广播音箱过滤
+(void)setBroadcastFitter:(BOOL)status;

/// 获取是否需要广播音箱过滤
+(BOOL)isBroadcastFitter;

/// 设置是否开启广播音箱
/// - Parameter status: 是否广播音箱
+(void)setBroadcast:(BOOL)status;

/// 获取是否开启广播音箱
+(BOOL)isBroadcast;

/// 设置是否需要认证
/// - Parameter status: 是否认证
+(void)setSupportPari:(BOOL)status;

/// 获取是否需要设备认证
+(BOOL)isSupportPair;


/// 设置是否HID
/// - Parameter status: 是否HID
+(void)setSupportHID:(BOOL)status;

/// 获取是否HID
+(BOOL)isSupportHID;

/// 是否使用SDK蓝牙连接
+(BOOL)isConnectBySDK;

/// 设置是否使用SDK蓝牙连接
/// - Parameter status: 是否使用SDK蓝牙连接
+(void)setConnectBySDK:(BOOL)status;

/// 是否启用自动化测试
+(BOOL)isAutoTestOta;

/// 设置是否启用自动化测试
/// - Parameter status: 是否自动化测试
+(void)setAutoTestOta:(BOOL)status;

/// 自动化测试次数
+(NSInteger)getAutoTestOtaNumber;

/// 设置自动化测试次数
/// - Parameter number: 次数
+(void)setAutoTestOtaNumber:(NSInteger)number;

/// 设置容错次数
/// - Parameter status: 状态
+(void)setFaultTolerant:(BOOL)status;

/// 获取是否需要容错
+(BOOL)getFaultTolerant;

/// 获取容错次数
+(NSInteger)getFaultTolerantTimes;

/// 设置容错次数
/// - Parameter number: 容错次数
+(void)setFaultTolerantTimes:(NSInteger)number;

/// 根据错误编码返回字符串
/// - Parameter result: 错误编号
+(NSString *)errorReason:(JL_OTAResult)result;


+(void)setProductType:(ProductType)type;

+(ProductType)getproductType;


/// 创建存储路径名字
/// ufw名字
/// - Parameter fileName: 文件名
+(NSURL *)targetSavePath:(NSString *)fileName;


@end

NS_ASSUME_NONNULL_END
