//
//  FirstPageViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit
import AntBus
import CommonModule

@objc protocol IFirstPageController {
    
}

class FirstPageViewController: UIViewController,IFirstPageController {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        AntChannel.singleInterface(IFirstPageController.self).register(self)
    }
    
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
        
        AntBus.groupNotification.register("TestGroupKey", group: "TestGroup", owner: self) { group, groupIndex, data in
            print("FistPage group:\(group)  groupIndex:\(groupIndex)  data:\(data ?? "nil")")
        }
        
        AntBus.method.register("FirstPage", method: "hello") { data, resultBlock, taskBlock in
            resultBlock("Hi")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                taskBlock?("task Hi")
            }
        }
    }
    
    func refreshView(){
//        let result:AntBusResult = AntBus.data.call("login.user.account")
//        self.label.text = result.data as? String
        self.label.text = AntBusObject<LoginUser>.shared.object()?.account
    }
    @IBOutlet weak var label: UILabel!
    

    @IBAction func clickLogin(_ sender: Any) {
        AntServiceInterface<ILoginModule>.single.responder()?.showLoginPage()
    }
    
    @IBAction func clickLogout(_ sender: Any) {
        AntServiceInterface<ILoginModule>.single.responder()?.logout()
    }
    
    @IBAction func clickChangeTabBar(_ sender: Any) {
        let index = AntChannelInterface<TabBarProtocol>.single.responder()!.currentIndex()
        AntChannelInterface<TabBarProtocol>.single.responder()?.changeTabIndex(abs(1-index))
    }
    
}
