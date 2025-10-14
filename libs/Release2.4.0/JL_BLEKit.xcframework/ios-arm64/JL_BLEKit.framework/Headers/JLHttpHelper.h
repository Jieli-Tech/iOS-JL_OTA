//
//  HttpHelper.h
//  JL_BLEKit
//
//  Created by EzioChan on 2022/7/2.
//  Copyright © 2022 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JLHttpDataCbk)(NSData * _Nullable data);
NS_ASSUME_NONNULL_BEGIN

@interface JLHttpHelper : NSObject

+(instancetype)share;

-(void)dataTask:(NSURL *)url Result:(JLHttpDataCbk)result;

-(NSData *)dataTaskSync:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
