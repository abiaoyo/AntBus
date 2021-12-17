//
//  Page4Module.swift
//  AntBusDemo
//
//  Created by abiaoyo
//

import UIKit
import CommonModule
import AntBus

protocol IPage4Module{
    func pushPage(navCtl:UINavigationController)
}

class Page4Module: NSObject,IBaseModule, IPage4Module{
    
//    MARK:IPage4Module
    func pushPage(navCtl: UINavigationController) {
        let viewCtl = Page4ViewController.init()
        navCtl.pushViewController(viewCtl, animated: true)
    }
    
//    MARK:IBaseModule
    static func moduleInit() {
        let m = Page4Module.init()
        AntServiceInterface<IPage4Module>.single.register(m)
    }
    
    func moduleApplication(_ application: UIApplication, willFinishLaunching launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
    }
    
    func moduleApplication(_ application: UIApplication, didFinishLaunching launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
    }
    

}
