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
    JL_SDKType693xTWS               = 2,    //
    JL_SDKType695xSDK               = 3,    //
    JL_SDKType697xTWS               = 4,    //
    JL_SDKType696xSB                = 5,    //696x_soundbox
    JL_SDKType696xTWS               = 6,    //
    JL_SDKType695xSC                = 7,    //695x_sound_card
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
    JL_EQModeLATIN                  = 7,    //拉丁
    JL_EQModeDANCE                  = 8,    //舞蹈
};
typedef NS_ENUM(UInt8, JL_Partition) {
    JL_PartitionSingle              = 0,    //固件单备份
    JL_PartitionDouble              = 1,    //固件双备份
};
typedef NS_ENUM(UInt8, JL_OtaHeadset) {
    JL_OtaHeadsetNO                 = 0,    //耳机单备份 正常升级
    JL_OtaHeadsetYES                = 1,    //耳机单备份 强制升级
};
typedef NS_ENUM(UInt8, JL_OtaWatch) {
    JL_OtaWatchNO                   = 0,    //手表资源 正常升级
    JL_OtaWatchYES                  = 1,    //手表资源 强制升级
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
typedef NS_ENUM(UInt8,JL_AncType){          //是否支持ANC
    JL_AncTypeNO                    = 0,    //不支持
    JL_AncTypeYES                   = 1,    //支持
};
typedef NS_ENUM(UInt8, JL_AudioFileType) {  //是否支持音频文件传输
    JL_AudioFileTypeNO              = 0,    //否
    JL_AudioFileTypeYES             = 1,    //是
};
typedef NS_ENUM(UInt8, JL_FileSubcontractTransferCrc16Type){//文件分包传输是否支持crc16方式
    JL_FileSubcontractTransferCrc16TypeNO       = 0,    //不支持
    JL_FileSubcontractTransferCrc16TypeYES      = 1,    //支持
};
typedef NS_ENUM(UInt8, JL_ReadFileInNewWayType){          //是否以新的方式读取固件文件
    JL_ReadFileInNewWayTypeNO                  = 0,    //不支持
    JL_ReadFileInNewWayTypeYES                 = 1,    //支持
};

typedef NS_ENUM(UInt8, JL_EQType) {         //EQ段数类型
    JL_EQType10                     = 0,    //固定10段式
    JL_EQTypeMutable                = 1,    //动态EQ段
};
typedef NS_ENUM(UInt8, JL_FlashSystemType) {
    JL_FlashSystemType_FATFS        = 0,
    JL_FlashSystemType_RCSP         = 1,
};
typedef NS_ENUM(UInt8,JL_AncMode) {
    JL_AncMode_Normal               = 0,    //普通模式
    JL_AncMode_NoiseReduction       = 1,    //降噪模式
    JL_AncMode_Transparent          = 2,    //通透模式
};
typedef NS_ENUM(UInt8,JL_CALLType) {
    JL_CALLType_OFF                 = 0,    //空闲
    JL_CALLType_ON                  = 1,    //通话中
};
typedef NS_ENUM(UInt8,JL_ReverberationType) {
    JL_ReverberationTypeNormal      = 0,     //混响
    JL_ReverberationTypeDynamic     = 1,     //限幅器
};
typedef NS_ENUM(UInt8,JL_AdvType) {
    JL_AdvTypeSoundBox              = 0,     //音箱类型
    JL_AdvTypeChargingBin           = 1,     //充电仓类型
    JL_AdvTypeTWS                   = 2,     //TWS耳机类型
    JL_AdvTypeHeadset               = 3,     //普通耳机类型
    JL_AdvTypeSoundCard             = 4,     //声卡类型
    JL_AdvTypeWatch                 = 5,     //手表类型
    JL_AdvTypeTradition             = 6,     //传统设备类型
};
typedef NS_ENUM(NSInteger,JL_DeviceType) {
    JL_DeviceTypeSoundBox           = 0,     //AI音箱类型
    JL_DeviceTypeTWS                = 1,     //TWS耳机类型
    JL_DeviceTypeChargingBin        = 2,     //充电仓类型
    JL_DeviceTypeHeadset            = 3,     //普通耳机类型
    JL_DeviceTypeSoundCard          = 4,     //声卡类型
    JL_DeviceTypeWatch              = 5,     //手表类型
    JL_DeviceTypeTradition          = -1,    //传统设备类型
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
    JL_MusicStatusPause             = 0x00, //暂停
};
typedef NS_ENUM(UInt8, JL_CardType) {
    JL_CardTypeUSB                  = 0,    //USB
    JL_CardTypeSD_0                 = 1,    //SD_0
    JL_CardTypeSD_1                 = 2,    //SD_1
    JL_CardTypeFLASH                = 3,    //FLASH
    JL_CardTypeLineIn               = 4,    //LineIn
    JL_CardTypeFLASH2               = 5,    //FLASH2
};
typedef NS_ENUM(UInt8, JL_FileHandleType) {     //文件句柄
    JL_FileHandleTypeSD_0                 = 0,    //SD_0
    JL_FileHandleTypeSD_1                 = 1,    //SD_1
    JL_FileHandleTypeFLASH                = 2,    //FLASH
    JL_FileHandleTypeUSB                  = 3,    //USB
    JL_FileHandleTypeLineIn               = 4,    //LineIn
    JL_FileHandleTypeFLASH2               = 5,    //FLASH2
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
typedef NS_ENUM(UInt8, JL_RTCAlarmType) {   //是否支持闹铃设置
    JL_RTCAlarmTypeNO               = 0,    //不支持
    JL_RTCAlarmTypeYES              = 1,    //支持
};
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
#pragma mark - 大文件传输
typedef NS_ENUM(UInt8, JL_FileOperationEnvironmentType) {
    JL_FileOperationEnvironmentTypeBigFileTransmission      = 0x00, //大文件传输
    JL_FileOperationEnvironmentTypeDeleteFile               = 0x01, //删除文件
    JL_FileOperationEnvironmentTypeFormatting               = 0x02, //格式化
    JL_FileOperationEnvironmentTypeFatfsTransmission        = 0x03, //FAT文件传输
};
#pragma mark - 外挂FLASH操作命令
typedef NS_ENUM(UInt8, JL_FlashOperationOPType) {
    JL_FlashOperationOPTypeWriteData             = 0x00, //写数据
    JL_FlashOperationOPTypeReadData              = 0x01, //读数据
    JL_FlashOperationOPTypeInsertFile            = 0x02, //插入文件
    JL_FlashOperationOPTypeDialOperation         = 0x03, //表盘操作
    JL_FlashOperationOPTypeEraseData             = 0x04, //擦除数据
    JL_FlashOperationOPTypeDeleteFile            = 0x05, //删除文件
    JL_FlashOperationOPTypeWriteFileProtection   = 0x06, //写文件保护
    JL_FlashOperationOPTypeUpdateDialResource    = 0x07, //更新表盘资源
    JL_FlashOperationOPTypeCheckWriteDataSuccess = 0x08, //查询写数据是否成功
    JL_FlashOperationOPTypeUpdateResourceFlag    = 0x09, //升级资源标志操作
    JL_FlashOperationOPTypeRestoreSystem         = 0x0A, //还原系统
    JL_FlashOperationOPTypeGetFileInfo           = 0x0B, //获取文件信息
    JL_FlashOperationOPTypeGetRemainingSpace     = 0x0C, //获取剩余空间
};
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
typedef void(^JL_BIGFILE_BK)(NSArray* __nullable array);
typedef void(^JL_BIGFILE_RT)(JL_BigFileResult result, float progress);
typedef void(^JL_FILE_CONTENT_BK)(JL_FileContentResult result, uint32_t size, NSData* __nullable data, float progress);


