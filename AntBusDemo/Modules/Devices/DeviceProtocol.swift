//
//  DeviceProtocol.swift
//  AntBusDemo
//

//

import UIKit

protocol DeviceProtocol {
    func supportSkus() -> [String]
    func isSupport(sku: String) -> Bool
}
