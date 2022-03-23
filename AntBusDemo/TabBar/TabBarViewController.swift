//
//  TabBarViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit
import AntBus

@objc protocol TabBarProtocol {
    func changeTabIndex(_ index:Int)
    func currentIndex() -> Int
}

class TabBarViewController: UITabBarController, TabBarProtocol{
    
    func changeTabIndex(_ index: Int) {
        if index < self.viewControllers!.count {
            self.selectedIndex = index
        }
    }
    
    func currentIndex() -> Int {
        return self.selectedIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        AntChannelInterface<TabBarProtocol>.single.register(self)
        AntBusChannelI<TabBarProtocol>.single.register(self)
        
        AntBus.data.register("app.current.controller", owner: self) { () -> Any? in
            if let navCtl:UINavigationController = self.selectedViewController as? UINavigationController {
                return navCtl.visibleViewController
            }
            return self.selectedViewController
        }
    }

}
