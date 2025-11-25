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


class BleManager: NSObject {
   
    static let shared = BleManager()
    let SERVICE_UUID = "AE00"
    let CHARACTERISTIC_WRITE = "AE01"
    let CHARACTERISTIC_NOTIFY = "AE02"
    
    lazy var centralManager: CBCentralManager = {
        let manager = CBCentralManager(delegate: self, queue: nil)
        return manager
    }()
    var currentPeripheral: CBPeripheral?
    var characteristicWrite: CBCharacteristic?
    var characteristicNotify: CBCharacteristic?
    var discoverPeripherals: [CBPeripheral] = []
    var currentUUID: String = ""
    
    var discoverPeripheralsSubject = BehaviorRelay<[CBPeripheral]>(value: []) // 发现设备的回调
    var subNotifyInitSubject = PublishSubject<CBPeripheral>() // 订阅通知完成的回调
    var subNotifySubject = PublishSubject<Data>() // 订阅通知的数据回调
    var disconnectSubject = PublishSubject<CBPeripheral>() // 断开连接的回调
    
    private var reconnectUUID: String?
    private var reconnectMac: String?
    private var timer: Timer?
    private var timerCount = 0
    private var maxCount = 10
    
    
    private override init() {
        super.init()
        JLLogManager.logLevel(.DEBUG, content: "BleManager init")
    }
    
    func startScan() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScan() {
        centralManager.stopScan()
    }
    
    func connect(peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
    }
    
    func disconnect(peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    func write(data: Data) {
        guard let characteristic = characteristicWrite, let peripheral = currentPeripheral else { return }
        let mtu = peripheral.maximumWriteValueLength(for: .withoutResponse)
        var len = 0
        while len < data.count {
            let end = min(len + mtu, data.count)
            peripheral.writeValue(data.subdata(in: len ..< end), for: characteristic, type: .withoutResponse)
            len = end
        }
    }
    
    func reConnectWithUUID(uuid: String) {
        reconnectUUID = uuid
        reconnectMac = nil
        JLLogManager.logLevel(.DEBUG, content: "reConnectWithUUID: \(uuid)")
        startScan()
        startTimeout()
    }
    
    func reConnectWithMac(mac: String) {
        reconnectUUID = nil
        reconnectMac = mac
        JLLogManager.logLevel(.DEBUG, content: "reConnectWithMac: \(mac)")
        startScan()
        startTimeout()
    }
    
    //MARK: timeout handler
    @objc private func timeoutHandler() {
        timerCount += 1
        if timerCount >= maxCount {
            timer?.invalidate()
            timer = nil
            timerCount = 0
            JLLogManager.logLevel(.ERROR, content: "连接超时")
        }
    }
    private func startTimeout() {
        maxCount = 10
        timerCount = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeoutHandler), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    private func stopTimeout() {
        timer?.invalidate()
        timer = nil
        timerCount = 0
    }

}

extension BleManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            JLLogManager.logLevel(.DEBUG, content: "蓝牙已开启")
            central.scanForPeripherals(withServices: nil, options: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.stopScan()
            }
        } else {
            JLLogManager.logLevel(.DEBUG, content: "蓝牙未开启")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name != nil {
            JLLogManager.logLevel(.DEBUG, content: "发现设备: \(peripheral.name!)")
            discoverPeripherals.removeAll(where: { $0.identifier == peripheral.identifier })
            discoverPeripherals.append(peripheral)
            discoverPeripheralsSubject.accept(discoverPeripherals)
        }
        
        if reconnectUUID != nil {
            if peripheral.identifier.uuidString == reconnectUUID {
                reconnectUUID = nil
                stopScan()
                connect(peripheral: peripheral)
                return
            }
        }
        if reconnectMac != nil {
            guard let advData = advertisementData["kCBAdvDataManufacturerData"] as? Data else { return }
            guard let mac = reconnectMac else { return }
            if JLAdvParse.otaBleMacAddress(mac, isEqualToCBAdvDataManufacturerData: advData) {
                stopScan()
                reconnectMac = nil
                connect(peripheral: peripheral)
                return
            }
        }
      
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        JLLogManager.logLevel(.DEBUG, content: "连接设备成功")
        currentPeripheral = peripheral
        currentUUID = peripheral.identifier.uuidString
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        stopScan()
        stopTimeout()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        JLLogManager.logLevel(.DEBUG, content: "连接设备失败")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        JLLogManager.logLevel(.DEBUG, content: "断开设备连接")
        currentPeripheral = nil
        disconnectSubject.onNext(peripheral)
    }
}


extension BleManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        JLLogManager.logLevel(.DEBUG, content: "发现服务")
        guard let services = peripheral.services else { return }
        for service in services {
            if service.uuid.uuidString == SERVICE_UUID {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        JLLogManager.logLevel(.DEBUG, content: "发现特征")
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid.uuidString == CHARACTERISTIC_WRITE {
                characteristicWrite = characteristic
            } else if characteristic.uuid.uuidString == CHARACTERISTIC_NOTIFY {
                characteristicNotify = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        JLLogManager.logLevel(.DEBUG, content: "收到数据")
        guard let data = characteristic.value else { return }
        subNotifySubject.onNext(data)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: (any Error)?) {
        JLLogManager.logLevel(.DEBUG, content: "通知状态改变")
        if characteristicWrite == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.subNotifyInitSubject.onNext(peripheral)
            }
        }else{
            subNotifyInitSubject.onNext(peripheral)
        }
    }
}
