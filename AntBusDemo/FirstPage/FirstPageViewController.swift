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
        AntBus.plus.container.multiple.register(UIViewController.self, object: self, forKey: "FirstPage")
        
        AntBus.plus.notification.register("login.success", owner: self) { [weak self] _ in
            self?.refreshView()
        }
        AntBus.plus.notification.register("logout.success", owner: self) { [weak self] _ in
            self?.refreshView()
        }
        self.refreshView()
    }
    
    func refreshView(){
        self.label.text = AntBus.service.single.responder(LoginService.self)?.loginInfo.account
    }
    @IBOutlet weak var label: UILabel!

    @IBAction func clickLogin(_ sender: Any) {
        if let vctl = AntBus.service.single.responder(LoginService.self)?.viewController() {
            self.present(vctl, animated: true, completion: nil)
        }
    }
    
    @IBAction func clickLogout(_ sender: Any) {
        AntBus.service.single.responder(LoginService.self)?.logout()
    }
    
    @IBAction func clickChangeTabBar(_ sender: Any) {
        
        let index = AntBus.plus.data.call("root.tabbar.index")
        print("root.tabbar.index:\(index)")

        let tabBar = AntBus.plus.container.single.object(TabBarProtocol.self)
        print("tabBar: \(tabBar)")
        tabBar?.changeTabIndex(1)
        
    }
    
}
