[tag download]:https://github.com/Jieli-Tech/iOS-JL_OTA/tags
[tag_badgen]:https://img.shields.io/github/v/tag/Jieli-Tech/iOS-JL_OTA?style=plastic&logo=apple&labelColor=ffffff&color=informational&label=Tag&logoColor=blue

# iOS-JL_OTA[![tag][tag_badgen]][tag download]

<div align="center">

**杰理蓝牙 OTA 升级 SDK（iOS）- 专为杰理蓝牙设备提供 OTA 升级开发平台**

![iOS](https://img.shields.io/badge/iOS-12.0+-blue.svg)
![Xcode](https://img.shields.io/badge/Xcode-14.0+-orange.svg)
![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)

[中文](./README.md) · [English](./README_EN.md) · [文档中心](https://doc.zh-jieli.com/Apps/iOS/ota/zh-cn/master/index.html) · [SDK 版本历史](#八版本历史) · [报告问题](https://github.com/Jieli-Tech/iOS-JL_OTA/issues)

</div>

---

## 📋 目录

- [一、概述](#一概述)
- [二、运行环境](#二运行环境)
- [三、快速开始](#三快速开始)
- [四、工程结构](#四工程结构)
- [五、配置说明](#五配置说明)
- [六、调试技巧](#六调试技巧)
- [七、社区与支持](#七社区与支持)
- [八、版本历史](#八版本历史)
- [九、许可证](#九许可证)

---

## 一、概述

`iOS-JL_OTA` 是**珠海市杰理科技股份有限公司**为杰理蓝牙设备提供的 OTA 升级开发平台。本 SDK 基于<strong style="color:red">RCSP 协议 (远程控制系统协议)</strong>，提供完整的 OTA 升级功能，支持以下应用场景：

| 应用类型 | 典型产品 |
|---------|---------|
| **数传设备** | AC695X、AC608N、AC897、AD697N、AD698N、AC630N、AC632N |
| **手表设备** | AC695X、JL701N、AC707N |
| **音箱设备** | JL701N、AC897、AD697N、AD698N、700N |

**杰理 OTA SDK**提供了丰富的功能接口：

| 功能 | 说明 |
|------|------|
| **OTA 升级** | 支持 BLE 单备份/双备份升级、强制升级、回连机制 |
| **设备认证** | Hash 配对认证，保障设备安全 |
| **广播解析** | 自动解析杰理蓝牙设备广播包 |
| **多种连接方式** | 支持原生 CoreBluetooth、JL_BLEKit、JL_Assist 自定义连接 |
| **GATT Over BR/EDR** | 支持经典蓝牙 OTA 升级 |

本仓库包含完整的 SDK 框架库（XCFramework 格式）、iOS 示例工程源码及开发文档，帮助开发者快速集成杰理蓝牙 OTA 升级能力到 iOS 应用中。

---

## 二、运行环境

| 类别 | 要求 | 说明 |
|------|------|------|
| **iOS 系统** | iOS 12.0+ | 支持 BLE 功能 |
| **Xcode 版本** | 14.0+ | 建议使用最新版本 |
| **硬件要求** | 支持 RCSP 协议的固件 | AC695X、AC697X、AC695X 等 SDK |
| **语言支持** | Objective-C / Swift | 提供完整的 API 支持 |

---

## 三、快速开始

### 3.1 克隆仓库

```bash
git clone https://github.com/Jieli-Tech/iOS-JL_OTA.git
cd iOS-JL_OTA
```

### 3.2 集成 SDK

1. **导入框架**：将 `libs/` 目录下的 XCFramework 添加到项目中
2. **配置权限**：在 `Info.plist` 中添加蓝牙使用权限描述
3. **初始化 SDK**：参考示例工程的初始化代码进行集成
4. **开始开发**：使用 SDK 提供的 API 进行 OTA 升级功能开发

### 3.3 连接方式选择

本 SDK 提供三种蓝牙连接方式：

| 连接方式 | 适用场景 | Demo 路径 |
|---------|---------|----------|
| **原生 CoreBluetooth** | 完全掌控 BLE 扫描、连接、服务与分包发送 | `code/MiniDemo/MiniSingleDemo/` |
| **JL_BLEKit** | 快速集成、减少蓝牙细节处理 | `code/MiniDemo/JLBleKitOTADemo/` |
| **JL_Assist 自定义** | 已有外部蓝牙管控或需桥接到既有蓝牙层 | `code/MiniDemo/JLAssistOTADemo/` |

**选择指南：**
- 完全掌控 BLE 扫描、连接、服务与分包发送 → 选择原生自定义连接
- 快速集成、减少蓝牙细节处理 → 选择 SDK 蓝牙连接（JL_BLEKit）
- 已有外部蓝牙管控或需桥接到既有蓝牙层 → 选择 JL_Assist 自定义连接

### 3.4 快速集成步骤

1. 集成 `JL_OTALib.xcframework`、`JL_AdvParse.xcframework`、`JL_HashPair.xcframework`、`JLLogHelper.xcframework` 并设置 `Embed & Sign`
2. 配置权限：`Privacy - Bluetooth Peripheral/Always Usage Description`
3. 核心调用流程：设备连接+订阅 → `noteEntityConnected` → `cmdTargetFeature` → `cmdOTAData(data)` → 委托回调 `otaUpgradeResult`、`otaDataSend` → 断开时 `noteEntityDisconnected`
4. 详细实现与最佳实践请参考对应的示例文档

---

## 四、工程结构

```
iOS-JL_OTA/
├── code/                           # 示例程序源码
│   ├── MiniDemo/                   # 迷你示例工程
│   │   ├── MiniSingleDemo/         #   原生 CoreBluetooth 连接示例
│   │   ├── JLBleKitOTADemo/        #   JL_BLEKit 连接示例
│   │   └── JLAssistOTADemo/        #   JL_Assist 自定义连接示例
│   └── JL_OTA/                     # 完整 OTA 应用示例
│       ├── BleManager/             #   自定义蓝牙连接实现
│       ├── BleByAssist/            #   JL_Assist 蓝牙连接实现
│       ├── SDKBleManager/          #   JL_BLEKit 蓝牙连接实现
│       └── Views/                  #   UI 视图
├── libs/                           # 核心 SDK 库 (XCFramework 格式)
│   ├── JL_OTALib.xcframework       #   OTA 升级业务库
│   ├── JL_AdvParse.xcframework     #   广播包解析库
│   ├── JL_HashPair.xcframework     #   设备认证库
│   ├── JL_BLEKit.xcframework       #   蓝牙连接核心库（可选）
│   └── JLLogHelper.xcframework     #   日志辅助库
└── doc/                            # 文档资源
    └── Release_V2.5.0/             #   最新版本文档
```

### 4.1 关键目录说明

| 目录 | 作用 |
|------|------|
| `code/MiniDemo/` | **迷你示例**：三种连接方式的独立示例工程 |
| `code/JL_OTA/` | **完整示例**：包含完整 UI 和蓝牙管理的 OTA 应用 |
| `libs/` | **核心 SDK**：XCFramework 格式的 OTA 升级库 |
| `doc/` | **开发文档**：HTML 文档、API 说明 |

---

## 五、配置说明

### 5.1 必须导入的库

| 库名 | 说明 |
|------|------|
| **JL_OTALib.xcframework** | OTA 升级业务库 |
| **JL_AdvParse.xcframework** | 杰理蓝牙设备广播包解析库 |
| **JL_HashPair.xcframework** | 设备认证业务库 |
| **JLLogHelper.xcframework** | 日志打印收集库 |

### 5.2 可选导入的库

| 库名 | 说明 |
|------|------|
| **JL_BLEKit.xcframework** | 蓝牙连接核心库（当需要使用杰理集成的蓝牙库时导入） |

### 5.3 权限配置

在 `Info.plist` 中添加以下权限：

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>需要使用蓝牙功能连接杰理设备</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>需要作为蓝牙外设连接杰理设备</string>
```

### 5.4 日志管理

JLLogHelper.framework 默认开启了日志打印和存储，可通过以下接口控制：

```objc
// Objective-C
[JLLogManager clearLog]; // 清空日志
[JLLogManager setLog:false IsMore:false Level:JLLOG_COMPLETE]; // 关闭日志打印
[JLLogManager saveLogAsFile:false]; // 关闭日志存储
[JLLogManager logWithTimestamp:false]; // 关闭日志打印时间
```

```swift
// Swift
JLLogManager.saveLog(asFile: true)
JLLogManager.setLog(true, isMore: false, level: .COMPLETE)
JLLogManager.log(withTimestamp: true)
let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/abc.txt"
JLLogManager.redirectLogPath(path) // 重置保存路径
JLLogManager.clearLog()
JLLogManager.collectLog { str in
    print(str) // 回调所有的日志打印内容
}
JLLogManager.logSomething("abcd")
```

---

## 六、调试技巧

- **日志输出**：SDK 提供详细的日志输出，可通过日志查看蓝牙连接状态和数据交互
- **设备调试**：使用 Xcode 的 Console 查看器查看实时日志
- **问题排查**：
  - SDK：参考 [SDK 调试说明](https://doc.zh-jieli.com/Apps/iOS/ota/zh-cn/master/Other/debug.html)
  - 杰理 OTA APP：参考 [杰理 OTA 导出打印日志说明](https://doc.zh-jieli.com/Apps/iOS/ota/zh-cn/master/Other/debug.html#id3)

---

## 七、社区与支持

### 资源链接

| 资源 | 链接 |
|------|------|
| 📖 **在线文档中心** | [https://doc.zh-jieli.com/](https://doc.zh-jieli.com/) |
| 📄 **SDK 接入文档** | [https://doc.zh-jieli.com/Apps/iOS/ota/zh-cn/master/index.html](https://doc.zh-jieli.com/Apps/iOS/ota/zh-cn/master/index.html) |
| 🌐 **官方网站** | [https://www.zh-jieli.com/](https://www.zh-jieli.com/) |
| 🐛 **问题反馈** | [https://github.com/Jieli-Tech/iOS-JL_OTA/issues](https://github.com/Jieli-Tech/iOS-JL_OTA/issues) |

---

## 八、版本历史

### SDK 版本

| 版本 | 发布日期 | 主要更新 |
|------|----------|----------|
| **v2.5.0** | 2026/02/04 | 1. 增加 GATT Over BR/EDR 设备 OTA 升级支持<br/>2. 修复 OTA 回连超时问题 |
| **v2.4.0** | 2025/10/13 | 1. OTA 超时处理的逻辑优化<br/>2. 增加重复序列号的容错处理<br/>3. 增加特殊空间复用的升级支持<br/>4. 增加单备份 SDK 内部自动回连接口 |
| **v2.3.1** | 2024/12/12 | 1. 分离日志打印库为独立运行模块<br/>2. 增加所有命令的超时检测<br/>3. 增加 OTA 升级的错误回调<br/>4. 增加 OTA 对象的对象管理容错 |
| **v2.1.0** | 2023/03/28 | 1. 性能优化<br/>1.1 分离 OTA 模块为独立运行模块<br/>1.2 分离设备认证配对业务为独立库<br/>1.3 分离广播包解析模块为独立库 |
| **v2.0.0** | 2021/10/14 | 1. 支持 BLE 单备份升级<br/>2. 支持 BLE 双备份升级<br/>3. 支持从浏览器传输 OTA 升级文件到 APP<br/>4. 支持第三方电脑软件导入 OTA 升级文件<br/>5. 可选择 BLE 广播包过滤<br/>6. 可选择 BLE 握手连接 |

### APP 版本

| 版本 | 发布日期 | 主要更新 |
|------|----------|----------|
| **v3.5.2** | 2026/02/04 | 修复已知问题；使用新的 SDK v2.5.0 |
| **v3.5.1** | 2025/10/13 | 修复已知问题；使用新的 SDK v2.4.0 |
| **v3.5.0** | 2024/12/13 | 适配新 SDK 2.3.1 |
| **v3.3.0** | 2023/03/23 | 适配新 SDK 2.1.0 |
| **v3.2.0** | 2023/01/11 | 重构 UI 页面，整理项目架构，新增自动化测试/广播音箱模块 |
| **v2.0.0** | 2021/10/14 | 蓝牙库新增根据 ble 地址对升级设备的回连；重写 ota demo |

---

## 九、许可证

本项目采用 [Apache License 2.0](./LICENSE) 开源协议。

```
Copyright 2024 珠海市杰理科技股份有限公司

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

---

<div align="center">
  <sub>Copyright © 2024-2026 珠海市杰理科技股份有限公司. All rights reserved.</sub>
</div>
