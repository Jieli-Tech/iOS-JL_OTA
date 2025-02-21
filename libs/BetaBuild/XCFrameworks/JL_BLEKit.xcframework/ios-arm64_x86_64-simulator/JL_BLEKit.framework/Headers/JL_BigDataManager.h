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
    JL_BigDataStatusSendFailUnknown           = 0xff,     //未知错误
};
typedef void(^JL_BIGDATA_RT)(JL_BigData *bigData);

@interface JL_BigDataManager : JL_FunctionBaseManager

//设立大数据监听（接收阿里数据，必须放在单利类中!!!）
-(void)cmdBigDataMonitor:(JL_BIGDATA_RT)result;

//发送大数据
-(void)cmdInputBigData:(JL_BigData*)data;

@end

@interface JL_BigData : NSObject
@property(nonatomic,assign)JL_BigDataStatus mResult;
@property(nonatomic,assign)NSInteger        mIndex;

///0:原始数据
///1:阿里云数据
///2：RTC数据
///3: AI云
///4：TTS语音合成
///5: 平台接口认证信息
@property(nonatomic,assign)uint8_t          mType;
@property(nonatomic,assign)uint8_t          mVersion;
@property(nonatomic,strong)NSData           *mData;
@end

NS_ASSUME_NONNULL_END
