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
    
    func registerModules(){
        
        AntBus.deallocLog = { log in
            AntBus.printLog(log)
        }
        AntBus.channelLog = { log in
            AntBus.printLog(log)
        }
        AntBus.serviceLog = { log in
            AntBus.printLog(log)
        }
        AntBus.service<LoginModule>.single.register(LoginModule.init())
        
        let h1001Module = H1001Module.init()
        let h2001Module = H2001Module.init()
        let hCommonModule = HCommonModule.init()
        
        AntBus.service<DeviceProtocol>.multi.register(h1001Module, forKeys: h1001Module.supportSkus())
        AntBus.service<DeviceProtocol>.multi.register(h2001Module, forKeys: h2001Module.supportSkus())
        AntBus.service<DeviceProtocol>.multi.register(hCommonModule, forKeys: hCommonModule.supportSkus())


        
        
//        AntBus.service<DeviceProtocol>.multi.register(h1001Module, forKey: "")
//        AntBus.service<DeviceProtocol>.multi.responders(forKey: "")
//        AntBus.service<DeviceProtocol>.multi.responders()
//
//        AntBus.service<DeviceProtocol>.multi.remove(forKey: "")
//        AntBus.service<DeviceProtocol>.multi.remove()
//        AntBus.service<DeviceProtocol>.multi.remove(forKey: "") { resp in
//            return true
//        }
//        AntBus.service<DeviceProtocol>.multi.remove(forKeys: [""])
//
//        AntBus.service<DeviceProtocol>.single.register(h1001Module)
//        AntBus.service<DeviceProtocol>.single.responder()
//        AntBus.service<DeviceProtocol>.single.remove()
//
//        AntBus.channel<DeviceProtocol>.multi.register(h1001Module, forKey: "")
//        AntBus.channel<DeviceProtocol>.multi.register(h1001Module, forKeys: [""])
//        AntBus.channel<DeviceProtocol>.multi.register([], forKey: "")
//        AntBus.channel<DeviceProtocol>.multi.responders()
//        AntBus.channel<DeviceProtocol>.multi.responders("")
//
//        AntBus.channel<DeviceProtocol>.multi.remove()
//        AntBus.channel<DeviceProtocol>.multi.remove("")
//        AntBus.channel<DeviceProtocol>.multi.remove([""])
//        AntBus.channel<DeviceProtocol>.multi.remove(h1001Module, forKeys: [""])
//        AntBus.channel<DeviceProtocol>.multi.remove(h1001Module, forKey: "")
//        AntBus.channel<DeviceProtocol>.multi.remove([], forKey: "")
        
        
        /*
         AntBus.service.single(DeviceProtocol.self).register(self)
         AntBus.service.multi(DeviceProtocol.self).register(self,"1001")
         AntBus.service.single<DeviceProtocol>.register()
         */
        
//        AntBusService.multi(DeviceProtocol.self).register(hCommonModule.supportSkus(), hCommonModule)
        
//        if let modules:NSArray = NSArray.init(contentsOfFile: Bundle.main.path(forResource: "antbus_demo_modules", ofType: "plist")!) {
//            for module in modules {
//                if let moduleItem:Dictionary<String,String> = module as? Dictionary<String, String> {
//                    guard let name:String = moduleItem["name"] else {
//                        continue
//                    }
//                    guard let className:String = moduleItem["class"] else {
//                        continue
//                    }
//
//                    if let moduleClass:AnyClass = NSClassFromString(className) {
//                        
//                        guard let moduleType = moduleClass as? NSObject.Type else {
//                            print("error: \(name)")
//                            continue
//                        }
////                        if let ibm:IBaseModule.Type = moduleType as? IBaseModule.Type {
////                            ibm.moduleInit()
////                        }
//                    }
//                }
//            }
//        }
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

