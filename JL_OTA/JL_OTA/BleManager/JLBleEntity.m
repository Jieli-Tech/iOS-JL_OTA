//
//  JLBleEntity.m
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/11.
//

#import "JLBleEntity.h"

@implementation JLBleEntity

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    JLBleEntity *entity = [[self class] allocWithZone:zone];
    entity.mRSSI = self.mRSSI;
    entity.mPeripheral = self.mPeripheral;
    entity.mName = self.mName;
    entity.bleMacAddress = self.bleMacAddress;
    return entity;
}

@end
