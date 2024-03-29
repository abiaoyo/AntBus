//
//  FirstPageViewController.swift
//  AntBusDemo
//

import UIKit
import AntBus

@objc protocol IFirstPageController {
    
}

class FirstPageViewController: UIViewController,IFirstPageController {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AntBus.channel<UIViewController>.multi.register(self, forKey: "FirstPage")
        
        AntBus.notification.register("login.success", owner: self) { [weak self] _ in
            self?.refreshView()
        }
        AntBus.notification.register("logout.success", owner: self) { [weak self] _ in
            self?.refreshView()
        }
        self.refreshView()
    }
    
    func refreshView(){
        self.label.text = AntBus.service<LoginModule>.single.responder()?.loginInfo.account
    }
    @IBOutlet weak var label: UILabel!

    @IBAction func clickLogin(_ sender: Any) {
//        AntBusServiceI<LoginModule>.single.responder()?.goLoginPage()
        AntBus.service<LoginModule>.single.responder()?.goLoginPage()
    }
    
    @IBAction func clickLogout(_ sender: Any) {
        AntBus.service<LoginModule>.single.responder()?.logout()
    }
    
    @IBAction func clickChangeTabBar(_ sender: Any) {
        
//        let index = AntBus.data.call("root.tabbar.index")
//        print("root.tabbar.index:\(index)")
//
//        let tabBar = AntBus.channel<TabBarProtocol>.single.responder()
//        print("tabBar: \(tabBar)")
//        tabBar?.changeTabIndex(1)
        
        let sall = AntBus.service<Any>.single.all()
        print("sall: \(sall)")
        
        let mall = AntBus.service<Any>.multi.all()
        print("mall: \(mall)")
        
        
        
        let sall2 = AntBus.channel<Any>.single.all()
        print("sall2: \(sall2)")
        
        let mall2 = AntBus.channel<Any>.multi.all()
        print("mall2: \(mall2)")
    }
    
}
