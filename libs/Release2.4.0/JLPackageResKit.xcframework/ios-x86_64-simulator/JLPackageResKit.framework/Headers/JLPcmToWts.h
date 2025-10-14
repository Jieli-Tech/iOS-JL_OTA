//
//  JLPcmToWts.h
//  JLWtsToCfgLib
//
//  Created by EzioChan on 2024/1/18.
//  Copyright © 2024 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^wtsResultBlock)(BOOL isSuccess,NSData *_Nullable wtsData,NSString *filePath);

/// PCM 转换 WTS
@interface JLPcmToWts : NSObject

/// 单例
+(instancetype)share;

/// PCM 文件编码 WTS 文件
/// - Parameters:
///   - speechInFileName: PCM 文件路径
///   - bitOutFileName: WTS 文件路径
///   - targetRate: wts 文件的目标码率
///   - sr_in: pcm 文件的采样率
///   - vadthr: vad 阈值
///   - usesavemodef: 0:位流优先 1:质量优先
///   - block: 数据回调
-(void)pcmToWts:(NSString *)speechInFileName bitOutFileName:(NSString *)bitOutFileName targetRate:(int)targetRate sr_in:(int)sr_in vadthr:(float)vadthr usesavemodef:(int)usesavemodef Result:(wtsResultBlock)block;

@end

NS_ASSUME_NONNULL_END
