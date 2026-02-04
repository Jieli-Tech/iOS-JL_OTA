//
//  JLEmergencyContactModel.h
//  JL_BLEKit
//
//  Created by EzioChan on 2022/2/17.
//  Copyright © 2022 www.zh-jieli.com. All rights reserved.
//

#import "JLwSettingModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 紧急联系人设置
@interface JLEmergencyContactModel : JLwSettingModel

/// 联系电话
@property(nonatomic,strong)NSString *phoneNumber;

-(instancetype)initWithData:(NSData *)data;

-(instancetype)initWithPhoneNumber:(NSString *)phoneNumber;


@end

NS_ASSUME_NONNULL_END
