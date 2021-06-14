//
//  ModuleA.swift
//  AntBusDemo
//
//  Created by 李叶彪 on 2021/6/12.
//

import UIKit
import AntBus
import LoginModule

@objc protocol ModuleAProtocol: NSObjectProtocol {
    func testModuleA()
}

class ModuleA: AntBusBaseModule, ModuleAProtocol {
    
    func testModuleA() {
        
    }
    

    @discardableResult
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AntBusContainer<ModuleAProtocol>.multi.register(["A"], self)
        
        return true
    }
    
}
