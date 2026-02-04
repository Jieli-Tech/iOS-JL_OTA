//
//  JLDialSourceModel.h
//  JLDialUnit
//
//  Created by EzioChan on 2025/3/19.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_BLEKit.h>
#import <JLLogHelper/JLLogHelper.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLDialSourceModel : JLModel_File

/// 文件大小
@property (nonatomic, assign)int size;

/// CRC
@property (nonatomic, assign)uint16_t crc;

+(JLDialSourceModel *)createModel:(JLModel_File *)model;

@end

NS_ASSUME_NONNULL_END
