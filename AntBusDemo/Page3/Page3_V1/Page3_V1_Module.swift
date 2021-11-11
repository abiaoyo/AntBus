//
//  Page3_V1_Module.swift
//  AntBusDemo
//
//  Created by 李叶彪 on 2021/10/17.
//

import UIKit
import CommonModule
import AntBus

class Page3_V1_Module: NSObject,IBaseModule,IPage3Module {
    
    //Page3Module
    func version() -> Int {
        return 1
    }
    
    func pushPage(navCtl: UINavigationController) {
        let viewCtl = Page3V1ViewController.init()
        navCtl.pushViewController(viewCtl, animated: true)
    }
    
    //IBaseModule
    func moduleInit() {
        AntService<IPage3Module>.multiple.register(["page3"], self)
    }
    
    func moduleApplication(_ application: UIApplication, willFinishLaunching launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
    }
    
    func moduleApplication(_ application: UIApplication, didFinishLaunching launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
    }
    

}
