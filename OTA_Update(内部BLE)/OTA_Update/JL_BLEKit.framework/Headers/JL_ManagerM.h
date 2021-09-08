//
//  JL_ManagerM.h
//  JL_BLEKit
//
//  Created by 杰理科技 on 2020/9/4.
//  Copyright © 2020 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JL_TypeEnum.h"
#import "JL_RCSP.h"

NS_ASSUME_NONNULL_BEGIN

@class JLModel_Device;
@class JLModel_RTC;
@class JLModel_File;
@class JLModel_FM;
@class JLModel_Headset;
@class JLModel_BT;
@class JLModel_EQ;
@class JLModel_SPEEX;
@class JLModel_Flash;
@class JLModel_ANC;
@class JLModel_AlarmSetting;
/*
 *  从JL_ManagerM发出去的通知都是字典，如下所示：
 *
 *  @{ kJL_MANAGER_KEY_UUID  :当前设备的UUID,
 *     kJL_MANAGER_KEY_OBJECT:外抛的对象 }
 */
extern NSString *kJL_MANAGER_KEY_UUID;      //KEY --> UUID
extern NSString *kJL_MANAGER_KEY_OBJECT;    //KEY --> 对象

@protocol JL_ManagerMDelegate <NSObject>
@optional
-(void)onManagerSendPackage:(JL_PKG*)pkg;

@end

@interface JL_ManagerM : NSObject
@property(nonatomic,weak)id<JL_ManagerMDelegate>delegate;
@property(nonatomic,readonly,copy)NSString *mBLE_UUID;
@property(nonatomic,readonly,copy)NSString *mBLE_NAME;

-(void)setBleUuid:(NSString*)uuid;
-(void)setBleName:(NSString*)name;

-(void)inputPKG:(JL_PKG*)pkg;

/**
 发送【命令包】
 @param cmdCode 具体要发送的命令
 @param needResponse 是否需要回复
 @param sendData 具体要发送的数据
 @discussion 只有isCommand是YES时needResponse才有意义，即只有命令才需要回复
 */
-(void)xmCommandCode:(uint8_t)cmdCode
             needRep:(BOOL)needResponse
                data:(NSData *)sendData;
/**
 发送【回复包】
 @param code  命令号
 @param sn      序号
 @param st      状态码
 @param data 回复的命令的内容
 */
-(void)cmdResponseCode:(uint8_t)code
                  OpSN:(UInt8)sn
                Status:(JL_CMDStatus)st
                  Data:(NSData*)data;
/**
  获取当前命令序号
 */
-(uint8_t)xmCommandSN;

#pragma mark ---> 取出设备信息
-(JLModel_Device *)outputDeviceModel;

#pragma mark ---> SPEEX语音
/**
    语音操作状态
    kJL_MANAGER_KEY_OBJECT  ==>  JLModel_SPEEX
*/
extern NSString *kJL_MANAGER_SPEEX;

/**
    语音数据
    kJL_MANAGER_KEY_OBJECT  ==>  NSData
*/
extern NSString *kJL_MANAGER_SPEEX_DATA;

/**
 发送命令给音箱，允许音箱端开始接收语音，音箱收到这个消息后会发一个提示音
 */
-(void)cmdAllowSpeak;

/** 拒绝录音
 发送命令给音箱，不允许接收语音
 */
-(void)cmdRejectSpeak;

/** 停止语音
 发发送命令给音箱，停止接收数据，即检测到断句
 */
-(void)cmdSpeakingDone;

#pragma mark ---> 获取LRC歌词
/**
 @param result 返回LRC数据
 */
-(void)cmdLrcMonitorResult:(JL_LRC_BK __nullable)result;
-(void)cmdLrcMonitorResult_1:(JL_LRC_BK_1 __nullable)result;

#pragma mark ---> 获取设备信息
extern NSString *kJL_MANAGER_TARGET_INFO;
-(void)cmdTargetFeatureResult:(JL_CMD_BK __nullable)result;
-(void)cmdTargetFeature:(uint32_t)feature Result:(JL_CMD_BK __nullable)result;

#pragma mark ---> 断开经典蓝牙
-(void)cmdDisconnectEdrResult:(JL_CMD_BK __nullable)result;

#pragma mark ---> 拨打电话
/**
 @param number 电话号码
 @param result 回复
 */
-(void)cmdPhoneCall:(NSString*)number Result:(JL_CMD_BK __nullable)result;

#pragma mark ---> 获取系统信息（全获取）
/**
 @param function JL_FunctionCode
 @param result 回复
 */
-(void)cmdGetSystemInfo:(JL_FunctionCode)function
                 Result:(JL_CMD_BK __nullable)result;
-(void)cmdGetSystemInfoResult;

#pragma mark ---> 获取系统信息（选择性获取）
/**
 @param function JL_FunctionCode
 @param result 回复
 */
-(void)cmdGetSystemInfo:(JL_FunctionCode)function
           SelectionBit:(uint32_t)bits
                 Result:(JL_CMD_BK __nullable)result;
-(void)cmdGetSystemInfoResult_1;

#pragma mark ---> 设备主动返回的系统信息
extern NSString *kJL_MANAGER_SYSTEM_INFO;



#pragma mark ---> 设置系统音量
/**
 @param volume 音量值
 */
-(void)cmdSetSystemVolume:(UInt8)volume;
-(void)cmdSetSystemVolume:(UInt8)volume Result:(JL_CMD_BK __nullable)result;

#pragma mark ---> 设置系统EQ
/**
 @param eqMode EQ模式
 @param params EQ参数(10个参数,仅适用于JL_EQModeCUSTOM情况)
 */
