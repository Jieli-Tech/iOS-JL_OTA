//
//  JLPromiseTask.h
//  JL_BLEKit
//
//  Created by EzioChan on 2025/1/13.
//  Copyright © 2025 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLPromiseFulfill)(id _Nullable value);
typedef void(^JLPromiseReject)(NSError * _Nonnull error);
typedef void(^JLPromiseExecute)(JLPromiseFulfill fulfill, JLPromiseReject reject);
typedef void(^JLPromiseThenBlock)(id _Nullable value);
typedef void(^JLPromiseCatchBlock)(NSError * _Nonnull error);

/// JLPromiseTask
/**
     使用 JLPromiseTask 的示例：
     JLPromiseTask *promise = [[JLPromiseTask alloc] initExecute:^(JLPromiseFulfill fulfill, JLPromiseReject reject) {
         // 模拟异步任务
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             BOOL success = arc4random_uniform(2); // 模拟成功或失败
             if (success) {
                 fulfill(@"任务成功！");
             } else {
                 reject([NSError errorWithDomain:@"com.example.promise" code:500 userInfo:@{NSLocalizedDescriptionKey: @"任务失败！"}]);
             }
         });
     }];
     
     
     [promise then:^(id value) {
         NSLog(@"成功：%@", value);
     }].catch:^(NSError *error) {
         NSLog(@"失败：%@", error.localizedDescription);
     }];
 
----------------------------------------------------------------------------------------------------------------------------------
 
     // 用 Promise 的方式调用
    JLPromiseTask *promise = [[JLPromiseTask alloc] initExecute:^(JLPromiseFulfill  _Nonnull fulfill, JLPromiseReject  _Nonnull reject) {
        // 模拟异步任务
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BOOL success = arc4random_uniform(2); // 模拟成功或失败
            if (success) {
                fulfill(@"任务成功！");
            } else {
                reject([NSError errorWithDomain:@"com.example.promise" code:500 userInfo:@{NSLocalizedDescriptionKey: @"任务失败！"}]);
            }
        });
    }];

    id value = [promise await];
 
 */
@interface JLPromiseTask : NSObject

// 单例方法
+ (instancetype)share;

/// 初始化
/// - Parameter execute: 执行
-(instancetype _Nonnull)initExecute:(JLPromiseExecute _Nonnull)execute;

/// then
/// - Parameter then: 回调
/// - Returns:  JLPromiseTask
-(JLPromiseTask *)then:(JLPromiseThenBlock _Nonnull)then;

/// catch
/// - Parameter catchErr: 回调
/// - Returns:  JLPromiseTask
-(JLPromiseTask *)catchErr:(JLPromiseCatchBlock _Nonnull)catchErr;

// async/await 的机制
- (id _Nullable)await;

@end

NS_ASSUME_NONNULL_END
