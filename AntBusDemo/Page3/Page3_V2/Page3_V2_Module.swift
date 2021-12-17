//
//  Page3_V2_Module.swift
//  AntBusDemo
//
//  Created by 李叶彪
//

import UIKit
import CommonModule
import AntBus

class Page3_V2_Module: NSObject,IBaseModule,IPage3Module {
    //Page3Module
    func version() -> Int {
        return 2
    }
    
    func pushPage(navCtl: UINavigationController) {
        let viewCtl = Page3V2ViewController.init()
        navCtl.pushViewController(viewCtl, animated: true)
    }
    
    //IBaseModule
    static func moduleInit() {
        let m = Page3_V2_Module.init()
        AntServiceInterface<IPage3Module>.multiple.register("page3", m)
        //或者 AntServiceInterface<IPage3Module>.multiple.register(["page3"], self)
    }
    
    func moduleApplication(_ application: UIApplication, willFinishLaunching launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
    }
    
    func moduleApplication(_ application: UIApplication, didFinishLaunching launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
    }
    

}