-(void)cmdSetSystemEQ:(JL_EQMode)eqMode Params:(NSArray* __nullable)params;

#pragma mark ---> 设置系统时间
/**
 @param date 时间类
 */
-(void)cmdSetSystemTime:(NSDate*)date;

#pragma mark ---> 设置播放模式
/**
 @param mode 模式
 */
-(void)cmdSetSystemPlayMode:(UInt8)mode;

#pragma mark ---> 通用、BT、Music、RTC、Aux
/**
 @param function 功能类型
 @param cmd 操作命令
 @param ext 扩展数据
 @param result 回复
 */
-(void)cmdFunction:(JL_FunctionCode)function
           Command:(UInt8)cmd
            Extend:(UInt8)ext
            Result:(JL_CMD_BK __nullable)result;

#pragma mark ---> FM相关操作
/**
 @param cmd FM功能
 @param search FM搜索
 @param channel FM频道
 @param frequency FM频点
 @param result 返回结果
 */
-(void)cmdFm:(JL_FCmdFM)cmd
      Saerch:(JL_FMSearch)search
     Channel:(uint8_t)channel
   Frequency:(uint16_t)frequency
      Result:(JL_CMD_BK __nullable)result;

#pragma mark ---> 快进快退
/**
 @param cmd 快进或者快退枚举
 @param sec 时间
 @param result 返回结果
 */
-(void)cmdFastPlay:(JL_FCmdMusic)cmd
            Second:(uint16_t)sec
            Result:(JL_CMD_BK __nullable)result;

#pragma mark ---> 设置/增加闹钟
/**
 @param array 闹钟模型数组
 @param result 回复
 */
-(void)cmdRtcSetArray:(NSArray*)array Result:(JL_CMD_BK __nullable)result;

#pragma mark ---> 删除闹钟
/**
 @param array 闹钟序号数组
 @param result 回复
 */
-(void)cmdRtcDeleteIndexArray:(NSArray*)array Result:(JL_CMD_BK __nullable)result;

#pragma mark ---> 停止闹钟响声
-(void)cmdRtcStopResult:(JL_CMD_BK __nullable)result;
#pragma mark --> 闹钟试听响铃
-(void)cmdRtcAudition:(JLModel_RTC *)rtc Option:(BOOL) option result:(JL_CMD_BK __nullable)result;

#pragma mark ---> 闹钟响与停止
extern NSString *kJL_MANAGER_RTC_RINGING;       //闹钟正在响
extern NSString *kJL_MANAGER_RTC_RINGSTOP;      //闹钟停止响
extern NSString *kJL_MANAGER_RTC_AUDITION;      //闹钟铃声试听

typedef void(^JL_RTC_ALARM_BK)(NSArray <JLModel_AlarmSetting *>* __nullable array, uint8_t flag);
#pragma mark ---> 闹铃设置
/**
 @param operate 0x00:读取 0x01:设置
 @param index     掩码
 @param setting 设置选项，读取时无需传入
 @param result 回复
 */
-(void)cmdRtcOperate:(uint8_t)operate
               Index:(uint8_t)index
             Setting:(JLModel_AlarmSetting* __nullable)setting
              Result:(JL_RTC_ALARM_BK __nullable)result;

#pragma mark ---> 通知固件开始播放TTS内容
-(void)cmdStartTTSNote;

#pragma mark ---> 批操作命令
typedef void(^JL_BATCH_BK)(uint8_t flag);
/**
 @param type      0x00:开始 0x80:结束 0x81:结束
 @param array    @[@(0x00)]，0x00代表格式化操作。
 @param result  操作回调 0x00:成功 0x01:失败
 */
-(void)cmdBatchType:(uint8_t)type Operations:(NSArray*)array Result:(JL_BATCH_BK)result;

#pragma mark ---> 用户自定义数据
/**
 @param data 数据
 @param result 回复
 */
-(void)cmdCustomData:(NSData* __nullable)data
              Result:(JL_CMD_BK __nullable)result;
#pragma mark ---> 设备返回的自定义数据
extern NSString *kJL_MANAGER_CUSTOM_DATA;


#pragma mark ---> 监听目录数据
/**
 @param result 状态回复
 */
-(void)cmdBrowseMonitorResult:(JL_FILE_BK __nullable)result;

#pragma mark ---> 浏览目录
/**
 @param model 文件Model
 @param number 读取的数量
 */
-(void)cmdBrowseModel:(JLModel_File*)model
               Number:(uint8_t)number
               Result:(JL_CMD_BK __nullable)result;

#pragma mark ---> 删除文件(必须异步执行)
/**
 @param array 文件Model数组
 */
-(BOOL)cmdDeleteFileModels:(NSArray*)array;

#pragma mark 设备格式化
//@param model 设备句柄
-(void)cmdDeviceFormat:(NSString*)handle Result:(JL_CMD_BK __nullable)result;

#pragma mark ---> 清除设备音乐缓存记录
/**
 @param type 卡的类型
 */
-(void)cmdCleanCacheType:(JL_CardType)type;
   

#pragma mark - 对耳相关API

#pragma mark ---> 修改设备名字
/**
 @param name EDR名字
 */
-(void)cmdHeatsetEdrName:(NSData*)name;

#pragma mark ---> 按键设置(对耳)
/**
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
-(void)cmdHeatsetKeySettingKey:(uint8_t)key
                        Action:(uint8_t)act
                      Function:(uint8_t)fuc;

#pragma mark ---> LED设置(对耳)
/**
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
-(void)cmdHeatsetLedSettingScene:(uint8_t)scene
                          Effect:(uint8_t)effect;

#pragma mark ---> MIC设置(耳机)
/**
 @param mode 0： 仅左耳
             1： 仅右耳
             2： 自动选择
 */
