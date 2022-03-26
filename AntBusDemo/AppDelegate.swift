//
//  AppDelegate.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/5.
//

import UIKit
import AntBus

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func registerModules(){
        
        AntBusServiceI<LoginModule>.single.register(LoginModule.init())
        
        let h1001Module = H1001Module.init()
        let h2001Module = H2001Module.init()
        let hCommonModule = HCommonModule.init()
        
        AntBusServiceI<DeviceProtocol>.multi.register(h1001Module.supportSkus(), h1001Module)
        AntBusServiceI<DeviceProtocol>.multi.register(h2001Module.supportSkus(), h2001Module)
        AntBusServiceI<DeviceProtocol>.multi.register(hCommonModule.supportSkus(), hCommonModule)
        
        AntBusService.multi(DeviceProtocol.self).register(hCommonModule.supportSkus(), hCommonModule)
        
        if let modules:NSArray = NSArray.init(contentsOfFile: Bundle.main.path(forResource: "antbus_demo_modules", ofType: "plist")!) {
            for module in modules {
                if let moduleItem:Dictionary<String,String> = module as? Dictionary<String, String> {
                    guard let name:String = moduleItem["name"] else {
                        continue
                    }
                    guard let className:String = moduleItem["class"] else {
                        continue
                    }

                    if let moduleClass:AnyClass = NSClassFromString(className) {
                        
                        guard let moduleType = moduleClass as? NSObject.Type else {
                            print("error: \(name)")
                            continue
                        }
//                        if let ibm:IBaseModule.Type = moduleType as? IBaseModule.Type {
//                            ibm.moduleInit()
//                        }
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        self.registerModules()
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("====== didFinishLaunchingWithOptions ========")
        
        return true
    }
}

