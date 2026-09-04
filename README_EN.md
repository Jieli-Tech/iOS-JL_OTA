[tag download]:https://github.com/Jieli-Tech/iOS-JL_OTA/tags
[tag_badgen]:https://img.shields.io/github/v/tag/Jieli-Tech/iOS-JL_OTA?style=plastic&logo=apple&labelColor=ffffff&color=informational&label=Tag&logoColor=blue

# iOS-JL_OTA[![tag][tag_badgen]][tag download]
<div align="center">

**Jieli Bluetooth OTA Upgrade SDK (iOS) - OTA Upgrade Development Platform for Jieli Bluetooth Devices**

![iOS](https://img.shields.io/badge/iOS-12.0+-blue.svg)
![Xcode](https://img.shields.io/badge/Xcode-14.0+-orange.svg)
![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)

[中文](./README.md) · [English](./README_EN.md) · [Documentation](https://doc.zh-jieli.com/Apps/iOS/ota/zh-cn/master/index.html) · [SDK Version History](#8-version-history) · [Report Issue](https://github.com/Jieli-Tech/iOS-JL_OTA/issues)

</div>

---

## 📋 Table of Contents

- [1. Overview](#1-overview)
- [2. Runtime Environment](#2-runtime-environment)
- [3. Quick Start](#3-quick-start)
- [4. Project Structure](#4-project-structure)
- [5. Configuration](#5-configuration)
- [6. Debugging Tips](#6-debugging-tips)
- [7. Community & Support](#7-community--support)
- [8. Version History](#8-version-history)
- [9. License](#9-license)

---

## 1. Overview

`iOS-JL_OTA` is an OTA upgrade development platform provided by **Zhuhai Jieli Technology Co., Ltd.** for Jieli Bluetooth devices. This SDK is based on the <strong style="color:red">RCSP Protocol (Remote Control System Protocol)</strong> and provides complete OTA upgrade functionality, supporting the following application scenarios:

| Application Type | Typical Products |
|------------------|------------------|
| **Data Transmission Devices** | AC695X, AC608N, AC897, AD697N, AD698N, AC630N, AC632N |
| **Smartwatch Devices** | AC695X, JL701N, AC707N |
| **Speaker Devices** | JL701N, AC897, AD697N, AD698N, 700N |

**Jieli OTA SDK** provides a rich set of functional interfaces:

| Feature | Description |
|---------|-------------|
| **OTA Upgrade** | Supports BLE single/dual backup upgrade, forced upgrade, reconnection mechanism |
| **Device Authentication** | Hash pairing authentication to ensure device security |
| **Advertisement Parsing** | Automatic parsing of Jieli Bluetooth device advertisement packets |
| **Multiple Connection Methods** | Supports native CoreBluetooth, JL_BLEKit, JL_Assist custom connection |
| **GATT Over BR/EDR** | Supports classic Bluetooth OTA upgrade |

This repository contains the complete SDK framework library (XCFramework format), iOS sample project source code, and development documentation to help developers quickly integrate Jieli Bluetooth OTA upgrade capabilities into iOS applications.

---

## 2. Runtime Environment

| Category | Requirement | Description |
|----------|-------------|-------------|
| **iOS System** | iOS 12.0+ | BLE functionality required |
| **Xcode Version** | 14.0+ | Latest version recommended |
| **Hardware Requirement** | Firmware supporting RCSP protocol | AC695X, AC697X, AC695X and other SDKs |
| **Language Support** | Objective-C / Swift | Complete API support provided |

---

## 3. Quick Start

### 3.1 Clone Repository

```bash
git clone https://github.com/Jieli-Tech/iOS-JL_OTA.git
cd iOS-JL_OTA
```

### 3.2 Integrate SDK

1. **Import Frameworks**: Add the XCFramework from the `libs/` directory to your project
2. **Configure Permissions**: Add Bluetooth usage descriptions in `Info.plist`
3. **Initialize SDK**: Refer to the sample project initialization code for integration
4. **Start Development**: Use the APIs provided by the SDK for OTA upgrade feature development

### 3.3 Connection Method Selection

This SDK provides three Bluetooth connection methods:

| Connection Method | Applicable Scenario | Demo Path |
|-------------------|---------------------|-----------|
| **Native CoreBluetooth** | Full control over BLE scanning, connection, services and packet segmentation | `code/MiniDemo/MiniSingleDemo/` |
| **JL_BLEKit** | Quick integration, reduced Bluetooth detail handling | `code/MiniDemo/JLBleKitOTADemo/` |
| **JL_Assist Custom** | Existing external Bluetooth management or bridging to existing Bluetooth layer | `code/MiniDemo/JLAssistOTADemo/` |

**Selection Guide:**
- Full control over BLE scanning, connection, services and packet segmentation → Choose native custom connection
- Quick integration, reduced Bluetooth detail handling → Choose SDK Bluetooth connection (JL_BLEKit)
- Existing external Bluetooth management or bridging to existing Bluetooth layer → Choose JL_Assist custom connection

### 3.4 Quick Integration Steps

1. Integrate `JL_OTALib.xcframework`, `JL_AdvParse.xcframework`, `JL_HashPair.xcframework`, `JLLogHelper.xcframework` and set `Embed & Sign`
2. Configure permissions: `Privacy - Bluetooth Peripheral/Always Usage Description`
3. Core call flow: Device connection + subscribe → `noteEntityConnected` → `cmdTargetFeature` → `cmdOTAData(data)` → delegate callbacks `otaUpgradeResult`, `otaDataSend` → `noteEntityDisconnected` on disconnect
4. Refer to the corresponding sample documentation for detailed implementation and best practices

---

## 4. Project Structure

```
iOS-JL_OTA/
├── code/                           # Sample program source code
│   ├── MiniDemo/                   # Mini sample projects
│   │   ├── MiniSingleDemo/         #   Native CoreBluetooth connection sample
│   │   ├── JLBleKitOTADemo/        #   JL_BLEKit connection sample
│   │   └── JLAssistOTADemo/        #   JL_Assist custom connection sample
│   └── JL_OTA/                     # Complete OTA application sample
│       ├── BleManager/             #   Custom Bluetooth connection implementation
│       ├── BleByAssist/            #   JL_Assist Bluetooth connection implementation
│       ├── SDKBleManager/          #   JL_BLEKit Bluetooth connection implementation
│       └── Views/                  #   UI views
├── libs/                           # Core SDK libraries (XCFramework format)
│   ├── JL_OTALib.xcframework       #   OTA upgrade business library
│   ├── JL_AdvParse.xcframework     #   Advertisement parsing library
│   ├── JL_HashPair.xcframework     #   Device authentication library
│   ├── JL_BLEKit.xcframework       #   Bluetooth connection core library (optional)
│   └── JLLogHelper.xcframework     #   Log helper library
└── docs/                           # Documentation resources
    └── Beta_V2.5.1/             #   HTML format documentation
```

### 4.1 Key Directory Description

| Directory | Purpose |
|-----------|---------|
| `code/MiniDemo/` | **Mini Samples**: Independent sample projects for three connection methods |
| `code/JL_OTA/` | **Complete Sample**: OTA application with full UI and Bluetooth management |
| `libs/` | **Core SDK**: OTA upgrade libraries in XCFramework format |
| `docs/` | **Development Documentation**: HTML documents, API descriptions |

---

## 5. Configuration

### 5.1 Required Libraries

| Library | Description |
|---------|-------------|
| **JL_OTALib.xcframework** | OTA upgrade business library |
| **JL_AdvParse.xcframework** | Jieli Bluetooth device advertisement parsing library |
| **JL_HashPair.xcframework** | Device authentication business library |
| **JLLogHelper.xcframework** | Log printing and collection library |

### 5.2 Optional Libraries

| Library | Description |
|---------|-------------|
| **JL_BLEKit.xcframework** | Bluetooth connection core library (import when using Jieli integrated Bluetooth library) |

### 5.3 Permission Configuration

Add the following permissions in `Info.plist`:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Bluetooth is needed to connect Jieli devices</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>Bluetooth peripheral access is needed to connect Jieli devices</string>
```

### 5.4 Log Management

JLLogHelper.framework has log printing and storage enabled by default. You can control it through the following interfaces:

```objc
// Objective-C
[JLLogManager clearLog]; // Clear logs
[JLLogManager setLog:false IsMore:false Level:JLLOG_COMPLETE]; // Disable log printing
[JLLogManager saveLogAsFile:false]; // Disable log storage
[JLLogManager logWithTimestamp:false]; // Disable log timestamp
```

```swift
// Swift
JLLogManager.saveLog(asFile: true)
JLLogManager.setLog(true, isMore: false, level: .COMPLETE)
JLLogManager.log(withTimestamp: true)
let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/abc.txt"
JLLogManager.redirectLogPath(path) // Reset save path
JLLogManager.clearLog()
JLLogManager.collectLog { str in
    print(str) // Callback for all log content
}
JLLogManager.logSomething("abcd")
```

---

## 6. Debugging Tips

- **Log Output**: The SDK provides detailed log output for viewing Bluetooth connection status and data interaction
- **Device Debugging**: Use Xcode's Console viewer to check real-time logs
- **Troubleshooting**:
  - SDK: Refer to [SDK Debugging Guide](https://doc.zh-jieli.com/Apps/iOS/ota/zh-cn/master/Other/debug.html)
  - Jieli OTA APP: Refer to [Jieli OTA Export Print Log Guide](https://doc.zh-jieli.com/Apps/iOS/ota/zh-cn/master/Other/debug.html#id3)

---

## 7. Community & Support

### Resource Links

| Resource | Link |
|----------|------|
| 📖 **Online Documentation Center** | [https://doc.zh-jieli.com/](https://doc.zh-jieli.com/) |
| 📄 **SDK Integration Documentation** | [https://doc.zh-jieli.com/Apps/iOS/ota/zh-cn/master/index.html](https://doc.zh-jieli.com/Apps/iOS/ota/zh-cn/master/index.html) |
| 🌐 **Official Website** | [https://www.zh-jieli.com/](https://www.zh-jieli.com/) |
| 🐛 **Issue Feedback** | [https://github.com/Jieli-Tech/iOS-JL_OTA/issues](https://github.com/Jieli-Tech/iOS-JL_OTA/issues) |

---

## 8. Version History

### SDK Versions

| Version | Release Date | Major Updates |
|---------|--------------|---------------|
| **v2.5.1_Beta** | 2026/09/04 | 1. Fixed CRC checksum issue |
| **v2.5.0** | 2026/02/04 | 1. Added GATT Over BR/EDR device OTA upgrade support<br/>2. Fixed OTA reconnection timeout issue |
| **v2.4.0** | 2025/10/13 | 1. OTA timeout handling logic optimization<br/>2. Added duplicate sequence number error handling<br/>3. Added special space reuse upgrade support<br/>4. Added single backup SDK internal auto-reconnect interface |
| **v2.3.1** | 2024/12/12 | 1. Separated log printing library as independent module<br/>2. Added timeout detection for all commands<br/>3. Added OTA upgrade error callback<br/>4. Added OTA object management fault tolerance |
| **v2.1.0** | 2023/03/28 | 1. Performance optimization<br/>1.1 Separated OTA module as independent running module<br/>1.2 Separated device authentication pairing business as independent library<br/>1.3 Separated advertisement parsing module as independent library |
| **v2.0.0** | 2021/10/14 | 1. Supported BLE single backup upgrade<br/>2. Supported BLE dual backup upgrade<br/>3. Supported transferring OTA upgrade files from browser to APP<br/>4. Supported importing OTA upgrade files from third-party PC software<br/>5. Optional BLE advertisement packet filtering<br/>6. Optional BLE handshake connection |

### APP Versions

| Version | Release Date | Major Updates |
|---------|--------------|---------------|
| **v3.5.3** | 2026/09/04 | Fixed known issues; using new SDK v2.5.1_Beta |
| **v3.5.2** | 2026/02/04 | Fixed known issues; using new SDK v2.5.0 |
| **v3.5.1** | 2025/10/13 | Fixed known issues; using new SDK v2.4.0 |
| **v3.5.0** | 2024/12/13 | Adapted to new SDK 2.3.1 |
| **v3.3.0** | 2023/03/23 | Adapted to new SDK 2.1.0 |
| **v3.2.0** | 2023/01/11 | Refactored UI pages, reorganized project architecture, added automated testing/broadcast speaker module |
| **v2.0.0** | 2021/10/14 | Added BLE address-based device reconnection; rewrote OTA demo |

---

## 9. License

This project is licensed under the [Apache License 2.0](./LICENSE).

```
Copyright 2024 Zhuhai Jieli Technology Co., Ltd.

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
  <sub>Copyright © 2024-2026 Zhuhai Jieli Technology Co., Ltd. All rights reserved.</sub>
</div>
