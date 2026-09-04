//
//  JLStreamDataModel.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/4/10.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 流媒体数据类型枚举
typedef NS_ENUM(uint8_t, JLStreamDataType) {
    JLStreamDataTypeMic = 0x01,         // 麦克风
    JLStreamDataTypeCamera = 0x02,      // 摄像头
    JLStreamDataTypeLocalDevice = 0x03  // 本机设备 
};

/// 音频采样率枚举
typedef NS_ENUM(uint8_t, JLStreamAudioSampleRateType) {
    JLStreamAudioSampleRate8000  = 0x00,
    JLStreamAudioSampleRate11025 = 0x01,
    JLStreamAudioSampleRate12000 = 0x02,
    JLStreamAudioSampleRate16000 = 0x03,
    JLStreamAudioSampleRate22050 = 0x04,
    JLStreamAudioSampleRate24000 = 0x05,
    JLStreamAudioSampleRate32000 = 0x06,
    JLStreamAudioSampleRate44100 = 0x07,
    JLStreamAudioSampleRate48000 = 0x08,
};

/// 摄像头编码格式枚举
typedef NS_ENUM(uint8_t, JLStreamCameraCodecType) {
    JLStreamCameraCodecTypeJPEG = 0x00,
    JLStreamCameraCodecTypeH264 = 0x01
};

/// 流媒体传输状态枚举
typedef NS_ENUM(uint8_t, JLStreamTransferStatus) {
    JLStreamTransferStatusSuccess = 0x00,       // 成功
    JLStreamTransferStatusBusyOrFailed = 0x01,  // 设备忙/开启失败
    JLStreamTransferStatusNotSupport = 0x02     // 参数不支持
};

/// 流媒体异常报告原因枚举
typedef NS_ENUM(uint8_t, JLStreamErrorReason) {
    JLStreamErrorReasonMissingHeader = 0x01,    // 缺失头数据 (需重新发送首包)
    JLStreamErrorReasonDecodeFailed = 0x02,     // 解码失败/数据损坏
    JLStreamErrorReasonCRCCheckFailed = 0x03,   // CRC 校验失败
    JLStreamErrorReasonUnknown = 0x04           // 其他未知错误
};

/// 流媒体指令操作码枚举 (用于 payload 的首字节 option)
typedef NS_ENUM(uint8_t, JLStreamCommandOption) {
    JLStreamCommandOptionGetInfo = 0x00,        // 获取流媒体信息
    JLStreamCommandOptionStart = 0x01,          // 开启流媒体
    JLStreamCommandOptionStop = 0x02,           // 停止流媒体
    JLStreamCommandOptionError = 0x03           // 异常上报
};

/// 数据帧结构标志位 (Data Type Bits)
typedef NS_ENUM(uint8_t, JLStreamFrameDataType) {
    JLStreamFrameDataTypeHeaderOnly = 0x01,     // 只有头
    JLStreamFrameDataTypeDataOnly = 0x02,       // 只有裸数据
    JLStreamFrameDataTypeHeaderAndData = 0x03,  // 头+裸数据
    JLStreamFrameDataTypeMask = 0x03            // 掩码，取最低两位
};

/// 数据帧
@interface JLStreamDataModel : NSObject

@property (nonatomic, assign) uint16_t opcode;
@property (nonatomic, assign) uint8_t dataType;
@property (nonatomic, assign) uint16_t seq;
@property (nonatomic, assign) uint32_t offset;
@property (nonatomic, assign) uint32_t frameSize;
@property (nonatomic, assign) uint32_t timestamp;
@property (nonatomic, assign) uint16_t crc16;
@property (nonatomic, assign) uint8_t index;

/// 组装完成的有效载荷数据
@property (nonatomic, strong) NSData *payloadData;

/// JPEG 头数据 (用于分帧发送，第一帧后只发送主体)
@property (nonatomic, strong, nullable) NSData *jpegHeaderData;

/// 是否为该帧最后一包
@property (nonatomic, assign, readonly) BOOL isLastPacket;

-(NSDate *) timestampDate;

/// 将数据帧按照协商 MTU 分包为可直接通过 AE03/AE04 发送的裸流数据包数组
/// mtu: 协商后的 MTU (流数据最大全长)
/// 返回的每个 NSData 均已包含完整的 [流数据内容] 格式头部 + 负载
- (NSArray<NSData *> *)packetizeWithMtu:(uint16_t)mtu;

/// 将数据帧按照协商 MTU 分包，只发送主体数据（不含 JPEG 头）
/// 用于 JPEG 分帧发送的后续帧
/// - Parameters:
///   - mtu: 协商后的 MTU
///   - headerLength: JPEG 头长度，这部分数据会被跳过
/// - Returns: 分包后的数据包数组
- (NSArray<NSData *> *)packetizeWithMtu:(uint16_t)mtu skipHeaderLength:(uint32_t)headerLength;

