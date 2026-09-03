//
//  JLAVRecordStatus.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/7/16.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(UInt8, JLAVRecordStatusState) {
    JLAVRecordStatusStateStopped   = 0,
    JLAVRecordStatusStateRecording = 1,
    JLAVRecordStatusStatePaused    = 2, // 仅录像
};

typedef NS_ENUM(UInt8, JLAVRecordStopReason) {
    JLAVRecordStopReasonManual     = 0,
    JLAVRecordStopReasonTimeout    = 1,
    JLAVRecordStopReasonStorageOff = 2,
    JLAVRecordStopReasonIOError    = 3,
};

/// 录像/录音状态通知（op=0x12 / op=0x24）
@interface JLAVRecordStatus : NSObject
@property(nonatomic,assign)uint8_t               sessionId;
@property(nonatomic,assign)JLAVRecordStatusState  state;
@property(nonatomic,assign)uint32_t               duration; // 秒

+(instancetype)parseFromData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
