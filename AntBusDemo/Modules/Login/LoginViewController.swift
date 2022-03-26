//
//  LoginViewController.swift
//  AntBusDemo
//

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
