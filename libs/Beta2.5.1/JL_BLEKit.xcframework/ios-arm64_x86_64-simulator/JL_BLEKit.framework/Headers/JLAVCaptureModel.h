//
//  JLAVCaptureModel.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/7/16.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 资源信息模型 
@interface JLAVCaptureModel : NSObject
/// 触发操作码 (0x01=拍照, 0x13=录像开始)
@property(nonatomic,assign)uint8_t  operation;
/// 会话ID
@property(nonatomic,assign)uint8_t  sessionId;
/// 文件类型
@property(nonatomic,assign)uint8_t  fileType;
/// 存储句柄 (4 bytes)
@property(nonatomic,assign)uint32_t storageHandler;
/// 簇号
@property(nonatomic,assign)uint32_t cluster;
/// 文件大小 (Bytes)
@property(nonatomic,assign)uint32_t fileSize;
/// CRC 校验码
@property(nonatomic,assign)uint16_t crc;
/// 文件路径
@property(nonatomic,copy  )NSString *filePath;

/// 从协议原始数据解析（data = [op, ...]，op 已由 Manager 剥离）
+(nullable instancetype)parseFromData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
