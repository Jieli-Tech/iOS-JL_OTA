//
//  JLPackageSourceMgr.h
//  JLPackageResKit
//
//  Created by EzioChan on 2025/4/28.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 信息
@interface JLPackageBaseInfo : NSObject

/// 文件内容
@property(nonatomic,strong)NSData *contentData;

/// 文件名称
@property(nonatomic,strong)NSString *fileName;

@end

/// 资源打包类
@interface JLPackageSourceMgr : NSObject

/// 打包多个文件成 xxx.package 数据
/// - Parameters:
///   - infos: 文件信息
+(NSData *)makePks:(NSArray<JLPackageBaseInfo *>*)infos;

@end

NS_ASSUME_NONNULL_END
