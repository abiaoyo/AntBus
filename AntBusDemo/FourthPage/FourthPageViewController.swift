//
//  FourthPageViewController.swift
//  AntBusDemo
//
//  Created by 李叶彪 on 2021/6/11.
//

import UIKit
import AntBus


@objc protocol FourthPageProtocol{
    func pageTitle() -> String
}


class FourthPageViewController: UIViewController, FourthPageProtocol {
    func pageTitle() -> String {
        return "FourthPage"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AntBus<FourthPageProtocol>.single.register(self)
    }

    @IBAction func goFourthPageA(_ sender: Any) {
        let viewCtl = FourthPageViewController_A.init()
        self.navigationController?.pushViewController(viewCtl, animated: true)
    }
}
