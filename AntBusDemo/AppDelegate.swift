//
//  AppDelegate.swift
//  AntBusDemo
//
//

import UIKit
import AntBus

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        AntBus.log.setHandler { type, log in
            AntBus.log.printLog(log)
        }
        
        AntBus.service.single.register()
        
        AntBus.service.multiple.register()
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("====== didFinishLaunchingWithOptions ========")
        
        return true
    }
}

