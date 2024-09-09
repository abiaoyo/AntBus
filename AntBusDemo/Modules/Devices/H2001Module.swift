//
//  H2001Module.swift
//  AntBusDemo
//

//

import UIKit
import AntBus

class H2001Module: AntBusServiceMultiple, DeviceProtocol {
    
    static func atbsMultipleInitConfigs() -> [AntBusServiceMultipleConfig] {
        let config1 = AntBusServiceMultipleConfig.createForSwift(DeviceProtocol.self, keys: ["H2001"], serviceObj: H2001Module() )
        return [config1]
    }
    
    func supportSkus() -> [String] {
        return ["H2001"]
    }
    func isSupport(sku: String) -> Bool {
        supportSkus().contains(sku)
    }
}
