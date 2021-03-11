//
//  TabBarViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AntBus.data.register("app.current.controller", owner: self) { (_) -> Any? in
            if let navCtl:UINavigationController = self.selectedViewController as? UINavigationController {
                return navCtl.visibleViewController
            }
            return self.selectedViewController
        }
        
    }

}
