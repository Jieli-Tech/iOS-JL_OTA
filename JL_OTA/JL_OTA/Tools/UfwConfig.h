//
//  UfwConfig.h
//  JL_OTA
//
//  Created by EzioChan on 2022/11/30.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLUfwInfo : NSObject

@property(nonatomic,assign)uint16 pid;
@property(nonatomic,assign)uint16 uid;
@property(nonatomic,assign)int version;

@end


@interface UfwConfig : NSObject

-(NSArray<NSString *>*)checkWithPid:(uint16)pid Uid:(uint16)uid;


@end

NS_ASSUME_NONNULL_END
