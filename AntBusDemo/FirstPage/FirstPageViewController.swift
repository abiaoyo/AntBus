//
//  FirstPageViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit
import AntBus
import CommonModule

class FirstPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AntBusChannel.notification.register("login.success", owner: self) { [weak self] (_) in
            self?.refreshView()
        }
        AntBusChannel.notification.register("logout.success", owner: self) { [weak self] (_) in
            self?.refreshView()
        }
        self.refreshView()
        
        AntBusChannel.groupNotification.register("TestGroupKey", group: "TestGroup", owner: self) { group, groupIndex, data in
            print("FistPage group:\(group)  groupIndex:\(groupIndex)  data:\(data ?? "nil")")
        }
    }
    func refreshView(){
        let result:AntBusResult = AntBusChannel.data.call("login.user.account")
        self.label.text = result.data as? String
    }
    @IBOutlet weak var label: UILabel!
    

    @IBAction func clickLogin(_ sender: Any) {
//        AntBus<ILoginModule>.single.responder()?.showLoginPage()
        AntService<ILoginModule>.single.responder()?.showLoginPage()
    }
    
    @IBAction func clickLogout(_ sender: Any) {
//        AntBus<ILoginModule>.single.responder()?.logout()
        AntService<ILoginModule>.single.responder()?.logout()
    }
    
    
}
