//
//  BleManager.swift
//  MiniSingleDemo
//
//  Created by EzioChan on 2025/11/24.
//

import Foundation
import CoreBluetooth
import RxSwift
import RxCocoa
import JLLogHelper
import JL_AdvParse
import JL_BLEKit


class BleManager: NSObject {
   
    static let shared = BleManager()
    let SERVICE_UUID = "AE00"
    let CHARACTERISTIC_WRITE = "AE01"
    let CHARACTERISTIC_NOTIFY = "AE02"
    var bleMutipleManager: JL_BLEMultiple = JL_BLEMultiple()
    var currentUUID: String = ""
    
    /// 发现设备的回调
    var discoverPeripheralsSubject = BehaviorRelay<[JL_EntityM]>(value: [])
    /// 连接完成的回调
    var subConnectInitSubject = PublishSubject<JL_EntityM>()
    /// 重连完成
    var reconnectSubject = PublishSubject<Void>()
    /// 断开连接的回调
    var disconnectSubject = PublishSubject<JL_EntityM>()
    
    /// 当前正在使用的 Entity
    var currentEntity: JL_EntityM?
    
    private var timer: Timer?
    private var timerCount = 0
    private var maxCount = 10
    
    
    private override init() {
        super.init()
        JLLogManager.logLevel(.DEBUG, content: "JL_BleMulit manager init")
        bleMutipleManager.ble_PAIR_ENABLE = true
        bleMutipleManager.jl_BLE_SERVICE = SERVICE_UUID
        bleMutipleManager.jl_BLE_RCSP_W = CHARACTERISTIC_WRITE
        bleMutipleManager.jl_BLE_RCSP_R = CHARACTERISTIC_NOTIFY
        bleMutipleManager.ble_FILTER_ENABLE = false
        bleMutipleManager.ble_TIMEOUT = 10
        
        NotificationCenter.default.addObserver(self, selector: #selector(discoverEntity(_:)), name: NSNotification.Name(kJL_BLE_M_FOUND), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(currentEntityUpdate(_:)), name: NSNotification.Name(kJL_BLE_M_ENTITY_CONNECTED), object: nil)
    }
    
    func startScan() {
        bleMutipleManager.scanStart()
    }
    
    func stopScan() {
        bleMutipleManager.scanStop()
    }
    
    func connect(entity: JL_EntityM) {
        bleMutipleManager.connectEntity(entity) { status in
            JLLogManager.logLevel(.DEBUG, content: "connect status: \(status)")
            if status == .paired {
                self.subConnectInitSubject.onNext(entity)
            }
        }
    }
    
    func disconnect(entity: JL_EntityM) {
        bleMutipleManager.disconnectEntity(entity) { status in
            if status == .paired {
                self.disconnectSubject.onNext(entity)
            }
        }
    }
    
    
    func reConnectWithUUID(uuid: String) {
        guard let entity = bleMutipleManager.makeEntity(withUUID: uuid) else {
            JLLogManager.logLevel(.ERROR, content: "reConnectWithUUID: \(uuid) error")
            return
        }
        connect(entity: entity)
    }
    
    func reConnectWithMac(mac: String) {
        JLLogManager.logLevel(.DEBUG, content: "reConnectWithMac: \(mac)")
        bleMutipleManager.connectEntity(forMac: mac) { status in
            if status == .paired {
                self.reconnectSubject.onNext(Void())
            }
        }
    }
    
    @objc private func discoverEntity(_ _: Notification) {
        let entities = bleMutipleManager.blePeripheralArr as! [JL_EntityM]
        var newEntitys: [JL_EntityM] = []
        for entity in entities {
            if entity.mItem.count > 0 {
                newEntitys.removeAll(where: { $0.mUUID == entity.mUUID })
                newEntitys.append(entity)
            }
        }
        discoverPeripheralsSubject.accept(newEntitys)
    }
    
    @objc private func currentEntityUpdate(_ notification: Notification) {
        guard let cbp = notification.object as? CBPeripheral else {
            return
        }
        currentUUID = cbp.identifier.uuidString
        guard let entity = (bleMutipleManager.bleConnectedArr as? [JL_EntityM])?.first(where: { $0.mUUID == cbp.identifier.uuidString }) else {
            return
        }
        subConnectInitSubject.onNext(entity)
    }
    
    

}
