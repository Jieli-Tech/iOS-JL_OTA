//
//  JL_FindDeviceManager.h
//  JL_BLEKit
//
//  Created by 杰理科技 on 2021/12/17.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_FunctionBaseManager.h>
#import <JL_BLEKit/JL_TypeEnum.h>
#import <JL_BLEKit/JL_Tools.h>

NS_ASSUME_NONNULL_BEGIN


/// 查找设备参数
@interface JLFindDeviceOperation : NSObject

/// 播放方式 way:
///   0. 全部播放
///   1.左侧播放
///   2.右侧播放
///   3.全部暂停
@property(nonatomic,assign)uint8_t playWay;

/// 超时时间
/// 0 表示不限制时间
/// 默认时间 60
@property(nonatomic,assign)uint16_t timeout;

/// 铃声操作
/// 0x00: 关闭铃声
/// 0x01: 播放铃声
@property(nonatomic,assign)uint8_t sound;


@end


/// 查找手机参数
@interface JLFindPhoneModel : NSObject

/// 铃声操作
/// 0x00: 关闭铃声
/// 0x01: 播放铃声
@property(nonatomic,assign)uint8_t sound;

/// 超时时间
/// 0 表示不限制时间
/// 默认时间 10
@property(nonatomic,assign)uint16_t timeout;

@end



@protocol JL_FindDeviceDelegate <NSObject>


/// 设备查找手机回调
/// - Parameter model:JLFindPhoneModel
-(void)findDeviceStartFindMyPhone:(JLFindPhoneModel *)model;

/// 查询设备当前状态
/// 当前回调需要先查询设备状态cmdFindDeviceCheckStatus
/// - Parameter model: JLFindDeviceOperation
-(void)findDeviceCheckStatus:(JLFindDeviceOperation *)model;

@end

/// 查找设备类
/// 查找设备/设备查找手机
@interface JL_FindDeviceManager : JL_FunctionBaseManager

#pragma mark ---> 查找设备
// 设备查找手机的通知
// 携带了响铃时长🔔
// dict = @{@"op":@(操作类型),@"timeout":@(超时时间)};
extern NSString *kJL_MANAGER_FIND_PHONE;

// 手机查找设备
// 携带是否停止响铃
// dict = @{@"op":@(操作类型),@"timeout":@(超时时间)};
extern NSString *kJL_MANAGER_FIND_DEVICE;

/// 查询固件设备查找状态回调
/// JLFindDeviceOperation 作为回调对象
extern NSString *kJL_MANAGER_FIND_DEVICE_STATUS;


typedef void(^JL_FIND_DEVICE_CHECK_RESPOND)(JL_CMDStatus status, JLFindDeviceOperation * _Nullable model);

/// 代理
@property(nonatomic,weak)id<JL_FindDeviceDelegate> delegate;

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
           Operation:( NSDictionary * _Nullable )opDict __attribute__((deprecated ( "This method will be replaced with subcommands cmdFindDeviceWith and proxy etc.")));



/// 查找设备命令
/// - Parameter operation: 查找设备对象
-(void)cmdFindDeviceWith:(JLFindDeviceOperation *)operation;



/// 查询一次固件查找设备的状态
/// - Parameter result: 状态回调
-(void)cmdFindDeviceCheckStatus:(JL_FIND_DEVICE_CHECK_RESPOND _Nullable)result;


@end

NS_ASSUME_NONNULL_END
