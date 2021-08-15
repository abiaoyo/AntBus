//
//  SecondPageViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit
import AntBus

class SecondPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AntBus.channel.notification.register("login.success", owner: self) { [weak self] (_) in
            self?.refreshView()
        }
        AntBus.channel.notification.register("logout.success", owner: self) { [weak self] (_) in
            self?.refreshView()
        }
        self.refreshView()
    }
    func refreshView(){
        self.label.text = AntBus.channel.data.call("login.user.account").data as? String
    }
    
    @IBOutlet weak var label: UILabel!
    @IBAction func clickButton(_ sender: Any) {
        AntBus.channel.router.call("LoginModule", key: "goLogin", params: nil, taskBlock: nil)
        
    }
}
