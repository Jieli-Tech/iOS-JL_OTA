//
//  SDKBleHelper.h
//  JL_OTA
//
//  Created by EzioChan on 2022/10/12.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_BLEKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDKBleHelper : NSObject

+(NSMutableArray <JL_EntityM *>*)fitterHandle:(NSArray*)basicArray;



@end

NS_ASSUME_NONNULL_END
