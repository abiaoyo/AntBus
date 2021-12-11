//
//  Page4Module.swift
//  AntBusDemo
//
//  Created by 李叶彪
//

import UIKit
import CommonModule
import AntBus

@objc protocol IPage4Module{
    func pushPage(navCtl:UINavigationController)
}

class Page4Module: NSObject,IBaseModule, IPage4Module{
    
//    MARK:IPage4Module
    func pushPage(navCtl: UINavigationController) {
        let viewCtl = Page4ViewController.init()
        navCtl.pushViewController(viewCtl, animated: true)
    }
    
//    MARK:IBaseModule
    func moduleInit() {
        AntServiceInterface<IPage4Module>.single.register(self)
    }
    
    func moduleApplication(_ application: UIApplication, willFinishLaunching launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
    }
    
    func moduleApplication(_ application: UIApplication, didFinishLaunching launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
    }
    

}
