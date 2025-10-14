//
//  JLVoiceReplaceInfo.h
//  JLWtsToCfgLib
//
//  Created by EzioChan on 2024/1/23.
//  Copyright © 2024 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 提示音频信息
@interface JLTipsVoiceInfo : NSObject

/// 索引号
@property(nonatomic,assign)uint8_t index;

/// 偏移地址
@property(nonatomic,assign)uint32_t offset;

/// 文件大小
@property(nonatomic,assign)uint32_t length;

/// 文件名称
@property(nonatomic,strong)NSString *fileName;

/// 昵称名称
@property(nonatomic,strong)NSString *nickName;
@end

/// 提示音信息
@interface JLVoiceReplaceInfo : NSObject

/// 版本
@property(nonatomic,assign)uint8_t version;

/// 预留区域
@property(nonatomic,assign)uint32_t blockSize;

/// 最大音频数目
@property(nonatomic,assign)uint8_t maxNum;

/// 文件名称
@property(nonatomic,strong)NSString *fileName;

/// 文件列表细节
@property(nonatomic,strong)NSArray <JLTipsVoiceInfo *> *infoArray;

-(instancetype)init:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
