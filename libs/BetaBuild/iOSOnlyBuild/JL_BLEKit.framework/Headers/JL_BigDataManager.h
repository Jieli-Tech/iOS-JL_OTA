//
//  JL_BigDataManager.h
//  JL_BLEKit
//
//  Created by 杰理科技 on 2022/12/7.
//  Copyright © 2022 www.zh-jieli.com. All rights reserved.
//

#import <JL_BLEKit/JL_FunctionBaseManager.h>

NS_ASSUME_NONNULL_BEGIN


@class JL_BigData;

typedef NS_ENUM(UInt8, JL_BigDataStatus) {
    JL_BigDataStatusSendSuccess               = 0,        //成功
    JL_BigDataStatusSendFailCRC               = 1,        //CRC校验失败
    JL_BigDataStatusSendFailSEQ               = 2,        //SEQ不对
    JL_BigDataStatusSendFailFormat            = 3,        //数据类型不支持
    JL_BigDataStatusSendFailWay               = 4,        //传输方式不支持
    JL_BigDataStatusSendFailOutOfRange        = 5,        //数据长度超范围
    JL_BigDataStatusSendFailWrite             = 6,        //写入数据失败
    JL_BigDataStatusSendFailMissingParameter  = 7,        //缺少配置参数
    JL_BigDataStatusSendFailCmd               = 8,        //命令错误
    JL_BigDataStatusSendFailTimeout           = 9,        //超时
    JL_BigDataStatusGet                       = 10,       //收到数据
    JL_BigDataStatusCancelByUser              = 11,       //用户主动取消
    JL_BigDataStatusCancelByDevice            = 12,       //设备主动取消
    JL_BigDataStatusSendFailUnknown           = 0xff,     //未知错误
};
typedef void(^JL_BIGDATA_RT)(JL_BigData *bigData);

@interface JL_BigDataManager : JL_FunctionBaseManager

//设立大数据监听（接收阿里数据，必须放在单利类中!!!）
-(void)cmdBigDataMonitor:(JL_BIGDATA_RT)result;

//发送大数据
-(void)cmdInputBigData:(JL_BigData*)data;

@end

@interface JL_BigDataDeviceDesc : NSObject
/// 产品标识 (0=运动手表, 1=TWS耳机, 2=音箱, 3=Dongle设备, 4=智能眼镜)
@property(nonatomic,assign)uint8_t          productFlag;
/// 内容类型 (0=字符数组, 1=JSON格式)
@property(nonatomic,assign)uint8_t          contentType;
/// 有效数据
@property(nonatomic,strong)NSData           *payload;
/// 解析后的字符串 (当 contentType=0 时)
@property(nonatomic,strong,nullable)NSString *payloadString;
/// 解析后的JSON字典 (当 contentType=1 时)
@property(nonatomic,strong,nullable)NSDictionary *payloadJson;

+(instancetype)parseFromData:(NSData *)data;
@end

@interface JL_BigData : NSObject
@property(nonatomic,assign)JL_BigDataStatus mResult;
@property(nonatomic,assign)NSInteger        mIndex;

///0:原始数据
///1:阿里云数据
///2:RTC数据
///3:AI云数据
///4:TTS语音合成
///5:平台接口认证信息
///6:esim卡数据
///7:4G模块升级数据
///8:提示音文件数据
///9:设备描述信息
@property(nonatomic,assign)uint8_t          mType;
@property(nonatomic,assign)uint8_t          mVersion;
@property(nonatomic,strong)NSData           *mData;
/// 设备描述信息 (当 mType=9 时有值)
@property(nonatomic,strong,nullable)JL_BigDataDeviceDesc *deviceDesc;
@end

NS_ASSUME_NONNULL_END
