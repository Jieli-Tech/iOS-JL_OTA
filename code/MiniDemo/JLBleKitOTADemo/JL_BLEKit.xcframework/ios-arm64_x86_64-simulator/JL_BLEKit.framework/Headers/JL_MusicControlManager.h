//
//  JL_MusicControlManager.h
//  JL_BLEKit
//
//  Created by 李放 on 2021/12/20.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_FunctionBaseManager.h>
#import <JL_BLEKit/JL_Tools.h>


NS_ASSUME_NONNULL_BEGIN

__attribute__((deprecated("已废弃,请使用JLDevPlayerCtrl类")))

@interface JL_MusicControlManager  : JL_FunctionBaseManager


#pragma mark ---> 设置播放模式
/**
 @param mode 模式
 0x01:全部循环; 0x02:设备循环; 0x03:单曲循环; 0x04:随机播放; 0x05:文件夹循环
 */
-(void)cmdSetSystemPlayMode:(JL_MusicMode)mode __attribute__((deprecated("cmdSetPlayMode:已废弃")));

#pragma mark ---> 快进快退
/**
 @param cmd 快进或者快退枚举
 @param sec 时间
 @param result 返回结果
 */
-(void)cmdFastPlay:(JL_FCmdMusic)cmd
            Second:(uint16_t)sec
            Result:(JL_CMD_RESPOND __nullable)result __attribute__((deprecated("cmdFastPlay:已废弃，需要使用JLDevPlayerCtrl类里的方法设置")));

@end

NS_ASSUME_NONNULL_END
