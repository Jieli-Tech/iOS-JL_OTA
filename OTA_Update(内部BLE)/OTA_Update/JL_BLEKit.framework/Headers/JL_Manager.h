//
//  JL_Manager.h
//  JL_BLEKit
//
//  Created by DFung on 2018/11/21.
//  Copyright © 20entity.18 www.zh-jieli.com. All rights reserved.
//


#import <Foundation/Foundation.h>
//#import <JL_BLEKit/JL_BLEKit.h>
#import "JL_BLEUsage.h"
#import "JL_TypeEnum.h"

/*--- SDK Version : v1.4.0    ---*/
/*--- SDK Date    : 2020-07-15 ---*/

NS_ASSUME_NONNULL_BEGIN
@class JLDeviceModel;
@class JLRTCModel;
@class JLFileModel;
@class JLFMModel;
@class JLHeadsetModel;
@class JLBTModel;
@class JLEQModel;
@protocol JL_ManagerDelegate <NSObject>
@optional
/**
 蓝牙中心操作状态（发现、配对、断开、蓝牙开、蓝牙关）
 @param array 设备数组
 @param status 状态
 */
-(void)onManagerPeripherals:(NSArray *)array
               updateStatus:(JL_BLEStatus)status;
/**
 配对失败
 */
-(void)onManagerPeripheralPairFailed;
/**
 设备更新系统信息
 @param model 设备模型
 */
-(void)onManagerCommandUpdateDeviceSystemInfo:(JLDeviceModel*)model;
/**
 收到自定义数据
 @param data 数据
 */
-(void)onManagerCommandCustomData:(NSData*)data;
@end

@interface JL_Manager : NSObject
/**
 安装SDK
 */
+(void)installManager;
/**
 移除SDK
 */
+(void)removeManager;
/**
 设置代理
 @param delegate 代理类
 */
+(void)setManagerDelegate:(id<JL_ManagerDelegate>)delegate;
/**
 SDK版本
 @return 版本字符
 */
+(NSString*)versionOfSDK;

#pragma mark - 蓝牙相关API
/**
 开始扫描
 */
+(void)bleStartScan;
/**
 停止扫描
 */
+(void)bleStopScan;
/**
 连接蓝牙外设，如果外设不在已发现的外设列表中，则返回失败
 @param peripheral 要连接的蓝牙外设
 @return 返回是否成功发起连接
 */
+(BOOL)bleConnectToDevice:(CBPeripheral *)peripheral;
/**
 通过本地持久化的UUID连接上一次连接过的设备
 */
+(void)bleConnectLastDevice;
/**
 通过UUID的连接设备
 @param uuid 设备的UUID
 */
+(void)bleConnectDeviceWithUUID:(NSString*)uuid;
    /**
     断开当前连接的蓝牙设备，不会影响下次的自动连接
     */
    +(void)bleDisconnect;
/**
 断开当前连接，并清除连接记录，下次开机后不会自动连接
 */
+(void)bleClean;

#pragma mark - 取出设备信息
+(JLDeviceModel *)outputDeviceModel;

#pragma mark - 设备命令API
/**
 监听语音
 @param result 状态回复
 */
+(void)cmdSpeakMonitorResult:(JL_SPEAK_BK __nullable)result;
/**
 发送命令给音箱，允许音箱端开始接收语音，音箱收到这个消息后会发一个提示音
 */
+(void)cmdAllowSpeak;
/**
 发送命令给音箱，不允许接收语音
 */
+(void)cmdRejectSpeak;
/**
 发发送命令给音箱，停止接收数据，即检测到断句
 */
+(void)cmdSpeakingDone;
/**
 获取LRC歌词
 @param result 返回LRC数据
 */
+(void)cmdLrcMonitorResult:(JL_LRC_BK __nullable)result;
+(void)cmdLrcMonitorResult_1:(JL_LRC_BK_1 __nullable)result;
/**
 获取设备信息
 */
+(void)cmdTargetFeatureResult:(JL_CMD_BK __nullable)result;
/**
 断开经典蓝牙
 @param result 回复
 */
+(void)cmdDisconnectEdrResult:(JL_CMD_BK __nullable)result;
/**
 拨打电话
 @param number 电话号码
 @param result 回复
 */
+(void)cmdPhoneCall:(NSString*)number Result:(JL_CMD_BK __nullable)result;
/**
 获取系统信息（全获取）
 @param function JL_FunctionCode
 @param result 回复
 */
