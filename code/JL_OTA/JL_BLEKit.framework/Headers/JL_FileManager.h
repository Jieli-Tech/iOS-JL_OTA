//
//  JL_FileManager.h
//  JL_BLEKit
//
//  Created by 凌煊峰 on 2021/12/13.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JLModel_File.h>
#import <JL_BLEKit/JL_FunctionBaseManager.h>
#import <JL_BLEKit/JL_Tools.h>

NS_ASSUME_NONNULL_BEGIN
//MARK: - 枚举
typedef NS_ENUM(UInt8, JL_FileOperationEnvironmentType) {
    JL_FileOperationEnvironmentTypeBigFileTransmission      = 0x00, //大文件传输
    JL_FileOperationEnvironmentTypeDeleteFile               = 0x01, //删除文件
    JL_FileOperationEnvironmentTypeFormatting               = 0x02, //格式化
    JL_FileOperationEnvironmentTypeFatfsTransmission        = 0x03, //FAT文件传输
};
typedef NS_ENUM(UInt8, JL_DeleteFileLastType) {
    JL_DeleteFileLastTypeIsNotLast                  = 0x00, //不是最后一个文件
    JL_DeleteFileLastTypeIsLast                     = 0x01, //是最后一个文件
};
typedef NS_ENUM(UInt8, JL_BrowseReason) {
    JL_BrowseReasonCommandEnd       = 0,    //读取完当前命令请求的文件
    JL_BrowseReasonFolderEnd        = 1,    //读取完当前目录的文件
    JL_BrowseReasonPlaySuccess      = 2,    //点播成功
    JL_BrowseReasonBusy             = 3,    //设备繁忙
    JL_BrowseReasonDataFail         = 4,    //目录数据发送失败
    JL_BrowseReasonReading          = 0x0f, //正在读取中
    JL_BrowseReasonUnknown,                 //未知原因
};
typedef NS_ENUM(UInt8, JL_FileContentResult) {
    JL_FileContentResultStart       = 0x00, //开始传输
    JL_FileContentResultReading     = 0x01, //正在读取
    JL_FileContentResultEnd         = 0x02, //读取结束
    JL_FileContentResultCancel      = 0x03, //取消读取
    JL_FileContentResultFail        = 0x04, //读取失败
    JL_FileContentResultNull        = 0x05, //文件不存在
    JL_FileContentResultDataError   = 0x06, //数据错误
    JL_FileContentResultCrcFail     = 0x07, //crc校验失败
};
typedef NS_ENUM(UInt8, JL_FileDataType) {
    JL_FileDataTypeDo               = 0,    //开始传输文件数据
    JL_FileDataTypeDone             = 1,    //结束传输文件数据
    JL_FileDataTypeDoing            = 2,    //正在传输文件数据
    JL_FileDataTypeCancel           = 3,    //取消传输文件数据
    JL_FileDataTypeError            = 4,    //传输文件数据出错
    JL_FileDataTypeUnknown,
};
typedef NS_ENUM(UInt8, JL_BigFileTransferCode) {
    JL_BigFileTransferCodeSuccess       = 0x00, //成功
    JL_BigFileTransferCodeFail          = 0x01, //写失败
    JL_BigFileTransferCodeOutOfRange    = 0x02, //数据超出范围
    JL_BigFileTransferCodeCrcFail       = 0x03, //crc校验失败
    JL_BigFileTransferCodeOutOfMemory   = 0x04, //内存不足
};
typedef NS_ENUM(UInt8, JL_BigFileResult) {
    JL_BigFileTransferStart         = 0x00, //开始大文件数据传输
    JL_BigFileTransferDownload      = 0x01, //传输大文件有效数据
    JL_BigFileTransferEnd           = 0x02, //结束大文件数据传输
    JL_BigFileTransferOutOfRange    = 0x03, //大文件传输数据超范围
    JL_BigFileTransferFail          = 0x04, //大文件传输失败
    JL_BigFileCrcError              = 0x05, //大文件校验失败
    JL_BigFileOutOfMemory           = 0x06, //空间不足
    JL_BigFileTransferCancel        = 0x07, //取消传输
    JL_BigFileTransferNoResponse    = 0xF1, //设备没有响应
};

