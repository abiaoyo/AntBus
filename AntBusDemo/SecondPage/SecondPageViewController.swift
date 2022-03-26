//
//  SecondPageViewController.swift
//  AntBusDemo
//
//

import UIKit
import AntBus

class SecondPageViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AntBusChannelI<UIViewController>.multi.register("SecondPage", self)
    }
    
    @IBAction func clickChanngeTabBar(_ sender: Any) {
        let tabBar = AntBusChannelI<TabBarProtocol>.single.responder()
        print("tabBar: \(tabBar)")
        tabBar?.changeTabIndex(0)
    }
    
    @IBAction func clickAntChannel(_ sender: Any) {
        let responders = AntBusChannelI<UIViewController>.multi.responders()
        print("responders: \(responders)")
    }
    
    @IBAction func clickAntService(_ sender: Any) {
        let hCommonResponders = AntBusServiceI<DeviceProtocol>.multi.responders()
        let h1001Responders = AntBusServiceI<DeviceProtocol>.multi.responders("H1001")
        let h2001Responders = AntBusService.multi(DeviceProtocol.self).responders("H2001")
        print("hCommonResponders:\(hCommonResponders)")
        print("h1001Responders:\(h1001Responders)")
        print("h2001Responders:\(h2001Responders)")
    }
}
