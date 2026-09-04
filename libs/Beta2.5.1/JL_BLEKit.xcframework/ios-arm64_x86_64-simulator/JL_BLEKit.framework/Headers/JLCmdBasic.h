//
//  JLCmdBasic.h
//  JL_BLEKit
//
//  Created by EzioChan on 2023/9/13.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_TypeEnum.h>
#import <JL_BLEKit/JL_ManagerM.h>
#import <JL_BLEKit/NSData+ToUnit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLCmdBasic : NSObject

-(void)inputPKG:(JL_PKG *)pkg;

-(void)makeCommandAction:(NSData *)targetData withManager:(JL_ManagerM *)manager Result:(JL_CMD_RESPOND _Nullable)result;
@end

NS_ASSUME_NONNULL_END
