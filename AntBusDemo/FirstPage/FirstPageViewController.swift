//
//  FirstPageViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
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
        AntBusChannelI<UIViewController>.multi.register("FirstPage", self)
        
        AntBus.notification.register("login.success", owner: self) { [weak self] _ in
            self?.refreshView()
        }
        AntBus.notification.register("logout.success", owner: self) { [weak self] _ in
            self?.refreshView()
        }
        self.refreshView()
    }
    
    func refreshView(){
        self.label.text = AntBusServiceI<LoginModule>.single.responder()?.loginInfo.account
    }
    @IBOutlet weak var label: UILabel!

    @IBAction func clickLogin(_ sender: Any) {
        AntBusServiceI<LoginModule>.single.responder()?.goLoginPage()
    }
    
    @IBAction func clickLogout(_ sender: Any) {
        AntBusService.singleI(LoginModule.self).responder()?.logout()
    }
    
    @IBAction func clickChangeTabBar(_ sender: Any) {
        let tabBar = AntBusChannelI<TabBarProtocol>.single.responder()
        print("tabBar: \(tabBar)")
        tabBar?.changeTabIndex(1)
    }
    
}
