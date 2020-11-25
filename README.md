# iOS-JL_OTA
iOS platform bluetooth OTA
## 声明

1. 本项⽬所参考、使⽤技术必须全部来源于公知技术信息，或⾃主创新设计。 

2. 本项⽬不得使⽤任何未经授权的第三⽅知识产权的技术信息。 

3. 如个⼈使⽤未经授权的第三⽅知识产权的技术信息，造成的经济损失和法律后果由个⼈承担。 

## 版本

| 版本 | 日期           | 修改内容           |
| ---- | -------------- | ------------------ |
| v1.0 | 2019年09月09日 | OTA升级功能        |
| v1.1 | 2020年04月20日 | 增加升级的错误回调 |

## 概述

本文档是为了后续开发者更加便捷移植杰理OTA升级功能而创建。

## 1、导入JL_BLEKit.framework

将*JL_BLEKit.framework*导入Xcode工程项目里，添加*Privacy - Bluetooth Peripheral Usage Description*和*Privacy - Bluetooth Always Usage Description*两个权限。

### 2、实例化SDK

```objective-c
1.导入JL_RunSDK.h文件；

键入以下代码：
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    runSdk = [[JL_RunSDK alloc] init];

    return YES;
}
    
//升级界面，写入以下代码
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听强制升级通知
    [JL_Tools add:kUI_JL_UPDATE_STATUS Action:@selector(noteOtaUpdate:) Own:self];
}
```



### 3、执行OTA升级

```objective-c
-(void)noteOtaUpdate:(NSNotification*)note{
    if (_selectPath.length == 0) return;
    _otaData = [NSData dataWithContentsOfFile:_selectPath];
    
    [JL_Manager cmdOTAData:self.otaData Result:^(JL_OTAResult result, float progress) {
        if (result == JL_OTAResultUpgrading ||
            result == JL_OTAResultPreparing)
        {
            [self isUpdatingUI:YES];
            //NSLog(@"%.1f%%",progress*100.0f);
            NSString *txt = [NSString stringWithFormat:@"%.1f%%",progress*100.0f];
            self.updateSeek.text = txt;
            self.updateProgress.progress = progress;
            
            if (result == JL_OTAResultPreparing) self.updateTxt.text = kJL_TXT("校验文件中");
            if (result == JL_OTAResultUpgrading) self.updateTxt.text = kJL_TXT("正在升级");

            [self otaTimeCheck];//增加超时检测
        }else{
            [self otaTimeClose];//关闭超时检测
        }

        
        if (result == JL_OTAResultSuccess) {
            NSLog(@"OTA 升级完成.");
            self.updateTxt.text = kJL_TXT("升级完成");
            self.updateProgress.progress = 1.0;
        }
        
        if (result == JL_OTAResultReboot) {
            NSLog(@"OTA 设备准备重启.");
            //self.updateTxt.text = kJL_TXT("设备准备重启");
            self.updateTxt.text = kJL_TXT("升级完成");
            [DFUITools showText:kJL_TXT("升级完成") onView:self.view delay:1.0];

            [DFAction delay:2.5 Task:^{
                [self isUpdatingUI:NO];
                [JL_Tools post:@"UI_CHANEG_VC" Object:@(1)];
            }];
        }
        
        if (result == JL_OTAResultFailCompletely) {
            self.updateTxt.text = kJL_TXT("升级失败");
            [DFUITools showText:kJL_TXT("升级失败") onView:self.view delay:1.0];

            [DFAction delay:2.5 Task:^{
                [self isUpdatingUI:NO];
            }];
        }
        
        if (result == JL_OTAResultFailKey) {
            self.updateTxt.text = kJL_TXT("升级文件KEY错误");
            [DFUITools showText:kJL_TXT("升级文件KEY错误") onView:self.view delay:1.0];

            [DFAction delay:2.5 Task:^{
                [self isUpdatingUI:NO];
            }];
        }
    }];
}