-(void)cmdHeatsetMicSettingMode:(uint8_t)mode
                         Result:(JL_CMD_BK __nullable)result;

#pragma mark ---> 工作模式(耳机)
/**
 @param mode 1： 普通模式
             2： 游戏模式
 */
-(void)cmdHeatsetWorkSettingMode:(uint8_t)mode;

#pragma mark ---> 同步时间戳(耳机)
/**
 @param date  当前系统时间
*/
-(void)cmdHeatsetTimeSetting:(NSDate*)date;

#pragma mark ---> 获取设备信息(耳机)
/**
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
                @"KEY_ANC_MODE"    ANC的模式数组
 */
-(void)cmdHeatsetGetAdvFlag:(uint32_t)flag
                     Result:(JL_HEADSET_BK __nullable)result;

#pragma mark ---> 设备广播通知(耳机)
/**
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
extern NSString *kJL_MANAGER_HEADSET_ADV;

#pragma mark ---> 设置命令成功/错误回复(耳机)
/**
    0x00：成功
    0x01：游戏模式导致设置失效
    0x02：蓝牙名字长度超出限制
    0x03：非蓝牙模式设置闪灯失败
 */
extern NSString *kJL_MANAGER_HEADSET_SET_ERR;

#pragma mark ---> 关闭或开启设备广播(耳机)
/**
 @param enable 使能位
 */
-(void)cmdHeatsetAdvEnable:(BOOL)enable;

#pragma mark ---> 用于ADV设置同步后需要主机操作的行为。
/**
  1：更新配置信息，需要重启生效。
  2：同步时间戳
  3：请求手机回连BLE
  4：同步设备信息
 */
extern NSString *kJL_MANAGER_HEADSET_TIPS;

#pragma mark ---> 发射频点
/**
@param fmtx  频点
*/
-(void)cmdSetFMTX:(uint16_t)fmtx;

#pragma mark ---> 设置耳机ANC模式列表
-(void)cmdHeatsetAncArray:(NSArray*)array;

#pragma mark ---> 耳机主动降噪ANC设置
-(void)cmdSetANC:(JLModel_ANC*)model;


#pragma mark ---> 获取设备的图片
/**
 @param vid 设备vid
 @param pid 设备pid
 @param result 图片数据
 */
-(void)cmdRequestDeviceImageVid:(NSString*)vid
                            Pid:(NSString*)pid
                         Result:(JL_IMAGE_RT __nullable)result;

-(void)cmdRequestDeviceImageVid:(NSString*)vid
                            Pid:(NSString*)pid
                      ItemArray:(NSArray *__nullable)itemArray
                         Result:(JL_IMAGE_RT __nullable)result;

-(NSDictionary*)localDeviceImage:(NSString*)jsonFile;

#pragma mark ---> ID3信息
extern NSString *kJL_MANAGER_ID3_Title;
extern NSString *kJL_MANAGER_ID3_Artist;
extern NSString *kJL_MANAGER_ID3_Album;
extern NSString *kJL_MANAGER_ID3_Time;

#pragma mark ---> 主动设置ID3播放状态
-(void)setID3_Status:(uint8_t)st;

#pragma mark - 智能充电仓
#pragma mark ---> 通知固件App的信息
// @param flag  未知
-(void)cmdSetAppInfo:(uint8_t)flag;

#pragma mark ---> 设置通讯MTU
// @param mtu app请求mtu⼤⼩
// @param result 实际设置的Mtu⼤⼩
-(void)cmdSetMTU:(uint16_t)mtu Result:(JL_CMD_VALUE_BK __nullable)result;

#pragma mark ---> 开启蓝⽛扫描
// @param timeout 超时时间
// @param result  0:成功 1:失败
-(void)cmdBTScanStartTimeout:(uint16_t)timeout Result:(JL_CMD_VALUE_BK __nullable)result;

#pragma mark ---> 推送蓝⽛扫描结果
// 返回【蓝⽛数据结构】数组
// @see JLBTModel
extern NSString *kJL_MANAGER_BT_LIST_RESULT;

#pragma mark ---> 停⽌蓝⽛扫描（APP-->固件）
// @param reason  0：超时结束  1：打断结束  2：开启扫描失败  3：正在扫描
// @param result  0：成功  1：失败
-(void)cmdBTScanStopReason:(uint8_t)reason Result:(JL_CMD_VALUE_BK __nullable)result;

#pragma mark ---> 停⽌蓝⽛扫描（固件-->APP）
// 0：超时结束  1：打断结束  2：开启扫描失败  3：正在扫描
extern NSString *kJL_MANAGER_BT_SCAN_STOP_NOTE;

#pragma mark ---> 通知固件连接指定的蓝⽛设备
// @param addr 蓝⽛设备地址【设置0x00 00 00 00 00 00 则是断开外设的连接】
// @param result  0：成功  1：失败
-(void)cmdBTConnectAddress:(NSData*)addr Result:(JL_CMD_VALUE_BK __nullable)result;

#pragma mark ---> ID3 播放/暂停
-(void)cmdID3_PP;

#pragma mark ---> ID3 上一曲
-(void)cmdID3_Before;

#pragma mark ---> ID3 下一曲
-(void)cmdID3_Next;

#pragma mark ---> ID3 开启/暂停 音乐信息推送
-(void)cmdID3_PushEnable:(BOOL)enable;

#pragma mark ---> 设置高低音 [-12,+12]
-(void)cmdSetLowPitch:(int)p_low HighPitch:(int)p_high;

#pragma mark ---> 设置混响值[深度和强度][0,100]、限幅值[-60,0]
-(void)cmdSetReverberation:(int)depthValue
            IntensityValue:(int)intensityValue
       DynamicLimiterValue:(int)dynamicLimiterValue
          SwtichReverState:(int)reverOn
                   FunType:(int)type;

