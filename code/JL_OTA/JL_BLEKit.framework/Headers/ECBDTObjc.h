//
//  ECBDTObjc.h
//  JL_BLEKit
//
//  Created by EzioChan on 2023/11/21.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECBDTObjc : NSObject

@end

/// 设备传输参数回复数据
@interface ECBDTBasic : NSObject
/// 操作类型
/// 0：设备传输参数
/// 1：传输数据
@property (nonatomic, assign) uint8_t op;

/// 方式
/// 0：读取数据
/// 1：发送数据
@property (nonatomic, assign) uint8_t way;

/// 数据类型
/// * 0 ：原始数据
/// * 1 :  阿里云数据
/// * 2：RTC数据
/// * 3：AI云
/// * 4：TTS语音合成
/// * 5：平台接口认证信息
/// * 6：esim 卡信息
/// * 7:4G 模块升级数据
@property (nonatomic, assign) uint8_t type;

/// 版本
@property (nonatomic, assign) uint8_t version;

/// 数据
@property (nonatomic, copy)NSData *paramData;

-(instancetype)initData:(NSData *)data;

@end


//MARK: - 回复大数据数据解析（设备回复）

/// 设备传输参数（读取回复）
@interface ECBDTReadResp : ECBDTBasic
/// 结果码
@property (nonatomic, assign) uint8_t result;

/// 数据长度
@property (nonatomic, assign) uint32_t dtLen;

/// 数据总 CRC
@property (nonatomic, assign) uint16_t crc;

/// 发送 MTU 协商值
@property (nonatomic, assign) uint16_t sendMtu;

/// 接收 MTU 协商值
@property (nonatomic, assign) uint16_t receiveMtu;

@end

/// 设备传输参数（发送回复）
@interface ECBDTWriteResp : ECBDTBasic
/// 结果码
@property (nonatomic, assign) uint8_t result;

/// 发送 MTU 协商值
@property (nonatomic, assign) uint16_t sendMtu;

/// 接收 MTU 协商值
@property (nonatomic, assign) uint16_t receiveMtu;

@end

//MARK: - 请求大数据数据解析（设备请求）

/// 设备传输参数（读取请求）
@interface ECBDTReadReq: ECBDTBasic

/// 发送 MTU 协商值
@property (nonatomic, assign) uint16_t sendMtu;

/// 接收 MTU 协商值
@property (nonatomic, assign) uint16_t receiveMtu;

@end


/// 设备传输参数（发送请求）
@interface ECBDTWriteReq : ECBDTBasic

/// 数据长度
@property (nonatomic, assign) uint32_t dtLen;

/// 数据总 CRC
@property (nonatomic, assign) uint16_t crc;

/// 发送 MTU 协商值
@property (nonatomic, assign) uint16_t sendMtu;

/// 接收 MTU 协商值
@property (nonatomic, assign) uint16_t receiveMtu;

@end


//传输数据命令参数
@interface ECBDTCmdData : NSObject<NSCopying>
/// 数据类型
/// * 0 ：原始数据
/// * 1 :  阿里云数据
/// * 2：RTC数据
/// * 3：AI云
/// * 4：TTS语音合成
/// * 5：平台接口认证信息
/// * 6：esim 卡信息
/// * 7:4G 模块升级数据
@property (nonatomic, assign) uint8_t type;


/// 标识位
/// YES：结束
/// NO：继续
@property (nonatomic, assign) BOOL isEnd;

///序号
@property (nonatomic, assign) uint32_t seq;

/// crc
@property (nonatomic, assign) uint16_t crc;

/// 数据偏移
@property (nonatomic, assign) uint32_t offset;

/// 数据长度
@property (nonatomic, assign) uint16_t len;

/// 数据
@property (nonatomic, copy)NSData *data;


-(instancetype)initData:(NSData *)data;

-(NSData *)beData;

/// 切块分包数据
/// - Parameters:
///   - mtu: 发送的 mtu
///   - type: 数据类型
///   - dt: 文件数据
+(NSArray<ECBDTCmdData *>*)makeWithMtu:(uint16_t)mtu Type:(uint8_t) type Data:(NSData *)dt;

@end


NS_ASSUME_NONNULL_END
