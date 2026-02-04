//
//  ServiceUUIDInputVC.h
//  JL_OTA
//
//  Created by EzioChan on 2025/12/1.
//  Copyright © 2025 Zhuhia Jieli Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 GattUUIDInputViewController
 GATT Service UUID 输入视图控制器
 职责：提供系统原生风格的表单界面用于输入一个或多个 Service UUID，并进行校验与回调。
 特性：
  1) UITextView 输入，支持逗号或换行分隔多个 UUID；
  2) 规范的导航栏取消/保存按钮与系统动画；
  3) 输入校验（16-bit/32-bit/128-bit，支持标准连字符 GUID）；
  4) 错误提示使用 UIAlertController，符合 HIG；
  5) 通过 block 回调数据至调用方；
 */
@interface ServiceUUIDInputVC : UIViewController

@property (nonatomic, copy, nullable) void (^onSave)(NSArray<NSString *> *uuids);
@property (nonatomic, copy, nullable) void (^onCancel)(void);

- (instancetype)initWithInitialUUIDs:(NSArray<NSString *> *)initialUUIDs NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
