//
//  AppDelegate.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/5.
//

import UIKit
import CommonModule
import AntBus

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func registerModules(){
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
                        if let ibm:IBaseModule.Type = moduleType as? IBaseModule.Type {
                            ibm.moduleInit()
                        }
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        self.registerModules()
        AntBus.groupNotification.register("TestGroupKey", group: "AppDelegate", owner: self) { index, count, data in
            print("AppDelegate  TestGroupKey AppDelegate index:\(index) count:\(count) data:\(data ?? "nil")")
        }
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("====== didFinishLaunchingWithOptions ========")
        
        return true
    }
}

