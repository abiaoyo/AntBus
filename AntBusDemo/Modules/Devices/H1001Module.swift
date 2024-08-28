//
//  H1001Module.swift
//  AntBusDemo
//

import UIKit
import AntBus

class H1001Module: AntBusServiceMultiple, DeviceProtocol {
    
    static func atbsMultipleInitConfigs() -> [AntBusServiceMultipleConfig] {
        let config1 = AntBusServiceMultipleConfig.createForSwift(DeviceProtocol.self, keys: ["H1001"], createService: { H1001Module() })
        return [config1]
    }
    static func atbsMultipleUpdateConfigs(timestamp: Int) -> [AntBusServiceMultipleUpdateConfig]? {
        return nil
    }
    
    func supportSkus() -> [String] {
        return ["H1001"]
    }
    func isSupport(sku: String) -> Bool {
        supportSkus().contains(sku)
    }
}