//MARK: - 回调

typedef void(^JL_FILE_BK)(NSArray* __nullable array,JL_BrowseReason reason);
typedef void(^JL_FILE_CONTENT_BK)(JL_FileContentResult result, uint32_t size, NSData* __nullable data, float progress);
typedef void(^JL_FILE_DATA_BK)(NSData* __nullable data, NSString* __nullable path, uint16_t size, JL_FileDataType type);
typedef void(^JL_BIGFILE_BK)(NSArray* __nullable array);
typedef void(^JL_BIGFILE_RT)(JL_BigFileResult result, float progress);


/// 文件浏览与下载、上载、删除等相关的操作类
@interface JL_FileManager : JL_FunctionBaseManager

/// 超时时间
@property(nonatomic,assign)NSInteger maxTimeout;

///大文件名是否使用其他编码
///Default：false
///短文件名：GBK  CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
///长文件名：Unicode16L （NSUTF16LittleEndianStringEncoding）
///Other: true
///需要设置encodeType属性的值，默认为Unicode16L
@property(nonatomic,assign)BOOL isOtherEncode;

/// 大文件名使用的编码
/// default :NSUTF16LittleEndianStringEncoding
@property(nonatomic,assign)NSStringEncoding encodeType;

/// 停止超时计算
- (void)closeTimer;


//MARK: - 浏览目录

/// 发起文件目录浏览
/// - Parameters:
///   - model: 文件Model
///   - number: 读取的数量 单次请求建议 ＜ 20 条
///   - result: 回调操作结果
-(void)cmdBrowseModel:(JLModel_File*)model
               Number:(uint8_t)number
               Result:(JL_CMD_RESPOND __nullable)result;

/// 监听目录数据回调
/// - Parameter result: 回调内容
-(void)cmdBrowseMonitorResult:(JL_FILE_BK __nullable)result;



//MARK: -  删除文件

/// 删除文件(必须异步执行)
/// @param array 文件Model数组
-(BOOL)cmdDeleteFileModels:(NSArray*)array;

/// 删除单个JLModel_File文件
/// @param model 文件对象 JLModel_File
/// @param last 是否最后一个文件
/// @param result 删除成功回调
-(void)cmdDeleteFile:(JLModel_File*)model
             IsLast:(JL_DeleteFileLastType)last
             Result:(JL_CMD_RESPOND __nullable)result;

/// 通过名字删除文件
/// 仅部分设备支持（设备要求支持文件系统支持唯一文件名）
/// - Parameters:
///   - name: 文件名
///   - result: 回调结果
-(void)cmdFileDeleteWithName:(NSString*)name Result:(JL_CMD_RESPOND __nullable)result;



/// 设备格式化
/// @param handle 设备句柄
/// @param result 格式化回调
-(void)cmdDeviceFormat:(NSString*)handle Result:(JL_CMD_RESPOND __nullable)result;

/// 清除设备音乐缓存记录
/// @param type 卡的类型
-(void)cmdCleanCacheType:(JL_CardType)type;


//MARK: - 通讯文件句柄相关

/// 设置文件传输句柄
/// 大文件传输，设置当前传输句柄
/// - Parameter currentFileHandleType: 传输句柄
- (void)setCurrentFileHandleType:(JL_FileHandleType)currentFileHandleType;

/// 获取当前的传输文件句柄
- (JL_FileHandleType)getCurrentFileHandleType;

/// 文件传输的句柄数据
- (NSData *)currentDeviceHandleData;