@end

//MARK: - JLStreamErrorReportModel 异常上报
@interface JLStreamErrorReportModel : NSObject

/// 发生异常的外设自增序号
@property (nonatomic, assign) uint8_t index;

/// 发生异常的数据包序号
@property (nonatomic, assign) uint16_t seq;

/// 错误原因代码 
/// 参考 JLStreamErrorReason 
@property (nonatomic, assign) JLStreamErrorReason reason;

- (instancetype)initWithIndex:(uint8_t)index seq:(uint16_t)seq reason:(JLStreamErrorReason)reason;
- (NSData *)payloadData;

/// 根据接收到的数据解析出模型
/// - Parameter data: payload 数据 (去除了 option)
+ (instancetype)modelWithData:(NSData *)data;

@end

//MARK: - JLStreamGetInfoModel 获取设备在线外设信息

/// 视频配置内容 
@interface JLStreamVideoConfig : NSObject
/// 视频支持的编码格式 (按BIT使能)
/// bit0: JPEG, bit1: H264
@property (nonatomic, assign) uint32_t codec;
/// 分辨率-宽度
@property (nonatomic, assign) uint16_t width;
/// 分辨率-高度
@property (nonatomic, assign) uint16_t height;
/// 最大帧率
@property (nonatomic, assign) uint8_t fps;
@end

/// 音频配置内容 
@interface JLStreamAudioConfig : NSObject
/// 音频支持的编码格式 (按BIT使能)
/// bit0: PCM, bit1: SPEEX, bit2: OPUS, bit3: MSBC, bit4: JLA_V2
@property (nonatomic, assign) uint32_t codec;
/// 音频支持的采样率 (按BIT使能)
/// bit0: 8000, bit1: 11025, bit2: 12000, bit3: 16000, bit4: 22050,
/// bit5: 24000, bit6: 32000, bit7: 44100, bit8: 48000
@property (nonatomic, assign) uint32_t sampleRate;
/// 声道数 (按BIT使能)
/// bit0: 单声道, bit1: 多声道
@property (nonatomic, assign) uint8_t channels;
@end

/// 外设信息
@interface JLStreamPeripheralResponseModel : NSObject
/// 0x01: Mic,
/// 0x02: Camera
/// 0x03: LocalDevice (本机设备)
@property (nonatomic, assign) JLStreamDataType type;
/// 外设编号
@property (nonatomic, assign) uint8_t number;

/// 编码格式 (按BIT使能)
/// 若为 Mic 时，按BIT使能对应
/// bit0: 1:支持PCM 0:不支持 PCM
/// bit1: 1:支持 speex 0:不支持 speex
/// bit2: 1:支持 opus 0:不支持 opus
/// bit3: 1:支持 msbc 0:不支持 msbc
/// bit4: 1:支持 jla_v2 0:不支持 jla_v2
/// ---------------------------------
/// 若为 Camera 时，按BIT使能对应
/// bit0: 1:支持 jpeg 0:不支持 jpeg
/// bit1: 1:支持 h264 0:不支持 h264
@property (nonatomic, assign) uint32_t codec;

/// 采样率 (Mic特有，按BIT使能)
/// 按BIT使能对应
/// `bit0` 1:支持8000 0：不支持 8000,
/// `bit1` 1:支持11025 0：不支持 11025
/// `bit2` 1:支持12000 0：不支持 12000
/// `bit3` 1:支持16000 0：不支持 16000
/// `bit4` 1:支持22050 0：不支持 22050
/// `bit5` 1:支持24000 0：不支持 24000
/// `bit6` 1:支持32000 0：不支持 32000
/// `bit7` 1:支持44100 0：不支持 44100
/// `bit8` 1:支持48000 0：不支持 48000
@property (nonatomic, assign) uint32_t sr;

/// 最大帧率 (Camera 特有)
@property (nonatomic, assign) uint8_t fps;

/// 分辨率宽 (Camera 特有)
@property (nonatomic, assign) uint16_t width;
/// 分辨率高 (Camera 特有)
@property (nonatomic, assign) uint16_t height;

/// 视频配置 (LocalDevice 特有)
/// 若 videoConfig 为 nil 或 videoConfig.codec == 0，说明本设备不支持图像显示功能
@property (nonatomic, strong, nullable) JLStreamVideoConfig *videoConfig;

/// 音频配置 (LocalDevice 特有)
/// 若 audioConfig 为 nil 或 audioConfig.codec == 0，说明本设备不支持音频播放功能
@property (nonatomic, strong, nullable) JLStreamAudioConfig *audioConfig;
@end

