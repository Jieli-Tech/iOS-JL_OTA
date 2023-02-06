//
//  JLDhaFitting.h
//  JL_BLEKit
//
//  Created by EzioChan on 2022/6/28.
//  Copyright © 2022 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_TypeEnum.h>

NS_ASSUME_NONNULL_BEGIN



@class JL_ManagerM;

/// 左右声道类型
typedef NS_ENUM(UInt8, DhaChannel) {
    ///左声道
    DhaChannel_left = 0x00,
    ///右声道
    DhaChannel_right = 0x01
};

/// 左右耳验配类型
typedef NS_ENUM(UInt8, DhaFittingType) {
    ///验配左耳
    DhaFittingType_left = 0x00,
    ///验配右耳
    DhaFittingType_right = 0x00,
    ///验配左右耳
    DhaFittingType_All = 0x00,
};


/// 辅听耳机的信息
@interface DhaFittingInfo : NSObject
/// /*版本号：DHA_FITTING_VERSION*/
@property(nonatomic,assign)uint8_t version;
/// /*通道数：DHA_FITTING_CHANNEL_MAX*/
@property(nonatomic,assign)uint8_t ch_num;
/// /*通道频率组：获取通道对应的freq*/
@property(nonatomic,strong)NSArray *ch_freq;

- (instancetype)initWithData:(NSData *)basicData;

@end

@interface DhaFittingSwitch : NSObject

@property(nonatomic,assign)BOOL leftOn;

@property(nonatomic,assign)BOOL rightOn;

@end


/// 辅听验配对象
@interface DhaFittingData : NSObject<NSCopying>
/// 左右声道
@property(nonatomic,assign)DhaChannel channel;

/// 左开关
@property(nonatomic,assign)BOOL leftOn;
/// 右开关
@property(nonatomic,assign)BOOL rightOn;

/// 保留位
@property(nonatomic,assign)uint8_t reserved;
/// 通道频率
@property(nonatomic,assign)uint16_t freq;
/// 通道增益
@property(nonatomic,assign)float gain;

-(NSData*)beData;

@end


typedef void(^DhaInfoBlock)(DhaFittingInfo *info,NSArray <NSNumber *>*gains);


@interface JLDhaFitting : NSObject

/// 获取设备当前辅听的基础信息
/// @param result 辅听耳机信息
/// @param manager manager
+(void)auxiGetInfo:(DhaInfoBlock)result Manager:(JL_ManagerM*)manager;

/// 进行辅听验配
/// @param dhaFit 辅听设置对象
/// @param manager manager
/// @param result 设备工作状态回调
-(void)auxiCheckByStep:(DhaFittingData *)dhaFit Manager:(JL_ManagerM*)manager Result:(JL_CMD_RESPOND __nullable)result;

/// 退出辅听验配
/// @param manager 命令对象
/// @param result 设备工作状态回调
-(void)auxiCloseManager:(JL_ManagerM*)manager Result:(JL_CMD_RESPOND __nullable)result;

/// 保存验配设置
/// @param gains 验配的增益数组
/// @param manager manager
/// @param type 左右耳类型
/// @param result 回调结果
-(void)auxiSaveGainsList:(NSArray <DhaFittingData *>*) gains Manager:(JL_ManagerM*)manager  Type:(DhaFittingType)type Result:(JL_CMD_RESPOND __nullable)result;

@end

NS_ASSUME_NONNULL_END
