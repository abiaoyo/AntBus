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
        
        AntBus.groupNotification.register("TestGroupKey", group: "TestGroup2", owner: self) { group, groupIndex, data in
            print("Page4 group:\(group)  groupIndex:\(groupIndex)  data:\(data ?? "nil")")
        }
        
        AntBus.groupNotification.post("TestGroupKey", data: nil)
    }
}
