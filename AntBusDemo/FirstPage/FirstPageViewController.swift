//
//  FirstPageViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit
import AntBus
import LoginModule

class FirstPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AntBus.channel.notification.register("login.success", owner: self) { [weak self] (_) in
            self?.refreshView()
        }
        AntBus.channel.notification.register("logout.success", owner: self) { [weak self] (_) in
            self?.refreshView()
        }
        self.refreshView()
    }
    func refreshView(){
        let result:AntBusResult = AntBus.channel.data.call("login.user.account")
        self.label.text = result.data as? String
    }
    @IBOutlet weak var label: UILabel!
    

    @IBAction func clickLogout(_ sender: Any) {
        AntBus.channel.service.call(ModuleLoginProtocol.self, method: #selector(ModuleLoginProtocol.logout), params: nil, taskBlock: nil)
    }
}