+(void)cmdGetSystemInfo:(JL_FunctionCode)function
                 Result:(JL_CMD_BK __nullable)result;
+(void)cmdGetSystemInfoResult;

/**
 获取系统信息（选择性获取）
 @param function JL_FunctionCode
 @param result 回复
 */
+(void)cmdGetSystemInfo:(JL_FunctionCode)function
           SelectionBit:(uint32_t)bits
                 Result:(JL_CMD_BK __nullable)result;
+(void)cmdGetSystemInfoResult_1;
/**
 设置系统音量
 @param volume 音量值
 */
+(void)cmdSetSystemVolume:(UInt8)volume;
+(void)cmdSetSystemVolume:(UInt8)volume Result:(JL_CMD_BK __nullable)result;
/**
 设置系统EQ
 @param eqMode EQ模式
 @param params EQ参数(10个参数,仅适用于JL_EQModeCUSTOM情况)
 */
+(void)cmdSetSystemEQ:(JL_EQMode)eqMode Params:(NSArray* __nullable)params;

/**
 设置系统时间
 @param date 时间类
 */
+(void)cmdSetSystemTime:(NSDate*)date;
/**
 设置播放模式
 @param mode 模式
 */
+(void)cmdSetSystemPlayMode:(UInt8)mode;
/**
 通用、BT、Music、RTC、Aux
 @param function 功能类型
 @param cmd 操作命令
 @param ext 扩展数据
 @param result 回复
 */
+(void)cmdFunction:(JL_FunctionCode)function
           Command:(UInt8)cmd
            Extend:(UInt8)ext
            Result:(JL_CMD_BK __nullable)result;
/**
 FM相关操作
 @param cmd FM功能
 @param search FM搜索
 @param channel FM频道
 @param frequency FM频点
 @param result 返回结果
 */
+(void)cmdFm:(JL_FCmdFM)cmd
      Saerch:(JL_FMSearch)search
     Channel:(uint8_t)channel
   Frequency:(uint16_t)frequency
      Result:(JL_CMD_BK __nullable)result;
/**
 快进快退
 @param cmd 快进或者快退枚举
 @param sec 时间
 @param result 返回结果
 */
+(void)cmdFastPlay:(JL_FCmdMusic)cmd
            Second:(uint16_t)sec
            Result:(JL_CMD_BK __nullable)result;
/**
 监听目录数据
 @param result 状态回复
 */
+(void)cmdBrowseMonitorResult:(JL_FILE_BK __nullable)result;
/**
 浏览目录
 @param model 文件Model
 @param number 读取的数量
 */
+(void)cmdBrowseModel:(JLFileModel*)model
               Number:(uint8_t)number
               Result:(JL_CMD_BK __nullable)result;
/**
 清除设备音乐缓存记录
 @param type 卡的类型
 */
+(void)cmdCleanCacheType:(JL_CardType)type;

/**
 用户自定义数据
 @param data 数据
 @param result 回复
 */
+(void)cmdCustomData:(NSData* __nullable)data
              Result:(JL_CMD_BK __nullable)result;
/**
 OTA升级文件下载
 @param key 授权key
 @param code 授权code
 @param result 回复
 */
+(void)cmdGetOtaFileKey:(NSString*)key
                   Code:(NSString*)code
                 Result:(JL_OTA_URL __nullable)result;

/**
OTA升级文件下载【MD5】
@param key 授权key
@param code 授权code
@param hash  MD5值
@param result 回复
*/
+(void)cmdGetOtaFileKey:(NSString*)key
                   Code:(NSString*)code
                   hash:(NSString*)hash
                 Result:(JL_OTA_URL __nullable)result;

/**
OTA单备份，是否正在回连
*/
+(BOOL)cmdOtaIsRelinking;

/**
 OTA升级设备
 @param data 升级数据
 @param result 升级结果
 */
+(void)cmdOTAData:(NSData*)data
           Result:(JL_OTA_RT __nullable)result;
/**
 OTA升级取消
 @param result 回复
 */
+(void)cmdOTACancelResult:(JL_CMD_BK __nullable)result;

/**
 重启设备
 */
+(void)cmdRebootDevice;

/**
强制重启设备
*/
+(void)cmdRebootForceDevice;

/**
 设置/增加闹钟
 @param array 闹钟模型数组
 @param result 回复
 */
