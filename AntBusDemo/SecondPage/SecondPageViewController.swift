//
//  SecondPageViewController.swift
//  AntBusDemo
//
//

import AntBus
import UIKit

class SecondPageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AntBus.channel<UIViewController>.multi.register(self, forKey: "SecondPage")
//        AntBus.channel<UIViewController>.multi.register("SecondPage", self)
    }
    
    @IBAction func clickChanngeTabBar(_ sender: Any) {
        let index = AntBus.data.call("root.tabbar.index")
        print("root.tabbar.index:\(index)")
        
        let tabBar = AntBus.channel<TabBarProtocol>.single.responder()
        print("tabBar: \(tabBar)")
        tabBar?.changeTabIndex(0)
    }
    
    @IBAction func clickAntChannel(_ sender: Any) {
        let responders = AntBus.channel<UIViewController>.multi.responders()
        print("responders: \(responders)")
    }
    
    @IBAction func clickAntService(_ sender: Any) {
        let hCommonResponders = AntBus.service<DeviceProtocol>.multi.responders()
        let h1001Responders = AntBus.service<DeviceProtocol>.multi.responders(forKey: "H1001")
        let h2001Responders = AntBus.service<DeviceProtocol>.multi.responders(forKey: "H2001")
        print("hCommonResponders:\(hCommonResponders)")
        print("h1001Responders:\(h1001Responders)")
        print("h2001Responders:\(h2001Responders)")
    }
}