extern NSString *kJL_MANAGER_KALAOK_Data;
#pragma mark ---> 设置卡拉OK【index、value】
-(void)cmdSetKalaokIndex:(uint8_t)index Value:(uint16_t) value;

#pragma mark ---> 设置卡拉OK【MIC EQ增益】
-(void)cmdSetKaraokeMicEQ:(NSArray*)array;

#pragma mark ---> 设置灯光
-(void)cmdSetState:(uint8_t)lightState
              Mode:(uint8_t)lightMode
               Red:(uint8_t)red
             Green:(uint8_t)green
              Blue:(uint8_t)blue
         FlashInex:(uint8_t)flashIndex
         FlashFreq:(uint8_t)flashFreqIndex
        SceneIndex:(uint8_t)sceneIndex
               Hue:(uint16_t)hue
        Saturation:(uint8_t)saturation
         Lightness:(uint8_t)lightness;

#pragma mark ---> 获取MD5数据
-(void)cmdGetMD5_Result:(JL_CMD_BK __nullable)result;

#pragma mark ---> 获取低延时参数
-(void)cmdGetLowDelay:(JL_LOW_DELAY_BK __nullable)result;

#pragma mark --->【文件传输 固件-->APP】
#pragma mark 1.监听文件数据
-(void)cmdFileDataMonitorResult:(JL_FILE_DATA_BK __nullable)result;

#pragma mark 2.允许传输文件数据
-(void)cmdAllowFileData;

#pragma mark 3.拒绝传输文件数据
-(void)cmdRejectFileData;

#pragma mark 4.停止传输文件数据
-(void)cmdStopFileData;

#pragma mark --->【文件传输 APP-->固件】
#pragma mark 5.请求传输文件给设备
-(void)cmdFileDataSize:(uint8_t)size
              SavePath:(NSString*)path;

#pragma mark 6.推送文件数据给设备
-(void)cmdPushFileData:(NSData*)data;

#pragma mark 【大文件传输 App-->固件】
// @param  path       大文件下载文件路径
// @param  fileName   大文件下载文件名称
// @param  result     大文件下载结果
-(void)cmdBigFileData:(NSString *)path WithFileName:(NSString *)fileName
               Result:(JL_BIGFILE_RT __nullable)result;

#pragma mark 取消文件传输
-(void)cmdStopBigFileData;

#pragma mark 通知固件进行环境准备
// @param  environment 0:大文件传输 1:删除文件 2：格式化
-(void)cmdPreEnvironment:(JL_FileOperationEnvironmentType)environment Result:(JL_CMD_BK __nullable)result;

#pragma mark 通过名字删除文件
-(void)cmdFileDeleteWithName:(NSString*)name Result:(JL_CMD_BK __nullable)result;

#pragma mark 设置文件传输句柄
/**
 *  大文件传输，设置当前传输句柄 for crc16
 */
- (void)setCurrentFileHandleType:(JL_FileHandleType)currentFileHandleType;
- (JL_FileHandleType)getCurrentFileHandleType;

#pragma mark ---> 查找设备
// 设备查找手机的通知
// 携带了响铃时长🔔
// dict = @{@"op":@(操作类型),@"timeout":@(超时时间)};
extern NSString *kJL_MANAGER_FIND_PHONE;
// 手机查找设备
// 携带是否停止响铃
// dict = @{@"op":@(操作类型),@"timeout":@(超时时间)};
extern NSString *kJL_MANAGER_FIND_DEVICE;
// 查找设备命令
// @param isVoice 是否发声
// @param timeout 超时时间
// @param isIphone 是否设备查找手机（默认是手机找设备）
// @param opDict 这是一个可选项，若tws未连接，则该值无效，默认是全部播放
// 字典键值对说明：
// 播放方式 way: 0  全部播放
//             1  左侧播放
//             2  右侧播放
// 播放源 player: 0 APP端播放
//               1 设备端播放
// etc.全部播放&APP播放音效
// opDict：{@"way":@"0",@"player":@"0"}
-(void)cmdFindDevice:(BOOL)isVoice
             timeOut:(uint16_t)timeout
          findIphone:(BOOL)isIphone
           Operation:( NSDictionary * _Nullable )opDict;

#pragma mark ---> 设备通话状态
extern NSString *kJL_MANAGER_CALL_STATUS;

#pragma mark - OTA升级
#pragma mark ---> OTA升级文件下载
/**
 @param key 授权key
 @param code 授权code
 @param result 回复
 */
-(void)cmdGetOtaFileKey:(NSString*)key
                   Code:(NSString*)code
                 Result:(JL_OTA_URL __nullable)result;

#pragma mark ---> OTA升级文件下载【MD5】
/**
@param key 授权key
@param code 授权code
@param hash  MD5值
@param result 回复
*/
-(void)cmdGetOtaFileKey:(NSString*)key
                   Code:(NSString*)code
                   hash:(NSString*)hash
                 Result:(JL_OTA_URL __nullable)result;

#pragma mark ---> OTA单备份，是否正在回连
-(BOOL)cmdOtaIsRelinking;

#pragma mark ---> OTA升级设备
/**
 @param data 升级数据
 @param result 升级结果
 */
-(void)cmdOTAData:(NSData*)data
           Result:(JL_OTA_RT __nullable)result;

#pragma mark ---> OTA升级取消
/**
 @param result 回复
 */
-(void)cmdOTACancelResult:(JL_CMD_BK __nullable)result;

#pragma mark ---> 重启设备
-(void)cmdRebootDevice;

