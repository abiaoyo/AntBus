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
        
        AntBus.plus.container.multiple.register(UIViewController.self, object: self, forKey: "SecondPage")
    }
    
    @IBAction func clickChanngeTabBar(_ sender: Any) {
        let index = AntBus.plus.data.call("root.tabbar.index")
        print("root.tabbar.index:\(index)")
        
        let tabBar = AntBus.plus.container.single.object(TabBarProtocol.self)
        print("tabBar: \(tabBar)")
        tabBar?.changeTabIndex(0)
    }
    
    @IBAction func clickAntChannel(_ sender: Any) {
        let responders = AntBus.plus.container.multiple.objects(UIViewController.self)
        print("responders: \(responders)")
    }
    
    @IBAction func clickAntService(_ sender: Any) {
        let hCommonResponders = AntBus.service.multiple.responders(DeviceProtocol.self)
        let h1001Responders = AntBus.service.multiple.responders(DeviceProtocol.self, key: "H1001")
        let h2001Responders = AntBus.service.multiple.responders(DeviceProtocol.self, key: "H2001")
        let filterResponder = AntBus.service.multiple.responder(DeviceProtocol.self, key: "H2001") { resp in
            resp.isSupport(sku: "H2001")
        }
        
        print("hCommonResponders:\(hCommonResponders)")
        print("h1001Responders:\(h1001Responders)")
        print("h2001Responders:\(h2001Responders)")
        print("filterResponder:\(filterResponder)")
    }
}
