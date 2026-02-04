//
//  ECBDTManager.h
//  JL_BLEKit
//
//  Created by EzioChan on 2023/11/20.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <JL_BLEKit/JL_BLEKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JL_ManagerM;

@protocol ECBDTManagerProtocol <NSObject>

/// 大数据传输错误
/// - Parameters:
///   - manager: 设备
///   - type: 类型
///   - error: 错误
-(void)ecBDTManagerError:(JL_ManagerM *)manager Type:(uint8_t) type  Error:(NSError *)error;

/// 获取到设备端推送/ SDK 端读取的大数据内容
/// - Parameters:
///   - manager: 设备
///   - type: 类型
///   - data: 数据块
///   - progress: 进度
-(void)ecBDTManager:(JL_ManagerM *)manager Type:(uint8_t) type GetBigData:(NSData *)data Progress:(float) progress;

/// 获取到设备端推送/ SDK 端读取的大数据内容 结束
/// - Parameters:
///   - manager: 设备
///   - type: 类型
///   - saveFilePath: 数据存放位置
-(void)ecBDTManager:(JL_ManagerM *)manager Type:(uint8_t) type  FinishBigData:(NSString *)saveFilePath;


@optional

///  App 端主动发起的向写入数据进度
/// - Parameters:
///   - manager: 设备
///   - progress: 数据
///   - finish: 是否完成
-(void)ecBDTManager:(JL_ManagerM *)manager SendBigDataPresent:(float )progress Finish:(BOOL)finish;

///  设备端发起大数据写操作
///  设备端主动发起的向 App 端写入数据
/// - Parameters:
///   - manager: 设备
///   - type: 类型
///   - req: 请求写入的内容
-(void)ecBDTManager:(JL_ManagerM *)manager StartBigData:(ECBDTWriteReq *)req Type:(uint8_t) type;


/// 设备端发起大数据读取操作
/// 开发者在这里需要对设备主动过来请求的内容进行回复
/// -(void)responseDev:(JL_ManagerM *)manager resp:(ECBDTReadReq *)req Data:(NSData *)data
/// - Parameters:
///   - manager: 设备
///   - type: 类型
///   - req: 请求内容
-(void)ecBDTManager:(JL_ManagerM *)manager ReadBigData:(ECBDTReadReq *)req Type:(uint8_t) type;

/// 发送大数据完毕
/// - Parameter manager: 设备
/// - Parameter type: 类型
-(void)ecBDTManagerSendFinish:(JL_ManagerM *)manager  Type:(uint8_t) type;

@end

@interface ECBDTManager : ECOneToMorePtl

+(instancetype)share;

/// APP 读取设备数据
/// - Parameters:
///   - manager: 设备
///   - type: 数据类型
/// * 0 ：原始数据
/// * 1 :  阿里云数据
/// * 2：RTC数据
/// * 3：AI云
/// * 4：TTS语音合成
/// * 5：平台接口认证信息
/// * 6：esim 卡信息
/// * 7:4G 模块升级数据
/// * 8:提示音文件数据
-(void)readData:(JL_ManagerM *)manager Type:(uint8_t)type;

/// APP 写入设备数据
/// - Parameters:
///   - manager: 设备
///   - type: 数据类型
/// * 0 ：原始数据
/// * 1 :  阿里云数据
/// * 2：RTC数据
/// * 3：AI云
/// * 4：TTS语音合成
/// * 5：平台接口认证信息
/// * 6：esim 卡信息
/// * 7:4G 模块升级数据
/// * 8:提示音文件数据
///   - data: 大数据内容
-(void)writeData:(JL_ManagerM *)manager Type:(uint8_t) type Data:(NSData*)data;

/// 回应设备主动读取内容
/// 此方法需要配合使用
/// -(void)ecBDTManager:(JL_ManagerM *)manager ReadBigData:(ECBDTReadReq *)req
/// - Parameters:
///   - manager: 设备
///   - req: 设备端请求的对象
///   - data: 需要下发的数据内容
-(void)responseDev:(JL_ManagerM *)manager resp:(ECBDTReadReq *)req Data:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