#pragma mark ---> 强制重启设备
-(void)cmdRebootForceDevice;


#pragma mark - Watch OTA
typedef void(^JL_FlashInfo_BK)(JLModel_Flash* __nullable model);
typedef void(^JL_FlashWrite_BK)(uint8_t flag);
typedef void(^JL_FlashWriteStatus_BK)(uint8_t flag,uint16_t leftSize);
typedef void(^JL_FlashWriteSize_BK)(uint8_t flag,uint32_t size);
typedef void(^JL_FlashRead_BK)(uint8_t flag,NSData *__nullable data);
typedef void(^JL_FlashAddOrDel_BK)(uint8_t flag);
typedef void(^JL_FlashWatch_BK)(uint8_t flag, uint32_t size,
                                NSString *__nullable path,
                                NSString *__nullable describe);
typedef void(^JL_FlashClean_BK)(uint8_t flag);
typedef void(^JL_FlashProtect_BK)(uint8_t flag);
typedef void(^JL_FlashUpdate_BK)(uint8_t flag);
typedef void(^JL_FlashFileInfo_BK)(uint32_t size,uint16_t crc16);
typedef void(^JL_FlashLeftSize_BK)(uint32_t leftSize);


#pragma mark ---> 获取外置Flash信息
/**
 获取外置Flash信息
 @param result 回复
 */
-(void)cmdGetFlashInfoResult:(JL_FlashInfo_BK __nullable)result;

#pragma mark ---> 写数据到Flash
/**
 写数据到Flash
 @param data        数据
 @param offset   偏移
 @param mtu         每包大小
 @param result   回复
 */
-(void)cmdWriteToFlashAllData:(NSData*)data
                       Offset:(uint32_t)offset
                          Mtu:(uint16_t)mtu
                       Result:(JL_FlashWriteSize_BK __nullable)result;

#pragma mark ---> 读数据从Flash
/**
 读数据从Flash
 @param offset  偏移
 @param size    大小
 @param mtu     每包大小
 @param result  回复
 */
-(void)cmdReadFromFlashAllDataOffset:(uint32_t)offset
                                Size:(uint16_t)size
                                 Mtu:(uint16_t)mtu
                              Result:(JL_FlashRead_BK __nullable)result;

#pragma mark ---> [开始/结束]增加表盘(文件)
/**
 开始/结束 插入文件
 @param path        路径
 @param size        大小
 @param flag        开始:0x01  结束:0x00
 @param result    回复
 */
-(void)cmdInsertFlashPath:(NSString* __nullable)path
                     Size:(uint32_t)size
                     Flag:(uint8_t)flag
                   Result:(JL_FlashAddOrDel_BK __nullable)result;

#pragma mark ---> 设置表盘(文件)
/**
 表盘操作
 @param path    路径
 @param flag    0x00:读取
                0x01:设置
                0x03:版本
                0x04:激活自定义表盘
                0x05:获取对应的自定义表盘名字
 @param result  回复
 */
-(void)cmdWatchFlashPath:(NSString*__nullable)path
                    Flag:(uint8_t)flag
                  Result:(JL_FlashWatch_BK __nullable)result;

#pragma mark ---> 设备更新表盘(文件) 【kJL_MANAGER_WATCH_FACE】?// 返回 字符串
extern NSString *kJL_MANAGER_WATCH_FACE;

#pragma mark ---> [开始/结束]删除表盘(文件)
/**
 开始/结束 删除文件
 @param path        路径
 @param flag        开始:0x01  结束:0x00
 @param result    回复
 */
-(void)cmdDeleteFlashPath:(NSString* __nullable)path
                     Flag:(uint8_t)flag
                   Result:(JL_FlashAddOrDel_BK __nullable)result;

#pragma mark ---> 外挂Flash【写保护】操作
/**
 开始/结束
 @param flag        开始:0x01  结束:0x00
 */
-(void)cmdWriteProtectFlashFlag:(uint8_t)flag Result:(JL_FlashProtect_BK __nullable)result;

#pragma mark ---> 外挂Flash【资源更新】操作
/**
 开始/结束 更新UI
 @param flag        开始:0x01  结束:0x00
 */
-(void)cmdUpdateResourceFlashFlag:(uint8_t)flag Result:(JL_FlashUpdate_BK __nullable)result;

#pragma mark ---> 断开连接，对FATFS处理。
-(void)cmdFlashActionDisconnect;

#pragma mark ---> 读取外置卡的文件内容
-(void)cmdFileReadContentWithName:(NSString*)name Result:(JL_FILE_CONTENT_BK __nullable)result;

#pragma mark ---> 簇号方式读取外置卡的文件内容
- (void)cmdFileReadContentWithFileClus:(uint32_t)fileClus Result:(JL_FILE_CONTENT_BK __nullable)result;

#pragma mark ---> 取消读取外置卡的文件内容
-(void)cmdFileReadContentCancel;

#pragma mark ---> 外挂Flash 手表资源更新标志位
-(void)cmdWatchUpdateResource;

#pragma mark ---> 外挂Flash 还原系统
-(void)cmdFlashRecovery;

#pragma mark ---> 外挂Flash 获取文件信息
-(void)cmdFlashInformationOfFile:(NSString*)file Result:(JL_FlashFileInfo_BK)result;

#pragma mark ---> 外挂Flash 剩余空间
-(void)cmdFlashLeftSizeResult:(JL_FlashLeftSize_BK)result;

#pragma mark - 案子API
#pragma mark ---> 通知设备播放来电号码的方式
/**
 通知设备播放来电号码的方式
 @param way        正常模式:0x00  播放文件模式:0x01
 */
-(void)cmdPhoneNumberOnWay:(uint8_t)way;

