//
//  JLModelSmartPickFree.h
//  JL_BLEKit
//
//  Created by EzioChan on 2023/9/12.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_TypeEnum.h>

NS_ASSUME_NONNULL_BEGIN

@class JL_ManagerM;
@class JLModelSmartPickFree;

@protocol JLModelSmartPickFreeDelegate <NSObject>

-(void)smartPickFreeGetInfo:(JLModelSmartPickFree *)model;

@end

/// 智能免摘的耳机管理类
@interface JLModelSmartPickFree : NSObject

/// 版本号
@property(nonatomic,assign)uint8_t version;

/// 功能类型
/// 0x00:仅设置开关
/// 0x01:仅设置灵敏度
/// 0x02:仅设置启动后关闭时间
/// 0xff:仅获取全部参数
@property(nonatomic,assign)uint8_t funcType;

/// 功能开关
/// 当功能类型 funcType 为 0x00 时此属性需要对应设置
/// 当功能类型 funcType 为 0xFF 时此属性为设备端功能开关状态
@property(nonatomic,assign)BOOL funcStatus;

/// 灵敏度
/// 当功能类型 funcType 为 0x01 时此属性需要对应设置
/// 当功能类型 funcType 为 0xFF 时此属性为设备端灵敏度
/// 0x00:高灵敏度
/// 0x01:低灵敏度
@property(nonatomic,assign)uint8_t senivitiy;

///启动后关闭时间
///当功能类型 funcType 为 0x02 时此属性需要对应设置的时间
///当功能类型 funcType 为 0xFF 时此属性为设备端启动后关闭时间
///0x00:不自动关闭;
///0x01:短(5s);
///0x02:标准(15s);
///0x03:长(30s);
@property(nonatomic,assign)uint8_t autoInterval;


@property(nonatomic,weak)id<JLModelSmartPickFreeDelegate> delegate;

/// 设置智能免摘功能开关
/// - Parameters:
///   - manager: 设备对象
///   - status: 开关
///   - result: 结果回调
-(void)smartPickFreeSetOn:(JL_ManagerM *)manager st:(BOOL)status Result:(JL_CMD_RESPOND)result;

/// 设置智能免摘灵敏度
/// - Parameters:
///   - manager: 设备对象
///   - senivitiy: 灵敏度
///      0x00:高灵敏度
///      0x01:低灵敏度
///   - result: 结果回调
-(void)smartPickFreeSetSenivitiy:(JL_ManagerM *)manager Senivitiy:(uint8_t)senivitiy Result:(JL_CMD_RESPOND)result;

/// 设置智能免摘启动后关闭时间
/// - Parameters:
///   - manager: 设备对象
///   - interval: 启动后关闭时间
///     0x01:短(5s);
///     0x02:标准(15s);
///     0x03:长(30s);
///   - result: 结果回调
-(void)smartPickFreeSetAutoInterval:(JL_ManagerM *)manager Interval:(uint8_t)interval Result:(JL_CMD_RESPOND)result;


/// 查询设备状态
/// - Parameter manager: 设备对象
-(void)smartPickFreeGet:(JL_ManagerM *)manager;

@end

NS_ASSUME_NONNULL_END
