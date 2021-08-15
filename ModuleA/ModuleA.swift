//
//  ModuleA.swift
//  AntBusDemo
//
//  Created by 李叶彪 on 2021/6/12.
//

import UIKit
import AntBus

@objc protocol ModuleAProtocol: NSObjectProtocol {
    func testModuleA()
}

class ModuleA: NSObject, UIApplicationDelegate, ModuleAProtocol {
    
    func testModuleA() {
        
    }
    

    @discardableResult
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AntBus<ModuleAProtocol>.single.register(self)
        
        return true
    }
    
}
