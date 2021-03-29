//
//  FirstPageViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit

class FirstPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AntBus.notification.register("login.success", owner: self) { [weak self] (_) in
            self?.refreshView()
        }
        AntBus.notification.register("logout.success", owner: self) { [weak self] (_) in
            self?.refreshView()
        }
        self.refreshView()
    }
    func refreshView(){
        let result:AntBusResult = AntBus.shared.call("login.user.account")
        self.label.text = result.data as? String
    }
    @IBOutlet weak var label: UILabel!
    

    @IBAction func clickLogout(_ sender: Any) {
//        AntBus.router.call("LoginModule", key: "logout", params: nil, taskBlock: nil)
        AntBus.service.call(LoginModule.self, method: #selector(LoginModule.logout), params: nil, taskBlock: nil)
    }
}
