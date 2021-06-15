//
//  LoginViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit
import AntBus

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var accountTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func clickLogin(_ sender: Any) {
        
        if let account:String = self.accountTF.text {
            if(!account.isEmpty){
                UserDefaults.standard.setValue(account, forKey: "login.user.account")
                UserDefaults.standard.synchronize()
                AntBus.notification.post("login.success", data: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    

}
