//
//  Page4ViewController.swift
//  AntBusDemo
//
//  Created by 李叶彪 on 2021/10/17.
//

import UIKit
import AntBus

class Page4ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Page4"
        
        AntBusChannel.groupNotification.register("TestGroupKey", group: "TestGroup2", owner: self) { group, groupIndex, data in
            print("Page4 group:\(group)  groupIndex:\(groupIndex)  data:\(data ?? "nil")")
        }
        
        AntBusChannel.groupNotification.post("TestGroupKey", data: nil)
    }
}
