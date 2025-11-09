# iOS-JL_OTA 온보딩 가이드

## 목차
- [프로젝트 소개](#프로젝트-소개)
- [개발 환경 요구사항](#개발-환경-요구사항)
- [빠른 시작](#빠른-시작)
- [프로젝트 구조](#프로젝트-구조)
- [주요 기능](#주요-기능)
- [SDK 사용 방법](#sdk-사용-방법)
- [샘플 코드](#샘플-코드)
- [문제 해결](#문제-해결)
- [추가 리소스](#추가-리소스)

---

## 프로젝트 소개

**iOS-JL_OTA**는 Jieli(杰理) 블루투스 기기의 OTA(Over-The-Air) 펌웨어 업그레이드를 지원하는 iOS SDK 프로젝트입니다.

### 주요 특징

- ✅ BLE(Bluetooth Low Energy) 기반 OTA 펌웨어 업그레이드
- ✅ 단일/이중 백업 펌웨어 지원
- ✅ 강제 업그레이드 기능
- ✅ 자동 재연결 기능
- ✅ 진행률 및 상태 콜백
- ✅ 사용자 정의 블루투스 관리 지원

### 지원 디바이스

- **데이터 전송**: AC695X, AC608N, AC897, AD697N, AD698N, AC630N, AC632N
- **스마트워치**: AC695X, JL701N, AC707N
- **스피커**: JL701N, AC897, AD697N, AD698N, 700N

### 최신 버전

- **SDK 버전**: V2.4.0 (2025년 10월 13일)
- **앱 버전**: V3.5.1 (2025년 10월 13일)

---

## 개발 환경 요구사항

### 필수 요구사항

| 항목 | 요구사항 |
|------|---------|
| **iOS 버전** | iOS 12.0 이상 |
| **Xcode** | 14.0 이상 |
| **개발 언어** | Objective-C, Swift |
| **블루투스** | BLE 지원 필수 |

### 필수 프레임워크

다음 프레임워크를 프로젝트에 추가해야 합니다:

```
📦 필수 프레임워크
├── JL_OTALib.framework         # OTA 업그레이드 비즈니스 라이브러리
├── JL_AdvParse.framework       # 블루투스 광고 패킷 파싱 라이브러리
├── JL_HashPair.framework       # 디바이스 인증 라이브러리
└── JLLogHelper.framework       # 로그 수집 라이브러리
```

### 선택 프레임워크

```
📦 선택 프레임워크
└── JL_BLEKit.framework         # Jieli 통합 블루투스 라이브러리
```

> **참고**: `JL_BLEKit.framework`는 Jieli의 통합 블루투스 관리를 사용하고 싶을 때만 필요합니다.

### 권한 설정

`Info.plist`에 다음 권한을 추가해야 합니다:

```xml
<key>NSBluetoothPeripheralUsageDescription</key>
<string>블루투스를 사용하여 디바이스와 통신합니다</string>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>디바이스 업그레이드를 위해 블루투스 접근이 필요합니다</string>
```

---

## 빠른 시작

### 1단계: 프로젝트 클론

```bash
git clone https://github.com/Jieli-Tech/iOS-JL_OTA.git
cd iOS-JL_OTA
```

### 2단계: 프로젝트 열기

```bash
cd code/JL_OTA
open JL_OTA.xcodeproj
```

### 3단계: 프레임워크 확인

프로젝트의 `libs` 디렉토리에서 필요한 프레임워크 버전을 선택합니다:

- `Release2.4.0/` - 최신 버전 (권장)
- `Release2.3.1/` - 이전 안정 버전
- `UniversalBuild/` - 유니버설 빌드
- `iOS10.0Build/` - iOS 10.0+ 지원 (레거시)

### 4단계: 빌드 및 실행

1. Xcode에서 타겟 디바이스 또는 시뮬레이터 선택
2. `Command + R`을 눌러 빌드 및 실행
3. BLE 지원 디바이스를 연결하여 테스트

---

## 프로젝트 구조

```
iOS-JL_OTA/
├── code/                          # 소스 코드
│   └── JL_OTA/                    # 메인 프로젝트
│       ├── BleHandle/             # 블루투스 핸들러 관리
│       ├── BleManager/            # 커스텀 블루투스 관리 (방법 1)
│       ├── SDKBleManager/         # SDK 블루투스 관리 (방법 2)
│       ├── Views/                 # UI 뷰 컨트롤러
│       │   ├── NormalUpdate/      # 일반 업데이트 UI
│       │   ├── AutoTestUpdate/    # 자동 테스트 UI
│       │   └── CommonView/        # 공통 뷰 컴포넌트
│       └── ...
├── libs/                          # 프레임워크 라이브러리
│   ├── Release2.4.0/              # 최신 릴리스
│   ├── Release2.3.1/              # 이전 릴리스
│   └── ...
├── doc/                           # 문서
│   ├── API 说明.md                # API 문서 (중국어)
│   └── ...
├── README.md                      # 프로젝트 README (중국어)
└── ONBOARDING_KR.md              # 온보딩 가이드 (한국어)
```

### 주요 디렉토리 설명

| 디렉토리 | 설명 |
|---------|------|
| `BleManager/` | 자체 블루투스 연결 구현 (권장) |
| `SDKBleManager/` | JL_BLEKit.framework 사용 방식 |
| `BleHandle/` | 두 방식을 구분하는 핸들러 |
| `Views/NormalUpdate/` | OTA 업그레이드 UI 참조 코드 |

---

## 주요 기능

### 1. 블루투스 디바이스 검색 및 연결

- BLE 디바이스 스캔
- 광고 패킷 필터링
- 디바이스 인증 및 페어링
- 자동 재연결

### 2. OTA 펌웨어 업그레이드

- 펌웨어 파일 검증
- 진행률 모니터링
- 단일/이중 백업 지원
- 강제 업그레이드 모드
- 업그레이드 취소 기능

### 3. 디바이스 정보 조회

- 디바이스 버전 정보
- OTA 상태 확인
- 시스템 기능 조회

### 4. 로그 관리

- 로그 수집 및 저장
- 로그 파일 내보내기
- 실시간 로그 콜백

---

## SDK 사용 방법

iOS-JL_OTA는 **두 가지 방식**의 블루투스 연결 방법을 제공합니다.

### 방법 1: 자체 블루투스 관리 (권장)

자체 블루투스 연결을 구현하고 SDK는 OTA 데이터 파싱만 담당합니다.

**참고 코드**: `BleManager/` 폴더

#### 장점
- ✅ 완전한 블루투스 제어
- ✅ 기존 블루투스 코드와 통합 용이
- ✅ 유연한 커스터마이징

#### 필수 프레임워크
```
- JL_OTALib.framework
- JL_AdvParse.framework
- JL_HashPair.framework
- JLLogHelper.framework
```

#### BLE 서비스 파라미터
```
서비스 UUID: AE00
쓰기 특성: AE01
읽기 특성: AE02
```

### 방법 2: JL_BLEKit.framework 사용

Jieli의 통합 블루투스 라이브러리를 사용합니다.

**참고 코드**: `SDKBleManager/` 폴더

#### 장점
- ✅ 간단한 구현
- ✅ 자동 연결 관리
- ✅ 내장 디바이스 필터링

#### 필수 프레임워크
```
- JL_BLEKit.framework (추가)
- JL_OTALib.framework
- JL_AdvParse.framework
- JL_HashPair.framework
- JLLogHelper.framework
```

---

## 샘플 코드

### 방법 1: 자체 블루투스 관리 샘플

#### 1.1 SDK 초기화

```objective-c
#import <JL_OTALib/JL_OTALib.h>
#import <JL_HashPair/JL_HashPair.h>

@interface JLBleManager() <JL_OTAManagerDelegate, JLHashHandlerDelegate>
@property (strong, nonatomic) JL_OTAManager *otaManager;
@property (strong, nonatomic) JLHashHandler *pairHash;
@end

@implementation JLBleManager

- (instancetype)init {
    self = [super init];
    if (self) {
        // OTA 매니저 초기화
        _otaManager = [[JL_OTAManager alloc] init];
        _otaManager.delegate = self;

        // 페어링 핸들러 초기화
        _pairHash = [[JLHashHandler alloc] init];
        _pairHash.delegate = self;

        // SDK 버전 로그
        [JL_OTAManager logSDKVersion];
        [JLHashHandler sdkVersion];
    }
    return self;
}

@end
```

#### 1.2 BLE 특성 발견

```objective-c
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
error:(NSError *)error
{
    if (error) {
        NSLog(@"특성 발견 실패");
        return;
    }

    if ([service.UUID.UUIDString isEqual:@"AE00"]) {
        for (CBCharacteristic *character in service.characteristics) {
            // 쓰기 특성
            if ([character.UUID.UUIDString isEqual:@"AE01"]) {
                self.mRcspWrite = character;
            }
            // 읽기 특성
            if ([character.UUID.UUIDString isEqual:@"AE02"]) {
                self.mRcspRead = character;
                [peripheral setNotifyValue:YES forCharacteristic:character];
            }
        }
    }
}
```

#### 1.3 연결 완료 후 초기화

```objective-c
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
error:(NSError *)error
{
    if (error) {
        NSLog(@"알림 상태 업데이트 실패");
        return;
    }

    if (characteristic.isNotifying) {
        // MTU 크기 가져오기
        self.bleMtu = [peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithoutResponse];

        // 디바이스 페어링 (필요한 경우)
        if (self.isPaired) {
            [_pairHash hashResetPair];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC),
                          dispatch_get_main_queue(), ^{
                [self->_pairHash bluetoothPairingKey:self.pairKey Result:^(BOOL ret) {
                    if (ret) {
                        // 페어링 성공
                        [self.otaManager noteEntityConnected];
                        [[NSNotificationCenter defaultCenter]
                            postNotificationName:@"kFLT_BLE_PAIRED" object:peripheral];
                    } else {
                        // 페어링 실패
                        [self.bleManager cancelPeripheralConnection:peripheral];
                    }
                }];
            });
        } else {
            // 페어링 불필요
            [self.otaManager noteEntityConnected];
            [[NSNotificationCenter defaultCenter]
                postNotificationName:@"kFLT_BLE_PAIRED" object:peripheral];
        }
    }
}
```

#### 1.4 데이터 수신 처리

```objective-c
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
error:(NSError *)error
{
    if (error) {
        NSLog(@"데이터 수신 실패");
        return;
    }

    if (self.isPaired && !self.pairStatus) {
        // 페어링 데이터 처리
        [_pairHash inputPairData:characteristic.value];
    } else {
        // 일반 통신 데이터 처리
        [_otaManager cmdOtaDataReceive:characteristic.value];
    }
}
```

#### 1.5 디바이스 정보 조회

```objective-c
// BLE 연결 및 페어링 후 반드시 실행
[_otaManager cmdTargetFeature];

// 디바이스 정보 콜백
- (void)otaFeatureResult:(JL_OTAManager *)manager {
    if (manager.otaStatus == JL_OtaStatusForce) {
        NSLog(@"강제 업그레이드 필요");
        // 업그레이드 시작
        if (self.selectedOtaFilePath) {
            [self otaFuncWithFilePath:self.selectedOtaFilePath];
        }
    } else {
        NSLog(@"디바이스 정상 사용 가능");
        // 시스템 정보 조회
        [_otaManager cmdSystemFunction];
    }
}
```

#### 1.6 OTA 업그레이드 시작

```objective-c
- (void)otaFuncWithFilePath:(NSString *)otaFilePath {
    NSData *otaData = [[NSData alloc] initWithContentsOfFile:otaFilePath];

    [_otaManager cmdOTAData:otaData Result:^(JL_OTAResult result, float progress) {
        // UI 업데이트
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (result) {
                case JL_OTAResultPreparing:
                    NSLog(@"파일 검증 중...");
                    break;
                case JL_OTAResultUpgrading:
                    NSLog(@"업그레이드 중: %.1f%%", progress * 100);
                    break;
                case JL_OTAResultSuccess:
                    NSLog(@"업그레이드 성공!");
                    break;
                case JL_OTAResultFail:
                    NSLog(@"업그레이드 실패");
                    break;
                case JL_OTAResultReconnect:
                    NSLog(@"디바이스 재연결 중...");
                    break;
                default:
                    break;
            }
        });
    }];
}
```

#### 1.7 데이터 전송 (MTU 고려 분할 전송)

```objective-c
- (void)otaDataSend:(NSData *)data {
    // SDK로부터 전송할 데이터 수신
    [self writeDataByCbp:data];
}

- (void)writeDataByCbp:(NSData *)data {
    if (!_mBlePeripheral || !self.mRcspWrite) {
        NSLog(@"BLE 연결 또는 특성이 준비되지 않음");
        return;
    }

    // MTU 크기에 맞춰 분할 전송
    NSInteger len = data.length;
    NSInteger offset = 0;

    while (len > 0) {
        NSInteger chunkSize = MIN(len, _bleMtu);
        NSData *chunk = [data subdataWithRange:NSMakeRange(offset, chunkSize)];

        [_mBlePeripheral writeValue:chunk
                  forCharacteristic:self.mRcspWrite
                               type:CBCharacteristicWriteWithoutResponse];

        offset += chunkSize;
        len -= chunkSize;
    }
}
```

#### 1.8 연결 해제 처리

```objective-c
- (void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
error:(NSError *)error
{
    NSLog(@"BLE 연결 해제: %@", peripheral.name);

    // SDK에 연결 해제 알림
    [_otaManager noteEntityDisconnected];

    // 상태 초기화
    self.isConnected = NO;
    self.pairStatus = NO;

    // UI 업데이트
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"kFLT_BLE_DISCONNECTED" object:peripheral];
}
```

### 방법 2: JL_BLEKit 사용 샘플

```objective-c
#import <JL_BLEKit/JL_BLEKit.h>

// SDK 초기화
JL_BLEMultiple *bleMultiple = [[JL_BLEMultiple alloc] init];
bleMultiple.BLE_FILTER_ENABLE = YES;  // 디바이스 필터링 활성화
bleMultiple.BLE_PAIR_ENABLE = YES;    // 페어링 활성화
bleMultiple.BLE_TIMEOUT = 7;          // 연결 타임아웃 설정

// 디바이스 스캔 시작
[bleMultiple scanStart];

// 디바이스 연결
[bleMultiple connectEntity:entity Result:^(JL_EntityM *entity, JL_EntityM_Status status) {
    if (status == JL_EntityM_StatusConnected) {
        NSLog(@"디바이스 연결 성공");

        // 디바이스 정보 조회
        [[JL_RunSDK sharedInstance] getDeviceInfo:^(BOOL needForcedUpgrade) {
            if (needForcedUpgrade) {
                NSLog(@"강제 업그레이드 필요");
            }
        }];
    }
}];

// OTA 업그레이드
[[JL_RunSDK sharedInstance] otaFuncWithFilePath:otaFilePath];
```

---

## 문제 해결

### 일반적인 문제

#### 1. 디바이스를 찾을 수 없음

**원인**:
- 블루투스 권한 미승인
- 디바이스가 페어링 모드가 아님
- 거리가 너무 멀거나 신호 간섭

**해결 방법**:
```objective-c
// 블루투스 권한 확인
CBManagerState state = centralManager.state;
if (state != CBManagerStatePoweredOn) {
    NSLog(@"블루투스가 꺼져 있거나 권한이 없습니다");
}

// 디바이스 필터 확인
bleMultiple.BLE_FILTER_ENABLE = YES;
```

#### 2. 연결이 자주 끊김

**원인**:
- 신호 강도 약함
- 디바이스 배터리 부족
- BLE 연결 파라미터 문제

**해결 방법**:
```objective-c
// 연결 타임아웃 증가
bleMultiple.BLE_TIMEOUT = 10;

// 재연결 로직 구현
- (void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
error:(NSError *)error
{
    if (self.shouldReconnect) {
        // 재연결 시도
        [central connectPeripheral:peripheral options:nil];
    }
}
```

#### 3. OTA 업그레이드 실패

**원인**:
- 펌웨어 파일 불일치
- 디바이스 배터리 부족
- 전송 중 연결 끊김

**해결 방법**:
```objective-c
// 배터리 레벨 확인
if (manager.otaStatus == JL_OtaStatusForce) {
    // 강제 업그레이드 필요
}

// 에러 콜백 처리
- (void)otaUpgradeResult:(JL_OTAResult)result Progress:(float)progress {
    switch (result) {
        case JL_OTAResultLowPower:
            NSLog(@"디바이스 배터리 부족");
            break;
        case JL_OTAResultInfoFail:
            NSLog(@"펌웨어 정보 오류");
            break;
        case JL_OTAResultFailErrorFile:
            NSLog(@"펌웨어 파일 오류");
            break;
        default:
            break;
    }
}
```

#### 4. 로그가 너무 많이 쌓임

**해결 방법**:
```objective-c
// 로그 비활성화
[JLLogManager setLog:NO IsMore:NO Level:JLLOG_COMPLETE];
[JLLogManager saveLogAsFile:NO];

// 로그 파일 정리
[JLLogManager clearLog];
```

### 디버깅 팁

#### 로그 활성화 및 수집

```objective-c
// 로그 활성화
[JLLogManager setLog:YES IsMore:YES Level:JLLOG_COMPLETE];
[JLLogManager saveLogAsFile:YES];
[JLLogManager logWithTimestamp:YES];

// 로그 파일 경로 변경
NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                   NSUserDomainMask, YES).firstObject
                   stringByAppendingPathComponent:@"ota_debug.txt"];
[JLLogManager redirectLogPath:path];

// 로그 콜백
[JLLogManager collectLog:^(NSString *logString) {
    NSLog(@"로그: %@", logString);
}];
```

#### BLE 통신 모니터링

```objective-c
// 데이터 전송 로깅
- (void)otaDataSend:(NSData *)data {
    NSLog(@"전송 데이터: %@", data);
    [self writeDataByCbp:data];
}

// 데이터 수신 로깅
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
error:(NSError *)error
{
    NSLog(@"수신 데이터: %@", characteristic.value);
}
```

---

## 추가 리소스

### 공식 문서

- **GitHub 저장소**: https://github.com/Jieli-Tech/iOS-JL_OTA
- **공식 문서**: https://doc.zh-jieli.com/Apps/iOS/ota/zh-cn/master/index.html
- **API 문서**: [doc/API 说明.md](doc/API%20说明.md)

### 참고 앱

- **App Store**: [杰理OTA](https://apps.apple.com/app/jieli-ota)

### 버전 히스토리

#### SDK V2.4.0 (2025/10/13)
- OTA 타임아웃 처리 로직 최적화
- 중복 시리얼 번호 오류 처리 추가
- 특수 공간 재사용 업그레이드 지원
- 단일 백업 SDK 자동 재연결 인터페이스 추가

#### SDK V2.3.1 (2024/12/12)
- 로그 출력 라이브러리를 독립 모듈로 분리
- 모든 명령에 타임아웃 감지 추가
- OTA 업그레이드 에러 콜백 추가
- OTA 객체 관리 오류 처리 추가

#### SDK V2.1.0 (2023/03/28)
- 성능 최적화
- OTA 모듈을 독립 모듈로 분리
- 디바이스 인증 페어링을 독립 라이브러리로 분리
- 광고 패킷 파싱 모듈을 독립 라이브러리로 분리

### 문의 및 지원

문제가 발생하거나 질문이 있는 경우:

1. **GitHub Issues**: [이슈 등록](https://github.com/Jieli-Tech/iOS-JL_OTA/issues)
2. **공식 문서 확인**: 위 링크 참조
3. **샘플 코드 참조**: `code/JL_OTA` 프로젝트

---

## 라이선스

본 프로젝트는 다음 조건을 준수해야 합니다:

1. 본 프로젝트에서 참조하거나 사용하는 기술은 모두 공지 기술 정보 또는 독자적 혁신 설계에서 유래해야 합니다.
2. 본 프로젝트는 인증되지 않은 제3자 지적 재산권의 기술 정보를 사용해서는 안 됩니다.
3. 개인이 인증되지 않은 제3자 지적 재산권의 기술 정보를 사용하여 발생하는 경제적 손실 및 법적 결과는 개인이 부담합니다.

---

## 시작하기

이제 iOS-JL_OTA SDK를 사용하여 Jieli 블루투스 디바이스의 OTA 펌웨어 업그레이드를 구현할 준비가 되었습니다!

1. ✅ [개발 환경 설정](#개발-환경-요구사항) 완료
2. ✅ [프로젝트 구조](#프로젝트-구조) 이해
3. ✅ [샘플 코드](#샘플-코드) 참고
4. ✅ 자신의 프로젝트에 통합

행운을 빕니다! 🚀