+(void)cmdRtcSetArray:(NSArray*)array Result:(JL_CMD_BK __nullable)result;

/**
 删除闹钟
 @param array 闹钟序号数组
 @param result 回复
 */
+(void)cmdRtcDeleteIndexArray:(NSArray*)array Result:(JL_CMD_BK __nullable)result;

extern NSString *kJL_RTC_RINGING;       //闹钟正在响
extern NSString *kJL_RTC_RINGSTOP;      //闹钟停止响
/**
 停止闹钟响声
 @param result 回复
 */
+(void)cmdRtcStopResult:(JL_CMD_BK __nullable)result;

/**
 通知固件开始播放TTS内容。
 */
+(void)cmdStartTTSNote;

/**
 获取设备的图片。
 @param vid 设备vid
 @param pid 设备pid
 @param result 图片数据
 */
+(void)cmdRequestDeviceImageVid:(NSString*)vid
                            Pid:(NSString*)pid
                         Result:(JL_IMAGE_RT __nullable)result;
+(NSDictionary*)localDeviceImage:(NSString*)jsonFile;
#pragma mark - 对耳相关API
/**
 设置EDR名字
 @param name EDR名字
 */
+(void)cmdHeatsetEdrName:(NSData*)name;

/**
 按键设置(对耳)
 @param key 左耳0x01 右耳0x02
 @param act 单击0x01 双击0x02
 @param fuc 0x00    无作用
            0x01    开机
            0x02    关机
            0x03    上一曲
            0x04    下一曲
            0x05    播放/暂停
            0x06    接听/挂断
            0x07    拒听
            0x08    拍照
 */
+(void)cmdHeatsetKeySettingKey:(uint8_t)key
                        Action:(uint8_t)act
                      Function:(uint8_t)fuc;
/**
 LED设置(对耳)
 @param scene  0x01   未配对
              0x02    未连接
              0x03    连接
              0x04:   播放设备音乐
              0x05：暂停设备音乐
              0x06：外部音源播放
              0x07：外部音源暂停
 @param effect  0x00    全灭
               0x01    红灯常亮
               0x02    蓝灯常亮
               0x03    红灯呼吸
               0x04    蓝灯呼吸
               0x05    红蓝交替快闪
               0x06    红蓝交替慢闪
 */
+(void)cmdHeatsetLedSettingScene:(uint8_t)scene
                          Effect:(uint8_t)effect;
/**
 MIC设置(耳机)
 @param mode 0： 仅左耳
             1： 仅右耳
             2： 自动选择
 */
+(void)cmdHeatsetMicSettingMode:(uint8_t)mode
                         Result:(JL_CMD_BK __nullable)result;

/**
 工作模式(耳机)
 @param mode 1： 普通模式
             2： 游戏模式
 */
+(void)cmdHeatsetWorkSettingMode:(uint8_t)mode;

/**
 同步时间戳(耳机)
 @param date  当前系统时间
*/
+(void)cmdHeatsetTimeSetting:(NSDate*)date;

/**
 获取设备信息(耳机)
 @param flag  BIT0    小机电量获取 格式为3个字节 参考广播包格式
             BIT1    Edr 名称
             BIT2    按键功能
             BIT3    LED 显示状态
             BIT4    MIC 模式
             BIT5    工作模式
             BIT6    产品信息
             BIT7    连接时间
             BIT8    入耳检测
             BIT9    语言类型
 @param result 返回字典：
                @"ISCHARGING_L"
                @"ISCHARGING_R"
                @"ISCHARGING_C"
                @"POWER_L"
                @"POWER_R"
                @"POWER_C"
                @"EDR_NAME"
                @"KEY_LR"
                @"KEY_ACTION"
                @"KEY_FUNCTION"
                @"LED_SCENE"
                @"LED_EFFECT"
                @"MIC_MODE"
                @"WORK_MODE"
                @"VID"
                @"UID"
                @"PID"
                @"LINK_TIME"
                @""IN_EAR_TEST"
                @"DEVICE_LANGUAGE"
 */
+(void)cmdHeatsetGetAdvFlag:(uint32_t)flag
                     Result:(JL_HEADSET_BK __nullable)result;
