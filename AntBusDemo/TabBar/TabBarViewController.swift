//
//  TabBarViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit
import AntBus

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AntBusChannel.data.register("app.current.controller", owner: self) { () -> Any? in
            if let navCtl:UINavigationController = self.selectedViewController as? UINavigationController {
                return navCtl.visibleViewController
            }
            return self.selectedViewController
        }
    }

}
