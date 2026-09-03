//
//  JLAVRecordConfig.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/7/16.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// ==================== 录像配置 ====================

/// 视频方向
typedef NS_ENUM(UInt8, JLAVVideoOrientation) {
    JLAVVideoOrientationLandscape = 1, ///< 横向
    JLAVVideoOrientationPortrait  = 2, ///< 纵向
};

/// 录像配置（解析自设备返回或用于设置）
@interface JLAVVideoRecordConfig : NSObject

/// 最短录制时长（秒），低于此值不生成录像文件
@property(nonatomic,assign)uint32_t minDuration;
/// 最长录制时长（秒），0 表示不限制
@property(nonatomic,assign)uint32_t maxDuration;

/// 视频方向
@property(nonatomic,assign)JLAVVideoOrientation orientation;

/// 是否记录位置信息
@property(nonatomic,assign)BOOL locationEnabled;

/// 从设备返回的 LTV 数据解析
+(nullable JLAVVideoRecordConfig *)parseFromLTVData:(NSData *)ltvData;

/// 序列化为 LTV 数据（用于 set 请求）
-(NSData *)ltvData;

@end

// ==================== 录音配置 ====================

/// 录音配置
@interface JLAVAudioRecordConfig : NSObject

/// 最短录制时长（秒），低于此值不生成文件
@property(nonatomic,assign)uint32_t minDuration;
/// 最长录制时长（秒），0 表示不限制
@property(nonatomic,assign)uint32_t maxDuration;

/// 从设备返回的 LTV 数据解析
+(nullable JLAVAudioRecordConfig *)parseFromLTVData:(NSData *)ltvData;

/// 序列化为 LTV 数据（用于 set 请求）
-(NSData *)ltvData;

@end

NS_ASSUME_NONNULL_END
