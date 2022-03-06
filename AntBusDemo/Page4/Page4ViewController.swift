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
    }
}
