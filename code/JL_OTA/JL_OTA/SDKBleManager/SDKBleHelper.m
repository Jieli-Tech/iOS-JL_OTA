//
//  SDKBleHelper.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/12.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "SDKBleHelper.h"
#import "FittingView.h"
#import "JL_RunSDK.h"
#import <JL_BLEKit/JL_BLEKit.h>

/// 杰理 RCSP 服务号（用于 retrieveConnectedPeripherals 过滤系统已连接的设备）
static NSString *const kSDKConnectedServiceUUID = @"AE00";

@interface SDKBleHelper (Private)

/// 系统当前已连接且带 AE00 服务的周边设备
+ (NSArray<CBPeripheral *> *)systemConnectedCBPeripherals;

/// 将 CBPeripheral 转为 JL_EntityM；优先复用扫描列表/已连接列表中的同 UUID 实体，避免重复行
+ (JL_EntityM *)entityWithPeripheral:(CBPeripheral *)peripheral scanned:(NSArray<JL_EntityM *> *)scannedList;

@end

@implementation SDKBleHelper

+(NSMutableArray <JL_EntityM *>*)fitterHandle:(NSArray*)basicArray{
    NSMutableArray *localArray = [NSMutableArray new];
    NSString *key = [[FittingView getFitterKey] uppercaseString];
    for (JL_EntityM *entity in basicArray) {
        if ([key isEqualToString:@""]) {
            [localArray addObject:entity];
        }else{
            if ([[entity.mItem uppercaseString] rangeOfString:key].location == NSNotFound || !entity.mItem) {
                //
                kJLLog(JLLOG_DEBUG, @"过滤 ----> NAME:%@ RSSI:%@", entity.mItem,entity.mRSSI);
            }else{
                [localArray addObject:entity];
            }
        }
    }

    /*--- 系统已连接设备兼容：把系统已连（AE00）设备固定在列表首位 ---*/
    NSArray<CBPeripheral *> *connectedList = [self systemConnectedCBPeripherals];
    for (CBPeripheral *pl in [connectedList reverseObjectEnumerator]) {
        JL_EntityM *entity = [self entityWithPeripheral:pl scanned:localArray];
        if ([localArray containsObject:entity]) {
            [localArray removeObject:entity];
        }
        [localArray insertObject:entity atIndex:0];
    }
    return localArray;
}

+(void)notifyConnectedPeripherals{
    NSArray<CBPeripheral *> *connectedList = [self systemConnectedCBPeripherals];
    if (connectedList.count == 0) return;

    NSMutableArray<JL_EntityM *> *list = [NSMutableArray array];
    for (CBPeripheral *pl in connectedList) {
        JL_EntityM *entity = [self entityWithPeripheral:pl scanned:nil];
        if (entity && ![list containsObject:entity]) {
            [list addObject:entity];
        }
    }
    if (list.count == 0) return;

    /*--- 沿用 SDK 的 kJL_BLE_M_FOUND 通知，让上层设备列表刷新并展示在首位 ---*/
    [JL_Tools post:kJL_BLE_M_FOUND Object:list];
}

#pragma mark - Private

+ (NSArray<CBPeripheral *> *)systemConnectedCBPeripherals{
    CBCentralManager *center = [[JL_RunSDK sharedInstance].mBleMultiple getCenterManaer];
    if (!center || center.state != CBManagerStatePoweredOn) return @[];
    return [center retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:kSDKConnectedServiceUUID]]];
}

+ (JL_EntityM *)entityWithPeripheral:(CBPeripheral *)peripheral scanned:(NSArray<JL_EntityM *> *)scannedList{
    JL_EntityM *exist = nil;
    NSString *uuid = peripheral.identifier.UUIDString;
    for (JL_EntityM *entity in scannedList) {
        if ([entity.mPeripheral.identifier.UUIDString isEqualToString:uuid]) {
            exist = entity;
            break;
        }
    }
    if (!exist) {
        for (JL_EntityM *entity in [JL_RunSDK sharedInstance].mBleMultiple.bleConnectedArr) {
            if ([entity.mPeripheral.identifier.UUIDString isEqualToString:uuid]) {
                exist = entity;
                break;
            }
        }
    }
    if (exist) return exist;

    JL_EntityM *entity = [[JL_EntityM alloc] init];
    [entity setBlePeripheral:peripheral];
    [entity setBleItem:peripheral.name];
    entity.mRSSI = @(0);
    return entity;
}

@end