/// 获取设备在线外设信息
@interface JLStreamGetInfoResponseModel : NSObject
@property (nonatomic, strong) NSArray<JLStreamPeripheralResponseModel *> *peripherals;
+ (instancetype _Nullable)modelWithData:(NSData *)data;
@end

/// 获取设备在线外设信息
@interface JLStreamGetInfoModel : NSObject
- (NSData *)payloadData;
@end

//MARK: - JLStreamStartTransferModel 开始传输流媒体数据

/// 开启外设请求模型
@interface JLStreamPeripheralRequestModel : NSObject
/// 0x01: Mic, 0x02: Camera
@property (nonatomic, assign) JLStreamDataType type;    
/// 自定自增序号
@property (nonatomic, assign) uint8_t index;  
/// 外设编号
@property (nonatomic, assign) uint8_t number;  
/// 编码格式
/// 若为 Mic 时，参考 JLModel_SPEEX.h 中的 JL_SpeakDataType
/// 若为 Camera 时，参考 JLStreamCameraCodecType
@property (nonatomic, assign) uint8_t codec;   

/// 采样率序号 (Mic特有)
/// 参考 JLStreamAudioSampleRateType，未指定时为最低采样率
@property (nonatomic, assign) uint8_t sr;

/// 帧率 (Camera特有)
@property (nonatomic, assign) uint8_t fps;

/// 分辨率宽 (Camera特有)
@property (nonatomic, assign) uint16_t width;

/// 分辨率高 (Camera特有)
@property (nonatomic, assign) uint16_t height;

/// 快速初始化
/// - Parameters:
///   - type: 0x01: Mic, 0x02: Camera
///   - index: 自定自增序号
///   - number: 外设编号
///   - codec: 编码格式
- (instancetype)initWithType:(JLStreamDataType)type index:(uint8_t)index number:(uint8_t)number codec:(uint8_t)codec;
- (NSData *)payloadData;
@end

/// 开始传输流媒体数据 
@interface JLStreamStartStatusModel : NSObject
/// 请求时的外设自增序号
@property (nonatomic, assign) uint8_t index;
/// 外设类型 (0x01: Mic, 0x02: Camera)
@property (nonatomic, assign) JLStreamDataType type;
/// 0x00: 成功, 0x01: 设备忙/开启失败, 0x02: 参数不支持
@property (nonatomic, assign) JLStreamTransferStatus status;

/// 建议参数 - 编码格式
@property (nonatomic, assign) uint8_t codec;
/// 建议参数 - 采样率 (Mic特有)
@property (nonatomic, assign) uint8_t sr;
/// 建议参数 - 帧率 (Camera特有)
@property (nonatomic, assign) uint8_t fps;
/// 建议参数 - 分辨率宽 (Camera特有)
@property (nonatomic, assign) uint16_t width;
/// 建议参数 - 分辨率高 (Camera特有)
@property (nonatomic, assign) uint16_t height;

@end

/// 开始传输流媒体数据 (响应)
@interface JLStreamStartResponseModel : NSObject
/// 协商后实际MTU
/// 0x00-0xFFFF
@property (nonatomic, assign) uint16_t negotiatedMtu; 
/// 开启外设状态列表
@property (nonatomic, strong) NSArray<JLStreamStartStatusModel *> *statusList;
+ (instancetype _Nullable)modelWithData:(NSData *)data;
@end

/// 开始传输流媒体数据 (请求)
@interface JLStreamStartTransferModel : NSObject
/// 版本号 (当前0x00)
@property (nonatomic, assign) uint8_t version; 
/// 期望MTU
/// 0x00-0xFFFF
@property (nonatomic, assign) uint16_t expectedMtu; 
/// 开启方向 (dir) 0: 请求对方开始的外设, 1: 将要推送给对方的信息
@property (nonatomic, assign) uint8_t dir;
/// 开启外设请求模型
@property (nonatomic, strong) NSArray<JLStreamPeripheralRequestModel *> *peripherals;

/// 快速初始化
/// - Parameters:
///   - mtu: 期望MTU
///   - peripherals: 开启外设请求模型
- (instancetype)initWithExpectedMtu:(uint16_t)mtu peripherals:(NSArray<JLStreamPeripheralRequestModel *> *)peripherals;

- (NSData *)payloadData;

/// 根据接收到的数据解析出模型
/// - Parameter data: payload 数据
+ (instancetype)modelWithData:(NSData *)data;
@end

//MARK: - 停止传输流媒体数据
@interface JLStreamStopTransferModel : NSObject
/// 停止传输请求模型 (包含需要停止的外设index列表)
@property (nonatomic, strong) NSArray< NSNumber*> *indexs;

+(instancetype)modelWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
