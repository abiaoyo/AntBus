//
//  LoginPageViewController.swift
//  CommonModule
//
//  Created by abiaoyo
//

import UIKit
import AntBus

class LoginPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let account:String? = AntBus.data.call("login.user.account").data as? String
        self.accountTF.text = account
    }
    @IBOutlet weak var accountTF: UITextField!
    
    @IBAction func clickLogin(_ sender: Any) {
        UserDefaults.standard.setValue(self.accountTF.text, forKey: "user.account")
        UserDefaults.standard.synchronize()
        
        AntBus.notification.post("login.success")
        
        self.dismiss(animated: true) {
            
        }
    }
}
