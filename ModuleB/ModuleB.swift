//
//  ModuleB.swift
//  AntBusDemo
//
//  Created by 李叶彪 on 2021/6/12.
//

import UIKit
import AntBus

@objc protocol ModuleBProtocol: NSObjectProtocol {
    func testModuleB()
}

class ModuleB: NSObject, UIApplicationDelegate ,ModuleBProtocol{
    
    func testModuleB() {
        
    }

    @discardableResult
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AntBusContainer<ModuleBProtocol>.single.register(self)
        
        return true
    }
    
}
