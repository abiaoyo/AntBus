//
//  ThirdPageViewController.swift
//  AntBusDemo
//
//  Created by liyebiao on 2021/6/9.
//

import UIKit
import AntBus
import LoginModule


@objc protocol ThirdPageProtocol {
    
    func third_page() -> String?
    
}


class ThirdPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ThirdPage"
    }
    
    @IBAction func goThirdPageA(_ sender: Any) {
        let viewCtl = ThirdPageViewController_A.init()
        self.navigationController?.pushViewController(viewCtl, animated: true)
    }
    @IBAction func clickLogin(_ sender: Any) {
        AntBus<ModuleLoginProtocol>.single.responder()?.showLoginPage(viewController: self)
    }
}
