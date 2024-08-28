//
//  HCommonModule.swift
//  AntBusDemo
//

//

import UIKit
import AntBus

class HCommonModule: AntBusServiceMultiple, DeviceProtocol {
    
    static func atbsMultipleInitConfigs() -> [AntBusServiceMultipleConfig] {
        let config1 = AntBusServiceMultipleConfig.createForSwift(DeviceProtocol.self, keys: ["H1001","H2001"], createService: { HCommonModule() })
        return [config1]
    }
    static func atbsMultipleUpdateConfigs(timestamp: Int) -> [AntBusServiceMultipleUpdateConfig]? {
        return nil
    }
    
    func supportSkus() -> [String] {
        return ["H1001","H2001"]
    }
    func isSupport(sku: String) -> Bool {
        supportSkus().contains(sku)
    }
}
