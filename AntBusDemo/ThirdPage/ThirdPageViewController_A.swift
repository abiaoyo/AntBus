//
//  ThirdPageViewController_A.swift
//  AntBusDemo
//
//  Created by liyebiao on 2021/6/9.
//

import UIKit
import AntBus

@objc protocol ThirdPageProtocolA : NSObjectProtocol {
    
    func test() -> String?
    
}


class ThirdPageViewController_A: UIViewController, ThirdPageProtocol, ThirdPageProtocolA {
    
    func test() -> String? {
        return "A"
    }
    
    deinit {
        print("deinit  \(self.classForCoder)")
    }
    
    func third_page() -> String?{
        return "Third_Page_A"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ThirdPageA"
        AntBus<ThirdPageProtocol>.multi.register(["ThirdPageA","PageA"], self)
        AntBus<ThirdPageProtocolA>.multi.register(["PageA"], self)
    }

    @IBAction func clickButton(_ sender: Any) {
        let viewCtl = ThirdPageViewController_B.init()
        self.navigationController?.pushViewController(viewCtl, animated: true)
    }

}
