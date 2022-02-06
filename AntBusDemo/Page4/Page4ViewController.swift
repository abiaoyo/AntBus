//
//  Page4ViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/10/17.
//

import UIKit
import AntBus

class Page4ViewController: UIViewController {

    deinit {
        print("deinit \(type(of: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Page4"
        
        AntBus.groupNotification.register("TestGroupKey", group: "TestGroup2", owner: self) { index, count, data in
            print("Page4 TestGroupKey TestGroup2 index:\(index) count:\(count) data:\(data ?? "nil")")
        }
        
        let testInfo = ["account":"use001","password":"123456"]
        
        print("=============")
        AntBus.groupNotification.post("TestGroupKey", data: testInfo)
        print("=============")
        AntBus.groupNotification.post("TestGroupKey", group: "TestGroup2", data: testInfo)
        print("=============")
        AntBus.groupNotification.post("TestGroupKey", group: "TestGroup", data: testInfo)
        print("=============")
        AntBus.groupNotification.post("TestGroupKey", group: "AppDelegate", data: testInfo)
    }
}
