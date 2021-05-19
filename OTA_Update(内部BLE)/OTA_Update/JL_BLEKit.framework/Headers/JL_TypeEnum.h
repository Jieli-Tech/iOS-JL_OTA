//
//  JL_TypeEnum.h
//  JL_BLEKit
//
//  Created by DFung on 2018/11/29.
//  Copyright © 2018 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, JL_BLEStatus) {
    JL_BLEStatusFound,                      //发现设备，对应 kUI_JL_BLE_FOUND
    JL_BLEStatusPaired,                     //已配对，  对应 kUI_JL_BLE_PAIRED
    JL_BLEStatusDisconnected,               //断开连接，对应 kUI_JL_BLE_DISCONNECTED
    JL_BLEStatusOn,                         //蓝牙开启，对应 kUI_JL_BLE_ON
    JL_BLEStatusOff,                        //蓝牙关闭，对应 kUI_JL_BLE_OFF
    JL_BLEStatusUnknown,                    //状态未知
};
typedef NS_ENUM(NSInteger, JL_DeviceBTStatus) {
    JL_DeviceBTStatusDisconnected   = 0,    //设备经典蓝牙已断开
    JL_DeviceBTStatusConnected      = 1,    //设备经典蓝牙已连接
    JL_DeviceBTStatusUnknown,
};
typedef NS_ENUM(UInt8, JL_CMDStatus) {
    JL_CMDStatusSuccess             = 0x00, //成功
    JL_CMDStatusFail                = 0x01, //失败
    JL_CMDStatusUnknownCmd          = 0x02, //未定义命令
    JL_CMDStatusBusy                = 0x03, //忙碌
    JL_CMDStatusNoResponse          = 0x04, //没有收到回复
    JL_CMDStatusCrcErr              = 0x05, //CRC错误
    JL_CMDStatusDataCrcErr          = 0x06, //数据CRC错误
    JL_CMDStatusParamErr            = 0x07, //参数错误
    JL_CMDStatusOverLimit           = 0x08, //数据溢出
    JL_CMDStatusLrcError            = 0x09, //LRC获取出错
    JL_CMDStatusUnknown,
};
typedef NS_ENUM(UInt8, JL_DevicePlatform) {
    JL_DevicePlatformTuring         = 0,    //适用于【图灵】
    JL_DevicePlatformDeepbrain      = 1,    //适用于【Deepbrain】
    JL_DevicePlatformUnknown,
};
typedef NS_ENUM(UInt8, JL_SDKType) {
    JL_SDKTypeAI                    = 0,    //AI SDK  AC692x
    JL_SDKTypeST                    = 1,    //标准 SDK AC692x
    JL_SDKType693x                  = 2,    //SDK AC693x
    JL_SDKTypeUnknown,
};
typedef NS_ENUM(UInt8, JL_FunctionMask) {
    JL_FunctionMaskBT               = 1,    //BT
    JL_FunctionMaskMUSIC            = 1<<1, //音乐
    JL_FunctionMaskRTC              = 1<<2, //闹钟
    JL_FunctionMaskLINEIN           = 1<<3, //LineIn
    JL_FunctionMaskFM               = 1<<4, //FM
    JL_FunctionMaskLIGHT            = 1<<5, //LIGHT
    JL_FunctionMaskFMTX             = 1<<6, //发射频点
    JL_FunctionMaskCOMMON           = 0xff, //通用
};
typedef NS_ENUM(UInt8, JL_FunctionCode) {
    JL_FunctionCodeBT               = 0,    //BT
    JL_FunctionCodeMUSIC            = 1,    //音乐
    JL_FunctionCodeRTC              = 2,    //闹钟
    JL_FunctionCodeLINEIN           = 3,    //LineIn
    JL_FunctionCodeFM               = 4,    //FM
    JL_FunctionCodeLIGHT            = 5,    //LIGHT
    JL_FunctionCodeFMTX             = 6,    //发射频点
    JL_FunctionCodeCOMMON           = 0xff, //通用
};
typedef NS_ENUM(UInt8, JL_SpeakType) {
    JL_SpeakTypeDo                  = 0,    //开始录音
    JL_SpeakTypeDone                = 1,    //结束录音
    JL_SpeakTypeDoing               = 2,    //正在录音
    JL_SpeakTypeDoneFail            = 0x0f, //结束失败
};
typedef NS_ENUM(UInt8, JL_SpeakDataType) {
    JL_SpeakDataTypePCM             = 0,    //PCM数据
    JL_SpeakDataTypeSPEEX           = 1,    //SPEEX数据
    JL_SpeakDataTypeOPUS            = 2,    //OPUS数据
};
typedef NS_ENUM(UInt8, JL_FileDataType) {
    JL_FileDataTypeDo               = 0,    //开始传输文件数据
    JL_FileDataTypeDone             = 1,    //结束传输文件数据
    JL_FileDataTypeDoing            = 2,    //正在传输文件数据
    JL_FileDataTypeCancel           = 3,    //取消传输文件数据
    JL_FileDataTypeError            = 4,    //传输文件数据出错
    JL_FileDataTypeUnknown,
};
typedef NS_ENUM(UInt8, JL_EQMode) {
    JL_EQModeNORMAL                 = 0,    //自然
    JL_EQModeROCK                   = 1,    //摇滚
    JL_EQModePOP                    = 2,    //流行
    JL_EQModeCLASSIC                = 3,    //经典
    JL_EQModeJAZZ                   = 4,    //爵士
    JL_EQModeCOUNTRY                = 5,    //乡村
    JL_EQModeCUSTOM                 = 6,    //用户自定义
};
typedef NS_ENUM(UInt8, JL_Partition) {
    JL_PartitionSingle              = 0,    //固件单备份
    JL_PartitionDouble              = 1,    //固件双备份
};
typedef NS_ENUM(UInt8, JL_OtaHeadset) {
    JL_OtaHeadsetNO                 = 0,    //耳机单备份 正常升级
    JL_OtaHeadsetYES                = 1,    //耳机单备份 强制升级
};
typedef NS_ENUM(UInt8, JL_OtaStatus) {
    JL_OtaStatusNormal              = 0,    //正常升级
    JL_OtaStatusForce               = 1,    //强制升级
};
typedef NS_ENUM(UInt8, JL_BootLoader) {
    JL_BootLoaderNO                 = 0,    //不需要下载Bootloader
    JL_BootLoaderYES                = 1,    //需要下载BootLoader
};
typedef NS_ENUM(UInt8, JL_OtaBleAllowConnect) {
    JL_OtaBleAllowConnectYES        = 0,    //OTA 允许BLE连接
    JL_OtaBleAllowConnectNO         = 1,    //OTA 禁止BLE连接
    JL_OtaBleAllowConnectUnknow     = 2,    //未定义
};
typedef NS_ENUM(UInt8, JL_BLEOnly) {        //是否仅仅支持BLE
    JL_BLEOnlyNO                    = 0,    //否
    JL_BLEOnlyYES                   = 1,    //是
};
typedef NS_ENUM(UInt8, JL_FasheEnable) {    //是否发射模式
    JL_FasheEnableNO                = 0,    //否
    JL_FasheEnableYES               = 1,    //是
};
typedef NS_ENUM(UInt8, JL_FasheType) {      //当前是否为发射模式
    JL_FasheTypeNO                  = 0,    //否
    JL_FasheTypeYES                 = 1,    //是
};
typedef NS_ENUM(UInt8, JL_MD5Type) {        //是否支持MD5校验
    JL_MD5TypeNO                    = 0,    //否
    JL_MD5TypeYES                   = 1,    //是
};
typedef NS_ENUM(UInt8, JL_GameType) {       //是否为游戏模式
    JL_GameTypeNO                   = 0,    //否
    JL_GameTypeYES                  = 1,    //是
};
typedef NS_ENUM(UInt8, JL_SearchType) {     //是否支持查找设备
    JL_SearchTypeNO                 = 0,    //否
    JL_SearchTypeYES                = 1,    //是
};
typedef NS_ENUM(UInt8, JL_KaraokeType) {    //是否支持卡拉OK
    JL_KaraokeTypeNO                = 0,    //否
    JL_KaraokeTypeYES               = 1,    //是
};
typedef NS_ENUM(UInt8,JL_KaraokeEQType){    //是否禁止app调节设备音效
    JL_KaraokeEQTypeNO              = 0,    //不禁止
    JL_KaraokeEQTypeYES             = 1,    //禁止
};
typedef NS_ENUM(UInt8,JL_FlashType){        //是否支持外挂Flash
    JL_FlashTypeNO                  = 0,    //不支持
    JL_FlashTypeYES                 = 1,    //支持
};
typedef NS_ENUM(UInt8, JL_AudioFileType) {  //是否支持音频文件传输
    JL_AudioFileTypeNO              = 0,    //否
    JL_AudioFileTypeYES             = 1,    //是
};
typedef NS_ENUM(UInt8, JL_EQType) {         //EQ段数类型
    JL_EQType10                     = 0,    //固定10段式
    JL_EQTypeMutable                = 1,    //动态EQ段
};
typedef NS_ENUM(UInt8,JL_ANCType) {
    JL_ANCType_Normal               = 0,    //普通模式
    JL_ANCType_NoiseReduction       = 1,    //降噪模式
    JL_ANCType_Transparent          = 2,    //通透模式
};
typedef NS_ENUM(UInt8,JL_CALLType) {
    JL_CALLType_OFF                 = 0,    //空闲
    JL_CALLType_ON                  = 1,    //通话中
};
typedef NS_ENUM(UInt8,JL_ReverberationType) {
    JL_ReverberationTypeNormal      = 0,     //混响
    JL_ReverberationTypeDynamic     = 1,     //限幅器
};
//---------------------------------------------------------//
#pragma mark - BT
typedef NS_ENUM(UInt8, JL_FCmdBT) {
    JL_FCmdBTAction                 = 0x01, //BT操作
};
typedef NS_ENUM(UInt8, JL_FExtBT) {
    JL_FExtBtAsUsual                = 0x00, //维持状态不变
    JL_FEXTBtRecovery               = 0x01, //恢复播放
    JL_FExtBtPREV                   = 0x02, //恢复上一曲
    JL_FExtBtNEXT                   = 0x03, //恢复下一曲
    JL_FExtBtPAUSE                  = 0x04, //恢复暂停
    JL_FExtBtPLAY                   = 0x05, //恢复播放
};
//---------------------------------------------------------//
#pragma mark - MUSIC
typedef NS_ENUM(UInt8, JL_FCmdMusic) {
    JL_FCmdMusicPP                  = 0x01, //PP按钮
    JL_FCmdMusicPREV                = 0x02, //上一曲
    JL_FCmdMusicNEXT                = 0x03, //下一曲
    JL_FCmdMusicMODE                = 0x04, //切换播放模式
    JL_FCmdMusicEQ                  = 0x05, //EQ
    JL_FCmdMusicFastBack            = 0x06, //快退
    JL_FCmdMusicFastPlay            = 0x07, //快进
};
typedef NS_ENUM(UInt8, JL_MusicMode) {
    JL_MusicModeLoopAll             = 0x01, //全部循环
    JL_MusicModeLoopDevice          = 0x02, //单设备循环
    JL_MusicModeLoopOne             = 0x03, //单曲循环
    JL_MusicModeRandomDevice        = 0x04, //单设备随机
    JL_MusicModeLoopFolder          = 0x05, //文件夹循环
};
typedef NS_ENUM(UInt8, JL_MusicStatus) {
    JL_MusicStatusPlay              = 0x01, //播放
    JL_MusicStatusPause             = 0x02, //暂停
};
typedef NS_ENUM(UInt8, JL_CardType) {
    JL_CardTypeUSB                  = 0,    //USB
    JL_CardTypeSD_0                 = 1,    //SD_0
    JL_CardTypeSD_1                 = 2,    //SD_1
    JL_CardTypeFLASH                = 3,    //FLASH
    JL_CardTypeLineIn               = 4,    //LineIn
};
typedef NS_ENUM(UInt8, JL_BrowseType) {
    JL_BrowseTypeFolder             = 0,    //文件夹
    JL_BrowseTypeFile               = 1,    //文件
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
typedef NS_ENUM(UInt8, JL_LRCType) {
    JL_LRCTypeDone                  = 1,    //LRC已传输完
    JL_LRCTypeBusy                  = 2,    //设备忙碌
    JL_LRCTypeDoneFail              = 0x0e, //传输失败
};
//---------------------------------------------------------//
#pragma mark - RTC
//---------------------------------------------------------//
#pragma mark - LINEIN
typedef NS_ENUM(UInt8, JL_FCmdLineIn) {
    JL_FCmdLineInPP                 = 0x01, //LINEIN 暂停/播放
};
typedef NS_ENUM(UInt8, JL_LineInStatus) {
    JL_LineInStatusPause            = 0x00, //暂停
    JL_LineInStatusPlay             = 0x01, //播放
    JL_LineInStatusUnknown,
};
//---------------------------------------------------------//
#pragma mark - FM
typedef NS_ENUM(UInt8, JL_FMStatus) {
    JL_FMStatusPause                = 0x01, //播放
    JL_FMStatusPlay                 = 0x02, //暂停
    JL_FMStatusSearching            = 0x03, //搜索中
    JL_FMStatusUnknown,
};
typedef NS_ENUM(UInt8, JL_FMMode) {
    JL_FMMode875Mhz                 = 0x00, //87.5-108.0Mhz
    JL_FMMode760Mhz                 = 0x01, //76.5-108.0Mhz
    JL_FMModeUnknown,
};
typedef NS_ENUM(UInt8, JL_FCmdFM) {
    JL_FCmdFMPP                     = 0x01, //FM 暂停/播放
    JL_FCmdFMPonitBefore            = 0x02, //上一个频点
    JL_FCmdFMPonitNext              = 0x03, //下一个频点
    JL_FCmdFMChannelBefore          = 0x04, //上一个频道
    JL_FCmdFMChannelNext            = 0x05, //下一个频道
    JL_FCmdFMSearch                 = 0x06, //扫描
    JL_FCmdFMChannelSelect          = 0x07, //选择频道
    JL_FCmdFMChannelDelete          = 0x08, //删除频道
    JL_FCmdFMFrequencySelect        = 0x09, //选择频点
    JL_FCmdFMFrequencyDelete        = 0x0a, //删除频点
};
typedef NS_ENUM(UInt8, JL_FMSearch) {
    JL_FMSearchALL                  = 0x00, //FM 暂停/播放
    JL_FMSearchForward              = 0x01, //向前搜索
    JL_FMSearchBackward             = 0x02, //向后搜索
    JL_FMSearchStop                 = 0x03, //停止搜索
};
//---------------------------------------------------------//
/*--- 0x01 升级数据校验失败 ---*/
/*--- 0x02 升级失败 ---*/
/*--- 0x03 加密Key不对 ---*/
/*--- 0x04 升级文件出错 ---*/
/*--- 0x05 uboot不匹配 ---*/
/*--- 0x06 升级过程长度出错 ---*/
/*--- 0x07 升级过程flash读写失败 ---*/
/*--- 0x08 升级过程指令超时 ---*/
#pragma mark - OTA升级
typedef NS_ENUM(UInt8, JL_OTAResult) {
    JL_OTAResultSuccess             = 0x00, //OTA升级成功
    JL_OTAResultFail                = 0x01, //OTA升级失败
    JL_OTAResultDataIsNull          = 0x02, //OTA升级数据为空
    JL_OTAResultCommandFail         = 0x03, //OTA指令失败
    JL_OTAResultSeekFail            = 0x04, //OTA标示偏移查找失败
    JL_OTAResultInfoFail            = 0x05, //OTA升级固件信息错误
    JL_OTAResultLowPower            = 0x06, //OTA升级设备电压低
    JL_OTAResultEnterFail           = 0x07, //未能进入OTA升级模式
    JL_OTAResultUpgrading           = 0x08, //OTA升级中
    JL_OTAResultReconnect           = 0x09, //OTA需重连设备
    JL_OTAResultReboot              = 0x0a, //OTA需设备重启
    JL_OTAResultPreparing           = 0x0b, //OTA准备中
    JL_OTAResultPrepared            = 0x0f, //OTA准备完成
    JL_OTAResultFailVerification    = 0xf1, //升级数据校验失败
    JL_OTAResultFailCompletely      = 0xf2, //升级失败
    JL_OTAResultFailKey             = 0xf3, //升级数据校验失败
    JL_OTAResultFailErrorFile       = 0xf4, //升级文件出错
    JL_OTAResultFailUboot           = 0xf5, //uboot不匹配
    JL_OTAResultFailLenght          = 0xf6, //升级过程长度出错
    JL_OTAResultFailFlash           = 0xf7, //升级过程flash读写失败
    JL_OTAResultFailCmdTimeout      = 0xf8, //升级过程指令超时
    JL_OTAResultFailSameVersion     = 0xf9, //相同版本
    JL_OTAResultFailTWSDisconnect   = 0xfa, //TWS耳机未连接
    JL_OTAResultFailNotInBin        = 0xfb, //耳机未在充电仓
    JL_OTAResultUnknown,                    //OTA未知错误
};
typedef NS_ENUM(UInt8, JL_OTAUrlResult) {
    JL_OTAUrlResultSuccess          = 0x00, //OTA文件获取成功
    JL_OTAUrlResultFail             = 0x01, //OTA文件获取失败
    JL_OTAUrlResultDownloadFail     = 0x02, //OTA文件下载失败
};
//---------------------------------------------------------//

#pragma mark - CallBack
typedef void(^JL_CMD_BK)(NSArray* __nullable array);
typedef void(^JL_CMD_VALUE_BK)(uint32_t value);

typedef void(^JL_HEADSET_BK)(NSDictionary* __nullable dict);
typedef void(^JL_SPEAK_BK)(NSData* __nullable data,
                           NSArray* __nullable array,
                           JL_SpeakType type);
typedef void(^JL_LRC_BK)(NSString* __nullable lrc, JL_LRCType type);
typedef void(^JL_LRC_BK_1)(NSData* __nullable lrc, JL_LRCType type);
typedef void(^JL_FILE_BK)(NSArray* __nullable array,JL_BrowseReason reason);
typedef void(^JL_OTA_BK)(NSArray* __nullable array);
typedef void(^JL_OTA_URL)(JL_OTAUrlResult result,
                          NSString* __nullable version,
                          NSString* __nullable url,
                          NSString* __nullable explain);
typedef void(^JL_OTA_RT)(JL_OTAResult result, float progress);
typedef void(^JL_IMAGE_RT)(NSMutableDictionary* __nullable dict);

typedef void(^JL_BT_LIST)(NSArray* __nullable array);
typedef void(^JL_FILE_DATA_BK)(NSData* __nullable data,
                               NSString* __nullable path,
                               uint16_t size,
                               JL_FileDataType type);
typedef void(^JL_LOW_DELAY_BK)(uint16_t mtu, uint32_t delay);
