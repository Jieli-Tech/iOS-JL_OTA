//
//  JL_Talk.h
//  JL_BLE
//
//  Created by DFung on 2018/1/8.
//  Copyright © 2018年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JL_Talk : NSObject

+(void)talkPost:(NSDictionary*)dic;
+(void)talkWrite:(NSDictionary*)dic;
+(NSArray*)talkRed;
+(void)talkRemove;

@end