/**
 设备广播通知(耳机)
    @{@"JLID": 杰理ID,
    @"VID": ,
    @"PID":  ,
    @"EDR": ,
    @"SCENE": ,
    @"ISCHARGING_L": ,
    @"ISCHARGING_R": ,
    @"ISCHARGING_C": ,
    @"POWER_L": ,
    @"POWER_R": ,
    @"POWER_C": ,
    @"CHIP_TYPE": ,
    @"PROTOCOL_TYPE": ,
    @"SEQ":};
 */
extern NSString *kJL_HEADSET_ADV;

/**
 设置命令成功/错误回复(耳机)
    0x00：成功
    0x01：游戏模式导致设置失效
    0x02：蓝牙名字长度超出限制
    0x03：非蓝牙模式设置闪灯失败
 */
extern NSString *kJL_SET_HEADSET_ERR;

/**
 关闭或开启设备广播(耳机)
 @param enable 使能位
 */
+(void)cmdHeatsetAdvEnable:(BOOL)enable;

#pragma mark kJL_HEADSET_TIPS
/**
 用于ADV设置同步后需要主机操作的行为。
  1：更新配置信息，需要重启生效。
  2：同步时间戳
  3：请求手机回连BLE
  4：同步设备信息
 */
extern NSString *kJL_HEADSET_TIPS;

/**
发射频点
@param fmtx  频点
*/
+(void)cmdSetFMTX:(uint16_t)fmtx;

/// 耳机主动降噪ANC
/// @param mode 模式 (0x01:普通模式 0x02:降噪模式 0x03:通透 模式)
+(void)cmdSetAncMode:(uint8_t)mode;

/// 耳机主动降噪ANC (模式使能)
/// @param modeTypes 支持的模式 @[@(JL_ANCType_Normal),@(JL_ANCType_NoiseReduction).....]
/// JL_ANCType_Normal                      = 0,    //普通模式
/// JL_ANCType_NoiseReduction        = 1,    //降噪模式
/// JL_ANCType_Transparent              = 2,    //通透模式
+(void)cmdSetAncModeTypes:(NSArray *)modeTypes;

/**
主动设置ID3播放状态
*/
+(void)setID3_Status:(uint8_t)st;

///**
//清除ID3播放信息
//*/
//+(void)cleanID3Info_1;
//+(void)cleanID3Info_2;
//+(void)cleanID3Info_3;
extern NSString *kJL_ID3_INFO_Title;
extern NSString *kJL_ID3_INFO_Artist;
extern NSString *kJL_ID3_INFO_AlBum;
extern NSString *kJL_ID3_INFO_Time;


#pragma mark - 智能充电仓
/// 通知固件App的信息
/// @param flag  未知
+(void)cmdSetAppInfo:(uint8_t)flag;

/// 设置通讯MTU
/// @param mtu app请求mtu⼤⼩
/// @param result 实际设置的Mtu⼤⼩
+(void)cmdSetMTU:(uint16_t)mtu Result:(JL_CMD_VALUE_BK __nullable)result;

/// 开启蓝⽛扫描
/// @param timeout 超时时间
/// @param result  0:成功 1:失败
+(void)cmdBTScanStartTimeout:(uint16_t)timeout Result:(JL_CMD_VALUE_BK __nullable)result;

/// 推送蓝⽛扫描结果
/// 返回【蓝⽛数据结构】数组
/// @see JLBTModel
extern NSString *kJL_BT_LIST_RESULT;

/// 停⽌蓝⽛扫描（APP-->固件）
/// @param reason  0：超时结束  1：打断结束  2：开启扫描失败  3：正在扫描
/// @param result  0：成功  1：失败
+(void)cmdBTScanStopReason:(uint8_t)reason Result:(JL_CMD_VALUE_BK __nullable)result;

/// 停⽌蓝⽛扫描（固件-->APP）
/// 0：超时结束  1：打断结束  2：开启扫描失败  3：正在扫描
extern NSString *kJL_BT_SCAN_STOP_NOTE;

/// 通知固件连接指定的蓝⽛设备
/// @param addr 蓝⽛设备地址【设置0x00 00 00 00 00 00 则是断开外设的连接】
/// @param result  0：成功  1：失败
+(void)cmdBTConnectAddress:(NSData*)addr Result:(JL_CMD_VALUE_BK __nullable)result;

#pragma mark ID3 播放/暂停
+(void)cmdID3_PP;

#pragma mark ID3 上一曲
+(void)cmdID3_Before;

#pragma mark ID3 下一曲
+(void)cmdID3_Next;

