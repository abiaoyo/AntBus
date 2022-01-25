//
//  Page3V1ViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/10/17.
//

import UIKit
import AntBus

@objc protocol Page3_V1_Controller {
    
}

class Page3V1ViewController: UIViewController,Page3_V1_Controller {

    deinit {
        print("deinit \(type(of: self))")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        AntChannel.multipleInterface(Page3_V1_Controller.self).register("page3_v1_controller", self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "page3_v1"
        
        let page3_v1 = AntChannel.multipleInterface(Page3_V1_Controller.self).responders()
        print("page_v1:\(page3_v1)")
        
        let result = AntBus.method.call("FirstPage", method: "hello", data: nil) { data in
            print("taskBlock:\(data)")
        }
        print("success:\(result.success) dataBlock:\(result.data)")
        
    }

}
