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
    
    var modules:[UIApplicationDelegate] = []
    
    func registerModules(){
        if let moduleNames = NSArray.init(contentsOfFile: Bundle.main.path(forResource: "antbus_modules", ofType: "plist")!) {
            for moduleName in moduleNames {
                if let name:String = moduleName as? String {
                    let vcClass: AnyClass? = NSClassFromString(name)
                    guard let moduleType = vcClass as? NSObject.Type else {
                        print("error: \(name)")
                        continue
                    }
                    let module = moduleType.init()
                    self.modules.append(module as! UIApplicationDelegate)
                    print("AppDelegate registerModules(): .module:\(module)")
                }
            }
        }
        
//        let defaultModuleNames = ["LoginModule.LoginAppDelegate","AntBusDemo.ModuleA"]
//        for moduleName in self.defaultModuleNames {
//            let vcClass: AnyClass? = NSClassFromString(moduleName)
//            guard let moduleType = vcClass as? AntBusBaseModule.Type else {
//                print("\(moduleName)不能当做AntBusBaseModule")
//                break
//            }
//            let module = moduleType.init()
//            self.modules.append(module)
//            print("module:\(module)")
//        }
        
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
//        AntBusContainer.showLog = false
        self.registerModules()
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        for module:UIApplicationDelegate in self.modules {
            if module.responds(to: #selector(UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:))) {
                module.application!(application, didFinishLaunchingWithOptions: launchOptions)
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

