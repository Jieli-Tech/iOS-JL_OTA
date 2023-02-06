//
//  UfwConfig.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/30.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "UfwConfig.h"


@implementation UfwConfig

-(NSArray<NSString *>*)checkWithPid:(uint16)pid Uid:(uint16)uid{
    NSString *docPath = [DFFile listPath:NSDocumentDirectory MiddlePath:@"upgrade" File:nil];
    NSArray *itemArray = [DFFile subPaths:docPath];
    NSMutableArray *machArray = [NSMutableArray new];
    for (NSString *filePath in itemArray) {
        NSString *targetPath = [docPath stringByAppendingPathComponent:filePath];
        NSData *data = [NSData dataWithContentsOfFile:targetPath];
        JLUfwInfo *info = [self getFirmInfo:data];
        if(info.pid == pid && info.uid == uid){
            [machArray addObject:targetPath];
//            NSLog(@"filePath:%@",targetPath);
        }
    }
    return machArray;
}



-(JLUfwInfo *)getFirmInfo:(NSData *)data{
    JLUfwInfo *info = [JLUfwInfo new];
    const char *pData = (const char *)[data bytes];
    int length = (int)data.length;
    uint32_t fwIdInfoSize = 6;
    uint8_t *fw_id_info = malloc(sizeof(uint8_t) * fwIdInfoSize);
    // 返回6字节的数据
    parse_fw_info(pData, length, fw_id_info, fwIdInfoSize);
    info.pid = fw_id_info[0] << 8 | fw_id_info[1];
    info.uid = fw_id_info[2] << 8 | fw_id_info[3];
    info.version = fw_id_info[4] << 8 | fw_id_info[5];
//    NSLog(@"pid:%hx,uid:%hx",info.pid,info.uid);
    if (fw_id_info) free(fw_id_info);
    return info;
}

@end



@implementation JLUfwInfo

@end