#pragma mark ID3 开启/暂停 音乐信息推送
+(void)cmdID3_PushEnable:(BOOL)enable;

#pragma mark 设置高低音 [-12,+12]
+(void)cmdSetLowPitch:(int)p_low HighPitch:(int)p_high;

#pragma mark 设置混响值[深度和强度][0,100]、限幅值[-60,0]
+(void)cmdSetReverberation:(int)depthValue IntensityValue:(int)intensityValue
       DynamicLimiterValue:(int)dynamicLimiterValue SwtichReverState:(int) reverOn FunType:(int) type;

#pragma mark 获取MD5数据
+(void)cmdGetMD5_Result:(JL_CMD_BK __nullable)result;

#pragma mark 获取低延时参数
+(void)cmdGetLowDelay:(JL_LOW_DELAY_BK __nullable)result;

#pragma mark 【文件传输 固件-->APP】
#pragma mark 1.监听文件数据
+(void)cmdFileDataMonitorResult:(JL_FILE_DATA_BK __nullable)result;

#pragma mark 2.允许传输文件数据
+(void)cmdAllowFileData;

#pragma mark 3.拒绝传输文件数据
+(void)cmdRejectFileData;

#pragma mark 4.停止传输文件数据
+(void)cmdStopFileData;

#pragma mark 【文件传输 APP-->固件】
#pragma mark 5.请求传输文件给设备
+(void)cmdFileDataSize:(uint8_t)size
              SavePath:(NSString*)path;

#pragma mark 6.推送文件数据给设备
+(void)cmdPushFileData:(NSData*)data;

#pragma mark 7.查找设备
/// 设备查找手机的通知
/// 携带了响铃时长🔔
/// dict = @{@"op":@(操作类型),@"timeout":@(超时时间)};
extern NSString *kJL_BT_FIND_PHONE;
/// 手机查找设备
/// 携带是否停止响铃
/// dict = @{@"op":@(操作类型),@"timeout":@(超时时间)};
extern NSString *kJL_BT_FIND_DEVICE;
/// 查找设备命令
/// @param isVoice 是否发声
/// @param timeout 超时时间
/// @param isIphone 是否设备查找手机（默认是手机找设备）
+(void)cmdFindDevice:(BOOL)isVoice timeOut:(uint16_t)timeout findIphone:(BOOL)isIphone;

#pragma mark 8.设备通话状态
extern NSString *kJL_CALL_STATUS;
@end

#pragma mark - 设备信息MODEL
@interface JLDeviceModel : NSObject<NSCopying>
@property (copy,  nonatomic) NSString           *versionProtocol;//协议版本
@property (copy,  nonatomic) NSString           *versionFirmware;//固件版本
@property (assign,nonatomic) JL_SDKType         sdkType;        //SDK类型
@property (assign,nonatomic) NSUInteger         battery;        //电量0~9
@property (assign,nonatomic) NSUInteger         currentVol;     //当前音量
@property (assign,nonatomic) NSUInteger         maxVol;         //最大音量
@property (copy,  nonatomic) NSString           *btAddr;        //经典蓝牙地址
@property (copy,  nonatomic) NSString           *license;       //平台序列号
@property (assign,nonatomic) JL_DevicePlatform  platform;       //平台类型（图灵，Deepbrain）
@property (assign,nonatomic) JL_DeviceBTStatus  btStatus;       //经典蓝牙状态
@property (assign,nonatomic) uint32_t           function;       //BIT(0):BT BIT(1):MUSIC BIT(2):RTC
@property (assign,nonatomic) JL_FunctionCode    currentFunc;    //当前处于的模式
@property (assign,nonatomic) uint8_t            funcOnlineStatus;//USb,SD,LineIn是否在线
@property (copy,  nonatomic) NSString           *versionUBoot;  //uboot版本
@property (assign,nonatomic) JL_Partition       partitionType;  //设备单、双备份
@property (assign,nonatomic) JL_OtaStatus       otaStatus;      //OTA状态
@property (assign,nonatomic) JL_OtaHeadset      otaHeadset;     //耳机单备份 是否需要强制升级
@property (copy,  nonatomic) NSString           *pidvid;        //厂商ID
@property (copy,  nonatomic) NSString           *authKey;       //授权Key
@property (copy,  nonatomic) NSString           *proCode;       //授权Code
@property (assign,nonatomic) JL_BootLoader      bootLoaderType; //是否下载BootLoader
@property (assign,nonatomic) JL_OtaBleAllowConnect otaBleAllowConnect;  //OTA是否允许BLE连接
@property (assign,nonatomic) JL_BLEOnly         bleOnly;        //是否仅仅支持BLE
@property (assign,nonatomic) JL_FasheEnable     fasheEnable;    //是否支持发射模式
@property (assign,nonatomic) JL_FasheType       fasheType;      //当前是否为发射模式
@property (assign,nonatomic) JL_MD5Type         md5Type;        //是否支持MD5固件校验
@property (assign,nonatomic) JL_GameType        gameType;       //是否为游戏模式
@property (assign,nonatomic) JL_SearchType      searchType;     //是否支持查找设备
@property (assign,nonatomic) JL_AudioFileType   audioFileType;  //是否支持音频文件传输功能
@property (assign,nonatomic) int                pitchLow;       //低音
@property (assign,nonatomic) int                pitchHigh;      //高音
@property (assign,nonatomic) int                reverberationSwitchState;   //混响的开关
@property (assign,nonatomic) int                depthValue;                 //深度值
@property (assign,nonatomic) int                intensityValue;             //强度值
@property (assign,nonatomic) int                dynamicLimiterValue;        //限幅值

