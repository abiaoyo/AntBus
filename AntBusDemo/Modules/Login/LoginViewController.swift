//
//  LoginViewController.swift
//  AntBusDemo
//
//  Created by 李叶彪 on 2022/3/26.
//

import UIKit
import AntBus

class LoginViewController: UIViewController {

    @IBOutlet weak var accountTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountTF.text = AntBusServiceI<LoginModule>.single.responder()?.loginInfo.account
    }

    @IBAction func clickLogin(_ sender: Any) {
        AntBusServiceI<LoginModule>.single.responder()?.login(account: self.accountTF.text!)
        self.dismiss(animated: true, completion: nil)
    }

}
