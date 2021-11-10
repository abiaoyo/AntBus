//
//  Page4Module.swift
//  AntBusDemo
//
//  Created by 李叶彪 on 2021/10/17.
//

import UIKit
import BaseModule
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
    func moduleInit() {
        AntService<IPage4Module>.single.register(self)
    }
    
    func moduleApplication(_ application: UIApplication, willFinishLaunching launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
    }
    
    func moduleApplication(_ application: UIApplication, didFinishLaunching launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
    }
    

}