/*--- 公用INFO ---*/
@property (copy,  nonatomic) NSArray            *cardArray;     //卡的数组
@property (copy,  nonatomic) NSString           *handleUSB;     //USB   handle
@property (copy,  nonatomic) NSString           *handleSD_0;    //SD_0  handle
@property (copy,  nonatomic) NSString           *handleSD_1;    //SD_1  handle
@property (copy,  nonatomic) NSString           *handleFlash;   //Flash handle
@property (assign,nonatomic) JL_EQMode          eqMode;         //EQ模式
@property (copy,  nonatomic) NSArray            *eqArray;       //EQ参数值（只适用于EQ Mode == CUSTOM情况）
@property (copy,  nonatomic) NSArray            *eqCustomArray; //自定义EQ
@property (copy,  nonatomic) NSArray            *eqFrequencyArray; //EQ频率
@property (assign,nonatomic) JL_EQType          eqType;         //EQ段数类型F
@property (strong,nonatomic) NSArray            *eqDefaultArray;//EQ的预设值数组 数组元素类型-->【JLEQModel】
@property (copy,  nonatomic) NSString           *errReason;     //错误原因
@property (assign,nonatomic) uint16_t           fmtxPoint;      //发射频点
@property (assign,nonatomic) uint8_t            mTWS_Mode;      //0x00:普通模式 0x01:发射模式
@property (assign,nonatomic) uint8_t            mTWS_Status;    //0x00:未连接   0x01:已连接
@property (copy  ,nonatomic) NSString           *mTWS_Addr;     //发射模式中，连接的外设地址
@property (assign,nonatomic) uint8_t            mAncMode;       //耳机降噪模式
@property (strong,nonatomic) NSArray            *mAncModeTypes; //耳机主动降噪所支持模式
@property (strong,nonatomic) NSArray            *reverberationTypes; //混响所支持的类型
@property (assign,nonatomic) JL_CALLType        mCallType;     //通话状态

/*--- BT INFO ---*/
@property (strong,nonatomic) NSString           *ID3_Title;
@property (strong,nonatomic) NSString           *ID3_Artist;
@property (strong,nonatomic) NSString           *ID3_AlBum;
@property (assign,nonatomic) uint8_t            ID3_Number;
@property (assign,nonatomic) uint16_t           ID3_Total;
@property (strong,nonatomic) NSString           *ID3_Genre;
@property (assign,nonatomic) uint32_t           ID3_Time;
@property (assign,nonatomic) uint8_t            ID3_Status;     // 0x01:播放 0x00:暂停
@property (assign,nonatomic) uint32_t           ID3_CurrentTime;

/*--- Music INFO ---*/
@property (assign,nonatomic) JL_MusicStatus     playStatus;     //播放状态
@property (assign,nonatomic) JL_MusicMode       playMode;       //播放模式
@property (assign,nonatomic) uint32_t           currentClus;    //当前播放文件的簇号
@property (assign,nonatomic) uint32_t           currentTime;    //当前时间
@property (assign,nonatomic) uint32_t           tolalTime;      //总时长
@property (assign,nonatomic) JL_CardType        currentCard;    //当前卡
@property (copy,  nonatomic) NSString           *fileName;      //名字
@property (copy,  nonatomic) NSString           *typeSupport;   //解码音频格式

