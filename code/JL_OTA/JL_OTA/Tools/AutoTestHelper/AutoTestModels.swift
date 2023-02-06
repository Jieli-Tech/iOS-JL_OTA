//
//  BreakModel.swift
//  JL_OTA
//
//  Created by EzioChan on 2022/12/23.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit
import JL_BLEKit


@objc enum AtOperationType:Int {
    case nextFile = 0
    case thisFile = 1
    case stop = 2
}

@objc enum AtModel:Int{
    case normal = 0
    case faultTolerant = 1
    case interrupt = 2
}

@objc enum AtBreakWay:Int{
    case disconnect = 0
    case unSend = 1
}

@objc enum AtOpportunityType:Int{
    case loader = 0
    case reconnect = 1
    case update = 2
}


/// 自动测试普通模式
@objc class AutoTestModel:NSObject,JLBleManagerOtaDelegate{

    func otaProgress(with result: JL_OTAResult, withProgress progress: Float) {
        
    }
    
    var model:AtModel = .normal
    override init() {
        super.init()
        JLBleManager.sharedInstance().addDelegate(self)
    }
    
}


/// 容错模式
@objc class FaultTolerant:AutoTestModel{
    var faultTolerant:Int = 0
    var operation:AtOperationType = .thisFile
    
    override init() {
        super.init()
    }
    
    override func otaProgress(with result: JL_OTAResult, withProgress progress: Float) {
        
    }
}


@objc class AtOpportunity:NSObject{
    var type:AtOpportunityType = .loader
    var inTime:Int = 100
    override init() {
        super.init()
    }
    
}

/// 中断模式
@objc class BreakModel: AutoTestModel {
    var operation:AtOperationType = .thisFile
    var breakWay:AtBreakWay = .disconnect
    var opportunity:AtOpportunity = AtOpportunity()
    
}
