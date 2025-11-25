//
//  OTAActionManager.swift
//  MiniSingleDemo
//
//  Created by EzioChan on 2025/11/24.
//

import Foundation
import RxSwift
import RxCocoa
import JLLogHelper
import JL_OTALib
import JL_HashPair
import CoreBluetooth

class OTAActionManager: NSObject {
    static let shared = OTAActionManager()
    // 获取 OTA 升级单例对象
    let otaManager = JL_OTAManager.getOTAManager()
    /// 获取 hash auth 对象
    let authManager = JLHashHandler()
    
    /// 是否启用 auth 设备认证
    /// 设备端默认开启
    var enableAuth = true
    
    /// 是否已经认证过了
    var isAuthed = false
    
    /// OTA 升级数据
    var otaData: Data?
    
    /// 准备好升级
    let prepareUpdateSubject = PublishSubject<Void>()
    
    /// 升级状态
    let updateStateSubject = PublishSubject<(String, Float)>()
    
    /// 订阅
    private let disposeBag = DisposeBag()
    
    private override init() {
        super.init()
        otaManager.delegate = self
        authManager.delegate = self
        JLLogManager.logLevel(.DEBUG, content: "OTAActionManager init")
        subscribe()
    }
    
    func startOta(data: Data) {
        otaData = data
        otaManager.cmdOTAData(data)
    }
    
    func stopOta() {
        otaManager.cmdOTACancelResult()
        otaManager.resetOTAManager()
    }
    
    
    private func subscribe() {
        BleManager.shared.subNotifySubject
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                //TODO: 处理数据
                if !isAuthed, enableAuth {
                    authManager.inputPairData(data)
                    return
                }
                otaManager.cmdOtaDataReceive(data)
            })
            .disposed(by: disposeBag)
        
        BleManager.shared.disconnectSubject
            .subscribe(onNext: { [weak self] peripheral in
                guard let self = self else { return }
                //TODO: 处理断开连接
            })
            .disposed(by: disposeBag)
        
        BleManager.shared.subNotifyInitSubject
            .subscribe(onNext: { [weak self] peripheral in
                guard let self = self else { return }
                otaManager.mBLE_UUID = peripheral.identifier.uuidString
                otaManager.mBLE_NAME = peripheral.name ?? ""
                //TODO: 处理订阅通知成功
                if !isAuthed, enableAuth {
                    //重置设备端的认证
                    authManager.hashResetPair()
                    //重新发起认证
                    self.authManager.bluetoothPairingKey(nil) { status in
                        if status {
                            JLLogManager.logLevel(.DEBUG, content: " 设备认证成功")
                            self.isAuthed = true
                            // 设备认证完成后，进行设备状态信息获取
                            self.otaManager.cmdTargetFeature()
                        }else{
                            JLLogManager.logLevel(.ERROR, content: "设备认证失败")
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
}

extension OTAActionManager: JL_OTAManagerDelegate {
    func otaUpgradeResult(_ result: JL_OTAResult, progress: Float) {
        if result == .reconnect || result == .reconnectUpdateSource {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let uuid = self.otaManager.mBLE_UUID
                BleManager.shared.reConnectWithUUID(uuid: uuid)
            }
        }
        if result == .reconnectWithMacAddr {
            BleManager.shared.reConnectWithMac(mac: self.otaManager.bleAddr)
        }
        // TODO: 更新状态
        updateStateSubject.onNext(result.description(progress))
    }
    func otaDataSend(_ data: Data) {
        //TODO: 发送数据
        BleManager.shared.write(data: data)
    }
    func otaCancel() {
        
    }
    func otaFeatureResult(_ manager: JL_OTAManager) {
        if manager.otaStatus == .force  {
            JLLogManager.logLevel(.DEBUG, content: "OTAActionManager otaFeatureResult force")
            guard let otaData = otaData else { return }
            otaManager.cmdOTAData(otaData)
            return
        }
        if manager.otaStatus == .normal,
           manager.isSupportReuseSpaceOTA,
           manager.otaSourceMode == .sourcesExtendModeFirmwareOnly {
            JLLogManager.logLevel(.DEBUG, content: "OTAActionManager otaFeatureResult normal")
            guard let otaData = otaData else { return }
            otaManager.cmdOTAData(otaData)
            return
        }
        JLLogManager.logLevel(.DEBUG, content: "OTAActionManager otaFeatureResult normal")
        prepareUpdateSubject.onNext(Void())
        
    }
}

extension OTAActionManager: JLHashHandlerDelegate {
    
    func hash(onPairOutputData data: Data) {
        //TODO: 发送数据
        BleManager.shared.write(data: data)
    }
}

extension JL_OTAResult {
    func description(_ progress: Float) -> (String, Float) {
        switch self {
        case .success:
            return ("success", progress)
        case .fail:
            return ("fail", progress)
        case .dataIsNull:
            return ("data is Null", progress)
        case .commandFail:
            return ("command fail", progress)
        case .seekFail:
            return ("seek fail", progress)
        case .infoFail:
            return ("info fail", progress)
        case .lowPower:
            return ("low power", progress)
        case .enterFail:
            return ("enter fail", progress)
        case .upgrading:
            return ("upgrading", progress)  
        case .reconnect:
            return ("reconnect", progress)
        case .reboot:
            return ("reboot", progress)
        case .preparing:
            return ("preparing", progress)
        case .prepared:
            return ("prepared", progress)
        case .statusIsUpdating:
            return ("status is updating", progress)
        case .failedConnectMore:
            return ("failed connect more", progress)    
        case .failSameSN:
            return ("fail same sn", progress)
        case .cancel:
            return ("cancel", progress)
        case .failVerification:
            return ("fail verification", progress)
        case .failCompletely:
            return ("fail completely", progress)
        case .failKey:
            return ("fail key", progress)
        case .failErrorFile:
            return ("fail error file", progress)    
        case .failUboot:
            return ("fail uboot", progress)
        case .failLenght:
            return ("fail lenght", progress)    
        case .failFlash:
            return ("fail flash", progress)
        case .failCmdTimeout:
            return ("fail cmd timeout", progress)
        case .failSameVersion:
            return ("fail same version", progress)
        case .failTWSDisconnect:
            return ("fail tws disconnect", progress)
        case .failNotInBin:
            return ("fail not in bin", progress)
        case .reconnectWithMacAddr:
            return ("reconnect with mac addr", progress)
        case .disconnect:
            return ("disconnect", progress)
        case .reconnectUpdateSource:
            return ("reconnect update source", progress)
        case .unknown:
            return ("unknown", progress)
        @unknown default:
            return ("unknown", progress)
        }
    }
}