/*--- RTC INFO ---*/
@property (strong,nonatomic) JLRTCModel         *rtcModel;      //设备当前时间
@property (strong,nonatomic) NSMutableArray     *rtcAlarms;     //设备闹钟数组

/*--- LineIn INFO ---*/
@property (assign,nonatomic) JL_LineInStatus    lineInStatus;   //LineIn状态

/*--- FM INFO ---*/
@property (assign,nonatomic) JL_FMStatus        fmStatus;       //Fm状态
@property (assign,nonatomic) JL_FMMode          fmMode;         //Fm 76.0或87.5
@property (strong,nonatomic) JLFMModel          *currentFm;     //当前fm
@property (strong,nonatomic) NSArray            *fmArray;       //Fm列表

-(void)cleanMe;
+(void)observeModelProperty:(NSString*)prty Action:(SEL)action Own:(id)own;
+(void)removeModelProperty:(NSString*)prty Own:(id)own;
@end

#pragma mark - 闹钟MODEL
@interface JLRTCModel : NSObject
@property (assign,nonatomic) uint16_t       rtcYear;
@property (assign,nonatomic) uint8_t        rtcMonth;
@property (assign,nonatomic) uint8_t        rtcDay;
@property (assign,nonatomic) uint8_t        rtcHour;
@property (assign,nonatomic) uint8_t        rtcMin;
@property (assign,nonatomic) uint8_t        rtcSec;
@property (assign,nonatomic) BOOL           rtcEnable;
@property (assign,nonatomic) uint8_t        rtcMode;
@property (assign,nonatomic) uint8_t        rtcIndex;
@property (copy  ,nonatomic) NSString       *rtcName;
@end

#pragma mark - 文件MODEL
@interface JLFileModel : NSObject<NSCopying>
@property (assign,nonatomic) JL_BrowseType fileType;
@property (assign,nonatomic) JL_CardType   cardType;
@property (assign,nonatomic) uint32_t      fileClus;
@property (assign,nonatomic) uint16_t      fileIndex;
@property (copy,  nonatomic) NSString      *fileHandle;
@property (copy,  nonatomic) NSString      *fileName;
@property (copy,  nonatomic) NSString      *folderName;
@property (copy,  nonatomic) NSData *__nullable pathData;
@end

#pragma mark - FM MODEL
@interface JLFMModel : NSObject
@property (assign,nonatomic) uint8_t      fmChannel;
@property (assign,nonatomic) uint16_t     fmFrequency;
@end

#pragma mark - Headset MODEL
@interface JLHeadsetModel : NSObject
@property(assign,nonatomic)BOOL           mCharging_L;
@property(assign,nonatomic)BOOL           mCharging_R;
@property(assign,nonatomic)BOOL           mCharging_C;
@property(assign,nonatomic)uint8_t        mPower;
@property(assign,nonatomic)uint8_t        mPower_L;
@property(assign,nonatomic)uint8_t        mPower_R;
@property(assign,nonatomic)uint8_t        mPower_C;
@property(assign,nonatomic)uint8_t        mLedScene;
@property(assign,nonatomic)uint8_t        mLedEffect;
@property(assign,nonatomic)uint8_t        mKeyLR;
@property(assign,nonatomic)uint8_t        mKeyAction;
@property(assign,nonatomic)uint8_t        mKeyFunction;
@property(assign,nonatomic)uint8_t        mMicMode;
@property(assign,nonatomic)uint8_t        mWorkMode;
@property(strong,nonatomic)NSString       *mEdr;
@end

#pragma mark - Headset MODEL
@interface JLBTModel : NSObject
@property(assign,nonatomic)uint32_t       mBtType;
@property(strong,nonatomic)NSData *__nullable mBtAddress;
@property(assign,nonatomic)uint8_t        mBtRssi;
@property(strong,nonatomic)NSString *__nullable mBtName;
@end

#pragma mark - EQ MODEL
@interface JLEQModel : NSObject
@property(assign,nonatomic)JL_EQMode        mMode;
@property(strong,nonatomic)NSArray *__nullable mEqArray;
@end
NS_ASSUME_NONNULL_END
