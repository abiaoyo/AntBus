//
//  TabBarViewController.swift
//  AntBusDemo
//
//

import UIKit
import AntBus

@objc protocol TabBarProtocol {
    func changeTabIndex(_ index:Int)
    func currentIndex() -> Int
    func currentNavController() -> UINavigationController
}

class TabBarViewController: UITabBarController, TabBarProtocol{
    func currentNavController() -> UINavigationController {
        return self.selectedViewController as! UINavigationController
    }
    
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
        
        AntBus.plus.container.single.register(TabBarProtocol.self, object: self)
        
        AntBus.plus.data.register("root.tabbar.index", owner: self) { [weak self] in
            return self?.selectedIndex
        }
    }

}