/// 设置当前使用的存储设备
/// @param devHandle 存储设备句柄
/// 可参考JLModel_Device 中获取到的设备句柄内容
/// @param result 命令回调结果
-(void)cmdSetDeviceStorage:(NSData *)devHandle Result:(JL_CMD_RESPOND)result;


//MARK: - 文件传输 固件-->APP

/// 监听文件数据 固件-->APP
/// - Parameter result: 数据内容监听回调
-(void)cmdFileDataMonitorResult:(JL_FILE_DATA_BK __nullable)result __attribute__((deprecated("This method is deprecated. Use newMethod cmdFileReadContentWithName:(NSString*)name Result:(JL_FILE_CONTENT_BK __nullable)result")));

/// app 端回复设备的请求文件传输 固件-->APP
/// 允许传输文件数据
-(void)cmdAllowFileData __attribute__((deprecated("This method is deprecated. Use newMethod cmdFileReadContentWithName:(NSString*)name Result:(JL_FILE_CONTENT_BK __nullable)result")));

/// app 端回复设备的请求文件传输 固件-->APP
/// 拒绝传输文件数据
-(void)cmdRejectFileData __attribute__((deprecated("This method is deprecated. Use newMethod cmdFileReadContentWithName:(NSString*)name Result:(JL_FILE_CONTENT_BK __nullable)result")));

/// 传输文件数据 固件-->APP
/// 停止传输文件数据
-(void)cmdStopFileData __attribute__((deprecated("This method is deprecated. Use newMethod cmdFileReadContentCancel")));

/// 读取外置卡的文件内容 固件-->APP
/// 此方法针对部分设备（要求设备文件系统支持唯一文件名）
/// - Parameters:
///   - name: 文件名
///   - result: 回调结果
-(void)cmdFileReadContentWithName:(NSString*)name Result:(JL_FILE_CONTENT_BK __nullable)result;

/// 簇号方式读取外置卡的文件内容 固件-->APP
/// - Parameters:
///   - fileClus: 文件簇号
///   - result: 回调
- (void)cmdFileReadContentWithFileClus:(uint32_t)fileClus Result:(JL_FILE_CONTENT_BK __nullable)result;

/// 取消读取外置卡的文件内容
-(void)cmdFileReadContentCancel;


//MARK: - 文件传输 APP-->固件

/// 请求传输文件给设备
/// - Parameters:
///   - size: 文件大小
///   - path: 存放路径
-(void)cmdFileDataSize:(uint8_t)size
              SavePath:(NSString*)path __attribute__((deprecated("This method is deprecated. Use newMethod cmdBigFileData:(NSString *)path WithFileName:(NSString *)fileName                                                                 Result:(JL_BIGFILE_RT __nullable)result")));


/// 推送文件数据给设备
/// - Parameter data:文件数据
-(void)cmdPushFileData:(NSData*)data __attribute__((deprecated("This method is deprecated. Use newMethod cmdBigFileData:(NSString *)path WithFileName:(NSString *)fileName                                                               Result:(JL_BIGFILE_RT __nullable)result")));


/// 大文件传输 App-->固件
/// - Parameters:
///   - path: 本地大文件下载文件路径
///   - fileName: 目标文件路径
///   如想指定文件夹路径，可以使用 Download/abc/def.txt
///   否则可以直接添加 def.txt 由系统存放到默认的文件夹下
///   - result: 回调结果
-(void)cmdBigFileData:(NSString *)path WithFileName:(NSString *)fileName
               Result:(JL_BIGFILE_RT __nullable)result;

/// 取消文件传输 App-->固件
-(void)cmdStopBigFileData;

/// 通知固件进行环境准备
/// - Parameters:
///   - environment: 
///   0:大文件传输
///   1:删除文件
///   2：格式化
///   - result: 回调结果
-(void)cmdPreEnvironment:(JL_FileOperationEnvironmentType)environment Result:(JL_CMD_RESPOND __nullable)result;



@end

NS_ASSUME_NONNULL_END
