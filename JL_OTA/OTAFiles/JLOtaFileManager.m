//
//  JLOtaFileManager.m
//  JL_OTA
//
//  Created by 凌煊峰 on 2021/10/11.
//

#import "JLOtaFileManager.h"

// 0.ufw  使用uuid回连
// 1.ufw  使用uuid回连
// 2.ufw  使用蓝牙地址回连

static int fileCount = 3;
/**
 *  note: "Please put the upgrade file [xxx.ufw or xxx.bfu] in the storage of the mobile phone.\n\nPut it in /AppData/Documents/$_otaFileDocPath";
 */
static NSString *_otaFileDocPath = @"upgrade";

@implementation JLOtaFileManager

/**
 *  初始化沙盒的ota升级文件
 *  转移NSBundle的文件到沙盒
 */
+ (void)initializeOtaFile {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *docFileFolderPath = [NSString stringWithFormat:@"%@/%@", docDir, _otaFileDocPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:docFileFolderPath]) {
        NSError *error = nil;
        BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:docFileFolderPath withIntermediateDirectories:YES attributes:nil error:&error];
        NSLog(@"createDirectoryAtPath %@, error = %@", docFileFolderPath, error);
        NSLog(@"createDirectoryAtPath %@, isSuccess = %d", docFileFolderPath, isSuccess);
    }
    for (int i = 0; i < fileCount; i++) {
        // 本地资源路径
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", i] ofType:@"ufw"];
        NSData *fileData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        // 沙盒资源路径
        NSString *docFilePath = [NSString stringWithFormat:@"%@/%d.ufw", docFileFolderPath, i];
        // 资源转移
        if ([[NSFileManager defaultManager] createFileAtPath:docFilePath contents:fileData attributes:nil]) {
            NSLog(@"沙盒ota升级文件初始化 success");
        } else {
            NSLog(@"沙盒ota升级文件初始化 fail");
        }
    }
}

@end
