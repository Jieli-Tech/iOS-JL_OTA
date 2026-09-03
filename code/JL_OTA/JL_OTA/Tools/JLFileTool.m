//
//  JLFileTool.m
//  JL_OTA
//
//  Created by JL_OTA on 2026/9/3.
//

#import "JLFileTool.h"

@implementation JLFileTool

+ (NSString *)listPath:(NSSearchPathDirectory)sPath
            MiddlePath:(NSString *)mPath
                  File:(NSString *)file {
    NSString *dir = [NSSearchPathForDirectoriesInDomains(sPath, NSUserDomainMask, YES) firstObject];
    if (mPath.length > 0) {
        dir = [dir stringByAppendingPathComponent:mPath];
    }
    if (file.length > 0) {
        dir = [dir stringByAppendingPathComponent:file];
    }
    return dir;
}

+ (NSArray *)subPaths:(NSString *)path {
    if (path.length == 0) return @[];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *contents = [fm contentsOfDirectoryAtPath:path error:&error];
    if (error) return @[];
    return contents;
}

+ (BOOL)removePath:(NSString *)path {
    if (path.length == 0) return NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) return YES;
    NSError *error = nil;
    BOOL ret = [fm removeItemAtPath:path error:&error];
    return ret;
}

@end