@end




#pragma mark - 设备信息MODEL
@interface JLModel_Device : NSObject<NSCopying>
@property (copy,  nonatomic) NSString           *versionProtocol;       //协议版本
@property (copy,  nonatomic) NSString           *versionFirmware;       //固件版本
@property (assign,nonatomic) JL_SDKType         sdkType;                //SDK类型
@property (assign,nonatomic) NSUInteger         battery;                //电量0~9
@property (assign,nonatomic) NSUInteger         currentVol;             //当前音量
@property (assign,nonatomic) NSUInteger         maxVol;                 //最大音量
@property (copy,  nonatomic) NSString           *btAddr;                //经典蓝牙地址
@property (copy,  nonatomic) NSString           *license;               //平台序列号
@property (assign,nonatomic) JL_DevicePlatform  platform;               //平台类型（图灵，Deepbrain）
@property (assign,nonatomic) JL_DeviceBTStatus  btStatus;               //经典蓝牙状态
@property (assign,nonatomic) uint32_t           function;               //BIT(0):BT BIT(1):MUSIC BIT(2):RTC
@property (assign,nonatomic) JL_FunctionCode    currentFunc;            //当前处于的模式
@property (assign,nonatomic) uint8_t            funcOnlineStatus;       //USb,SD,LineIn,网络电台是否在线
@property (copy,  nonatomic) NSString           *versionUBoot;          //uboot版本
@property (assign,nonatomic) JL_Partition       partitionType;          //设备单、双备份
@property (assign,nonatomic) JL_OtaStatus       otaStatus;              //OTA状态
@property (assign,nonatomic) JL_OtaHeadset      otaHeadset;             //耳机单备份 是否需要强制升级
@property (assign,nonatomic) JL_OtaWatch        otaWatch;               //手表资源 是否需要强制升级
@property (copy,  nonatomic) NSString           *pidvid;                //厂商ID
@property (copy,  nonatomic) NSString           *authKey;               //授权Key
@property (copy,  nonatomic) NSString           *proCode;               //授权Code
@property (assign,nonatomic) JL_BootLoader      bootLoaderType;         //是否下载BootLoader
@property (assign,nonatomic) JL_OtaBleAllowConnect otaBleAllowConnect;  //OTA是否允许BLE连接
@property (assign,nonatomic) JL_BLEOnly         bleOnly;                //是否仅仅支持BLE
@property (assign,nonatomic) JL_FasheEnable     fasheEnable;            //是否支持发射模式
@property (assign,nonatomic) JL_FasheType       fasheType;              //当前是否为发射模式
@property (assign,nonatomic) JL_MD5Type         md5Type;                //是否支持MD5固件校验
@property (assign,nonatomic) JL_GameType        gameType;               //是否为游戏模式
@property (assign,nonatomic) JL_SearchType      searchType;             //是否支持查找设备
@property (assign,nonatomic) JL_KaraokeType     karaokeType;            //是否支持卡拉OK
@property (assign,nonatomic) JL_KaraokeEQType   karaokeEQType;          //是否禁止app调节设备音效
@property (assign,nonatomic) JL_FlashType       flashType;              //是否外挂flash
@property (assign,nonatomic) JL_AncType         ancType;                //是否支持ANC
@property (assign,nonatomic) JL_AudioFileType   audioFileType;          //是否支持音频文件传输功能
@property (assign,nonatomic) int                pitchLow;               //低音
@property (assign,nonatomic) int                pitchHigh;              //高音
@property (copy,  nonatomic) JLModel_Flash      *flashInfo;             //外挂flash信息

/*--- File INFO ---*/
@property (assign,nonatomic) JL_FileHandleType        currentFileHandleType;         //当前文件传输句柄
@property (assign,nonatomic) JL_FileSubcontractTransferCrc16Type fileSubcontractTransferCrc16Type;//文件分包传输是否支持crc16方式
@property (assign,nonatomic) JL_ReadFileInNewWayType readFileInNewWayType;//是否以新的方式读取固件文件

/*--- 公用INFO ---*/
@property (copy,  nonatomic) NSArray            *cardArray;             //卡的数组
@property (copy,  nonatomic) NSString           *handleUSB;             //USB   handle
@property (copy,  nonatomic) NSString           *handleSD_0;            //SD_0  handle
@property (copy,  nonatomic) NSString           *handleSD_1;            //SD_1  handle
@property (copy,  nonatomic) NSString           *handleFlash;           //Flash handle
@property (copy,  nonatomic) NSString           *handleFlash2;          //Flash handle2
@property (copy,  nonatomic) NSData             *handleUSBData;         //USB    handle Data
@property (copy,  nonatomic) NSData             *handleSD_0Data;        //SD_0   handle Data
@property (copy,  nonatomic) NSData             *handleSD_1Data;        //SD_1   handle Data
@property (copy,  nonatomic) NSData             *handleFlashData;       //Flash  handle Data
@property (copy,  nonatomic) NSData             *handleFlash2Data;      //Flash2 handle Data
@property (assign,nonatomic) JL_EQMode          eqMode;                 //EQ模式
@property (copy,  nonatomic) NSArray            *eqArray;               //EQ参数值（只适用于EQ Mode == CUSTOM情况）
@property (copy,  nonatomic) NSArray            *eqCustomArray;         //自定义EQ
@property (copy,  nonatomic) NSArray            *eqFrequencyArray;      //EQ频率
@property (assign,nonatomic) JL_EQType          eqType;                 //EQ段数类型F
@property (strong,nonatomic) NSArray            *eqDefaultArray;        //EQ的预设值数组 数组元素类型-->【JLEQModel】
@property (copy,  nonatomic) NSString           *errReason;             //错误原因
@property (assign,nonatomic) uint16_t           fmtxPoint;              //发射频点
@property (assign,nonatomic) uint8_t            mTWS_Mode;              //0x00:普通模式 0x01:发射模式
@property (assign,nonatomic) uint8_t            mTWS_Status;            //0x00:未连接   0x01:已连接
@property (copy  ,nonatomic) NSString           *mTWS_Addr;             //发射模式中，连接的外设地址
@property (copy  ,nonatomic) JLModel_ANC        *mAncModeCurrent;       //当前ANC的模式
@property (copy  ,nonatomic) NSMutableArray     *mAncModeArray;         //ANC模式数组

