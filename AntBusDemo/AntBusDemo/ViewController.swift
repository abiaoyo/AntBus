//
//  ViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        AntBus.notification.register("login.success", owner: self) { (data) in
            
        }
        AntBus.notification.post("login.success", data: ["account":"lisi","password":"123456"])
        
        AntBus.data.register("login.user.nickname", owner: self) { (_) -> Any? in
            return "zhangsan"
        }
        let result:AntBusResult = AntBus.data.call("login.user.nickname", params: ["account":"zs001"])
        print("nickname:\(String(describing: result.data))")
        
        AntBus.router.register("", owner: self) { (params, resultBlock:(Any?) -> Void, taskBlock:AntBusTaskBlock?) in
            
        }
        AntBus.router.register("") { (params, resultBlock:(Any?) -> Void, taskBlock:AntBusTaskBlock?) in
            
        }
        let rs:AntBusResult = AntBus.router.call("", params: nil) { (data) in
            
        }
    }


}

