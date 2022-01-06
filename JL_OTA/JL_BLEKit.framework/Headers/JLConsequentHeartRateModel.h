//
//  JLConsequentHeartRateModel.h
//  JL_BLEKit
//
//  Created by EzioChan on 2021/10/12.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import "JLwSettingModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 测量心率传感器设置
@interface JLConsequentHeartRateModel : JLwSettingModel
///开关
@property(nonatomic,assign)BOOL status;
/// 测量模式
@property(nonatomic,assign)WatchConsequentType rType;

-(instancetype)initWithData:(NSData *)data;

- (instancetype)initWithModel:(WatchConsequentType)type Status:(BOOL)status;

@end

NS_ASSUME_NONNULL_END