@property (assign,nonatomic) JL_CALLType        mCallType;              //通话状态
@property (strong,nonatomic) NSArray            *reverberationTypes;    //混响所支持的类型
@property (assign,nonatomic) int                reverberationSwitchState;   //混响的开关
@property (assign,nonatomic) int                depthValue;                 //深度值
@property (assign,nonatomic) int                intensityValue;             //强度值
@property (assign,nonatomic) int                dynamicLimiterValue;        //限幅值
@property (assign,nonatomic) long               kalaokIndex;                //卡拉OK 组件索引
@property (assign,nonatomic) long               kalaokValue;                //卡拉OK 组件的值
@property (assign,nonatomic) uint64_t           kalaokMask;                 //卡拉OK 固件返回的掩码
@property (strong,nonatomic) NSArray            *mKaraokeMicFrequencyArray; //卡拉OK 频率数组
@property (strong,nonatomic) NSArray            *mKaraokeMicEQArray;        //卡拉OK EQ数组
@property (assign,nonatomic) uint8_t            lightState;             // 0:关闭 1：打开 2：设置模式(彩色/闪烁/情景)
@property (assign,nonatomic) uint8_t            lightMode;              // 0：彩色 1:闪烁 2: 情景
@property (assign,nonatomic) uint8_t            lightRed;               // 灯光红色
@property (assign,nonatomic) uint8_t            lightGreen;             // 灯光绿色
@property (assign,nonatomic) uint8_t            lightBlue;              // 灯光蓝色
@property (assign,nonatomic) uint8_t            lightFlashIndex;        // 闪烁模式Index
@property (assign,nonatomic) uint8_t            lightFrequencyIndex;    // 闪烁频率Index
@property (assign,nonatomic) uint8_t            lightSceneIndex;        // 情景模式Index
@property (assign,nonatomic) uint16_t           lightHue;               // 色相
@property (assign,nonatomic) uint8_t            lightSat;               // 饱和度
@property (assign,nonatomic) uint8_t            lightLightness;         // 亮度

/*--- BT INFO ---*/
@property (strong,nonatomic) NSString           *ID3_Title;
@property (strong,nonatomic) NSString           *ID3_Artist;
@property (strong,nonatomic) NSString           *ID3_AlBum;
@property (assign,nonatomic) uint8_t            ID3_Number;
@property (assign,nonatomic) uint16_t           ID3_Total;
@property (strong,nonatomic) NSString           *ID3_Genre;
@property (assign,nonatomic) uint32_t           ID3_Time;
@property (assign,nonatomic) uint8_t            ID3_Status;             // 0x01:播放 0x00:暂停
@property (assign,nonatomic) uint32_t           ID3_CurrentTime;

/*--- Music INFO ---*/
@property (assign,nonatomic) JL_MusicStatus     playStatus;             //播放状态
@property (assign,nonatomic) JL_MusicMode       playMode;               //播放模式
@property (assign,nonatomic) uint32_t           currentClus;            //当前播放文件的簇号
@property (assign,nonatomic) uint32_t           currentTime;            //当前时间
@property (assign,nonatomic) uint32_t           tolalTime;              //总时长
@property (assign,nonatomic) JL_CardType        currentCard;            //当前卡
@property (copy,  nonatomic) NSString           *fileName;              //名字
@property (copy,  nonatomic) NSString           *typeSupport;           //解码音频格式
    
/*--- RTC INFO ---*/
@property (assign,nonatomic) uint8_t             rtcVersion;            //RTC 版本
@property (assign,nonatomic) JL_RTCAlarmType     rtcAlarmType;          //是否支持闹铃设置
@property (strong,nonatomic) JLModel_RTC         *rtcModel;             //设备当前时间
@property (strong,nonatomic) NSMutableArray      *rtcAlarms;            //设备闹钟数组
@property (strong,nonatomic) NSMutableArray      *rtcDfRings;           //默认铃声

/*--- LineIn INFO ---*/
@property (assign,nonatomic) JL_LineInStatus    lineInStatus;           //LineIn状态

/*--- FM INFO ---*/
@property (assign,nonatomic) JL_FMStatus        fmStatus;               //Fm状态
@property (assign,nonatomic) JL_FMMode          fmMode;                 //Fm 76.0或87.5
@property (strong,nonatomic) JLModel_FM          *currentFm;            //当前fm
@property (strong,nonatomic) NSArray            *fmArray;               //Fm列表

-(void)cleanMe;
+(void)observeModelProperty:(NSString*)prty Action:(SEL)action Own:(id)own;
+(void)removeModelProperty:(NSString*)prty Own:(id)own;
@end

#pragma mark - 闹钟铃声Info
@interface RTC_RingInfo : NSObject
@property (assign,nonatomic) uint8_t        type;
@property (assign,nonatomic) uint8_t        dev;
@property (assign,nonatomic) uint32_t       clust;
@property (assign,nonatomic) uint8_t        len;
@property (strong,nonatomic) NSData         *data;
@end

