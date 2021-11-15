//
//  Page3V1ViewController.swift
//  AntBusDemo
//
//  Created by 李叶彪 on 2021/10/17.
//

import UIKit
import AntBus

class Page3V1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "page3_v1"
        
        let result = AntBus.method.call("FirstPage", method: "hello", data: nil) { data in
            print("taskBlock:\(data)")
        }
        print("success:\(result.success) dataBlock:\(result.data)")
        
    }

}
