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
import JL_BLEKit
import CoreBluetooth

class OTAActionManager: NSObject {
    static let shared = OTAActionManager()
    /// 获取 OTA 升级单例对象
    var otaManager: JL_OTAManager?
    
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
        JLLogManager.logLevel(.DEBUG, content: "OTAActionManager init")
        subscribe()
    }
    
    func startOta(data: Data) {
        otaData = data
        otaManager?.cmdOTAData(data) { result, progress in
            self.otaUpgradeResult(result, progress: progress)
        }
    }
    
    func stopOta() {
        otaManager?.cmdOTACancelResult()
        otaManager?.resetOTAManager()
    }
    
    
    private func subscribe() {
        
        BleManager.shared.disconnectSubject
            .subscribe(onNext: { _ in
            })
            .disposed(by: disposeBag)
        
        BleManager.shared.subConnectInitSubject
            .subscribe(onNext: { [weak self] entity in
                guard let self = self else { return }
                self.otaManager = entity.mCmdManager.mOTAManager
                entity.mCmdManager.cmdTargetFeatureResult { status, _, _ in
                    if status == .success {
                        guard let manager = self.otaManager else { return }
                        if manager.otaStatus == .force  {
                            JLLogManager.logLevel(.DEBUG, content: "OTAActionManager otaFeatureResult force")
                            guard let otaData = self.otaData else { return }
                            manager.cmdOTAData(otaData) { result, progress in
                                self.otaUpgradeResult(result, progress: progress)
                            }
                            return
                        }
                        if manager.otaStatus == .normal,
                           manager.isSupportReuseSpaceOTA,
                           manager.otaSourceMode == .sourcesExtendModeFirmwareOnly {
                            JLLogManager.logLevel(.DEBUG, content: "OTAActionManager otaFeatureResult normal")
                            guard let otaData = self.otaData else { return }
                            manager.cmdOTAData(otaData) { result, progress in
                                self.otaUpgradeResult(result, progress: progress)
                            }
                            return
                        }
                        JLLogManager.logLevel(.DEBUG, content: "OTAActionManager otaFeatureResult normal")
                        self.prepareUpdateSubject.onNext(Void())
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    
    func otaUpgradeResult(_ result: JL_OTAResult, progress: Float) {
        if result == .reconnect || result == .reconnectUpdateSource {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let uuid = self.otaManager?.mBLE_UUID else { return }
                BleManager.shared.reConnectWithUUID(uuid: uuid)
            }
        }
        if result == .reconnectWithMacAddr {
            BleManager.shared.reConnectWithMac(mac: self.otaManager?.bleAddr ?? "")
        }
        // TODO: 更新状态
        updateStateSubject.onNext(result.description(progress))
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