#pragma mark - 闹钟MODEL
@interface JLModel_RTC : NSObject
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
@property (strong,nonatomic) RTC_RingInfo   *ringInfo;
@property (strong,nonatomic) NSData         *RingData;
@end
#pragma mark - 闹钟默认铃声
@interface JLModel_Ring : NSObject
@property(assign,nonatomic) uint8_t         index;
@property(strong,nonatomic) NSString        *name;
@end
#pragma mark - 闹铃设置
@interface JLModel_AlarmSetting : NSObject
@property(assign,nonatomic)uint8_t index;       //闹钟索引
@property(assign,nonatomic)uint8_t isCount;     //是否可以设置【闹铃次数】
@property(assign,nonatomic)uint8_t count;       //闹铃次数
@property(assign,nonatomic)uint8_t isInterval;  //是否可以设置【时间间隔】
@property(assign,nonatomic)uint8_t interval;    //时间间隔
@property(assign,nonatomic)uint8_t isTime;      //是否可以设置【时间长度】
@property(assign,nonatomic)uint8_t time;        //时间长度
-(NSData*)dataModel;
@end

#pragma mark - 文件MODEL
@interface JLModel_File : NSObject<NSCopying>
@property (assign,nonatomic) JL_BrowseType  fileType;
@property (assign,nonatomic) JL_CardType    cardType;
@property (assign,nonatomic) uint32_t       fileClus;
@property (assign,nonatomic) uint16_t       fileIndex;
@property (copy,  nonatomic) NSString       *fileHandle;
@property (copy,  nonatomic) NSString       *fileName;
@property (copy,  nonatomic) NSString       *folderName;
@property (copy,  nonatomic) NSData *__nullable pathData;
@end

#pragma mark - FM MODEL
@interface JLModel_FM : NSObject<NSCoding>
@property (assign,nonatomic) uint8_t        fmChannel;
@property (assign,nonatomic) uint16_t       fmFrequency;
@end

#pragma mark - Headset MODEL
@interface JLModel_Headset : NSObject
@property(assign,nonatomic)BOOL             mCharging_L;
@property(assign,nonatomic)BOOL             mCharging_R;
@property(assign,nonatomic)BOOL             mCharging_C;
@property(assign,nonatomic)uint8_t          mPower;
@property(assign,nonatomic)uint8_t          mPower_L;
@property(assign,nonatomic)uint8_t          mPower_R;
@property(assign,nonatomic)uint8_t          mPower_C;
@property(assign,nonatomic)uint8_t          mLedScene;
@property(assign,nonatomic)uint8_t          mLedEffect;
@property(assign,nonatomic)uint8_t          mKeyLR;
@property(assign,nonatomic)uint8_t          mKeyAction;
@property(assign,nonatomic)uint8_t          mKeyFunction;
@property(assign,nonatomic)uint8_t          mMicMode;
@property(assign,nonatomic)uint8_t          mWorkMode;
@property(strong,nonatomic)NSString         *mEdr;
@end

#pragma mark - Headset MODEL
@interface JLModel_BT : NSObject
@property(assign,nonatomic)uint32_t         mBtType;
@property(strong,nonatomic)NSData *__nullable mBtAddress;
@property(assign,nonatomic)uint8_t          mBtRssi;
@property(strong,nonatomic)NSString *__nullable mBtName;
@end

#pragma mark - EQ MODEL
@interface JLModel_EQ : NSObject
@property(assign,nonatomic)JL_EQMode        mMode;
@property(strong,nonatomic)NSArray *__nullable mEqArray;
@end

#pragma mark - EQ SPEEX
@interface JLModel_SPEEX : NSObject
@property(assign,nonatomic)JL_SpeakType     mSpeakType;
@property(assign,nonatomic)JL_SpeakDataType mDataType;
@property(assign,nonatomic)uint8_t          mSampleRate;            //0x08=8k，0x10=16k
@property(assign,nonatomic)uint8_t          mVad;                   //断句方: 0:固件 1:APP
@end

#pragma mark - Flash MODEL
@interface JLModel_Flash : NSObject
@property(assign,nonatomic)uint32_t         mFlashSize;             //flash大小
@property(assign,nonatomic)uint32_t         mFatfsSize;             //FAT系统大小

@property(assign,nonatomic)JL_FlashSystemType mFlashType;            //系统类型 0:FATFS，1:RCSP
@property(assign,nonatomic)uint8_t          mFlashStatus;           //系统当前状态,0x00正常，0x01异常
@property(assign,nonatomic)uint16_t         mFlashVersion;          //Flash版本

@property(assign,nonatomic)uint16_t         mFlashReadMtu;          //读数MTU
@property(assign,nonatomic)uint16_t         mFlashCluster;          //扇区大小

@property(strong,nonatomic)NSString         *mFlashMatchVersion;    //手表兼容列表"W001,W002,W003"
@property(assign,nonatomic)uint16_t         mFlashWriteMtu;         //写数MTU
@property(assign,nonatomic)uint16_t         mScreenWidth;           //屏幕宽度
@property(assign,nonatomic)uint16_t         mScreenHeight;          //屏幕高度
@end

#pragma mark - Flash MODEL
@interface JLModel_ANC : NSObject
@property(assign,nonatomic)JL_AncMode       mAncMode;               //耳机降噪模式
@property(assign,nonatomic) uint16_t        mAncMax_L;              //左耳最大增益
@property(assign,nonatomic) uint16_t        mAncCurrent_L;          //左耳当前增益
@property(assign,nonatomic) uint16_t        mAncMax_R;              //右耳最大增益
@property(assign,nonatomic) uint16_t        mAncCurrent_R;          //右耳当前增益
-(NSData*)dataModel;
@end

NS_ASSUME_NONNULL_END
