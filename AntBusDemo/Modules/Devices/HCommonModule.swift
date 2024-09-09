//
//  HCommonModule.swift
//  AntBusDemo
//

//

import UIKit
import AntBus

class HCommonModule: AntBusServiceMultiple, DeviceProtocol {
    
    static func atbsMultipleInitConfigs() -> [AntBusServiceMultipleConfig] {
        let config1 = AntBusServiceMultipleConfig.createForSwift(DeviceProtocol.self, keys: ["H1001","H2001"], serviceObj: HCommonModule() )
        return [config1]
    }
    
    func supportSkus() -> [String] {
        return ["H1001","H2001"]
    }
    func isSupport(sku: String) -> Bool {
        supportSkus().contains(sku)
    }
}
