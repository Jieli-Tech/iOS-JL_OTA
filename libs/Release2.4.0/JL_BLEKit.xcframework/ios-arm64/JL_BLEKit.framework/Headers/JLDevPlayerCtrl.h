//
//  JLDevPlayerCtrl.h
//  JL_BLEKit
//
//  Created by EzioChan on 2023/9/25.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <JL_BLEKit/JL_BLEKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JL_ManagerM;
@class JLDevPlayerCtrl;

/// 播放器回调
@protocol JLDevPlayerCtrlDelegate<NSObject>

/// 播放状态
/// - Parameters:
///   - ctrl: 播放器
///   - status: 播放模式
-(void)jlDevPlayerCtrl:(JLDevPlayerCtrl *)ctrl playMode:(uint8_t)playMode;

/// 播放状态回调
/// - Parameters:
///   - ctrl: 播放器
///   - status: 播放状态
///   - card: 当前播放的设备
///   - time: 当前播放的时间
///   - total: 总时长
-(void)jlDevPlayerCtrl:(JLDevPlayerCtrl *)ctrl playStatus:(uint8_t)status currentCard:(uint8_t)card currentTime:(uint32_t)time tolalTime:(uint32_t)total;

/// 播放文件回调
/// - Parameters:
///   - ctrl: 播放器
///   - name: 文件名
///   - clus: 文件簇号
-(void)jlDevPlayerCtrl:(JLDevPlayerCtrl *)ctrl fileName:(NSString *)name currentClus:(uint32_t)clus;

@end


/// 设备播放器管理类
@interface JLDevPlayerCtrl : JLCmdBasic

/// 播放状态
@property(nonatomic,assign)uint8_t playStatus;

/// 当前播放的设备
/// 0x00 : USB
/// 0x01 : SD_0
/// 0x02 : SD_1
/// 0x03 : FLASH
/// 0x04 : LineIn
/// 0x05 : FLASH2
@property(nonatomic,assign)uint8_t currentCard;

/// 当前播放时间
@property(nonatomic,assign)uint32_t currentTime;

/// 歌曲总时长
@property(nonatomic,assign)uint32_t tolalTime;

/// 当前播放文件名
@property(nonatomic,strong)NSString *fileName;

/// 当前播放文件的簇号
@property(nonatomic,assign)uint32_t currentClus;

/// 当前播放模式
///  0x01:全部循环;
///  0x02:设备循环;
///  0x03:单曲循环;
///  0x04:随机播放;
///  0x05:文件夹循环
@property (nonatomic,assign)uint8_t playMode;

/// 代理
@property(nonatomic,weak)id<JLDevPlayerCtrlDelegate> delegate;

/// 操控设备播放器设置
/// - Parameters:
///   - cmd: 操作命令
///    0x01：PP按钮
///    0x02：上一曲
///    0x03：下一曲
///    0x04：切换播放模式(当前播放模式：不可指定，设备播放模式自增）
///    0x05：EQ
///    0x06：快退
///    0x07：快进
///   - sec: 时间（当快进/快退时需要，其他功能时值为0）
///   - manager: 设备对象
///   - result: 返回结果
-(void)cmdPlayerCtrl:(uint8_t)cmd
              Second:(uint16_t)sec
             Manager:(JL_ManagerM *)manager
              Result:(JL_CMD_RESPOND __nullable)result;

@end

NS_ASSUME_NONNULL_END
