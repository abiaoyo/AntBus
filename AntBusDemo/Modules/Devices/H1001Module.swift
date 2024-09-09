//
//  H1001Module.swift
//  AntBusDemo
//

import UIKit
import AntBus

class H1001Module: AntBusServiceMultiple, DeviceProtocol {
    
    static func atbsMultipleInitConfigs() -> [AntBusServiceMultipleConfig] {
        let config1 = AntBusServiceMultipleConfig.createForSwift(DeviceProtocol.self, keys: ["H1001"], serviceObj: H1001Module() )
        return [config1]
    }
    
    func supportSkus() -> [String] {
        return ["H1001"]
    }
    func isSupport(sku: String) -> Bool {
        supportSkus().contains(sku)
    }
}
