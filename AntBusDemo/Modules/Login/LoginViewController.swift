//
//  LoginViewController.swift
//  AntBusDemo
//

//

import UIKit
import AntBus

class LoginViewController: UIViewController {

    @IBOutlet weak var accountTF: UITextField!
    
    var dictC = NSMutableDictionary.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AntBus.listener.listening(keyPath: "title", for: self) { oldVal, newVal in
            print("title变动: .oldVal:\(oldVal)  .newVal:\(newVal)")
        }
        AntBus.listener.listening(keyPath: "accountTF.text", for: self) { oldVal, newVal in
            print("accountTF.text变动: .oldVal:\(oldVal)  .newVal:\(newVal)")
        }
        self.title = "1234"
        self.accountTF.text = AntBusServiceI<LoginModule>.single.responder()?.loginInfo.account
        
        AntBus.deallocHook.installDeallocHook(for: self, propertyKey: "key1", handlerKey: "keyHandler1") { _ in
            
        }
        AntBus.deallocHook.installDeallocHook(for: self, propertyKey: "key2", handlerKey: "keyHandle2") { _ in
            
        }
        AntBus.deallocHook.installDeallocHook(for: self, propertyKey: "key2", handlerKey: "keyHandle3") { _ in
            
        }
        
        AntBus.deallocHook.installDeallocHook(for: self.dictC, propertyKey: "TestDict", handlerKey: "TestDictHandler") { _ in

        }
    }

    @IBAction func clickLogin(_ sender: Any) {
        AntBusServiceI<LoginModule>.single.responder()?.login(account: self.accountTF.text!)
        self.dismiss(animated: true, completion: nil)
    }

}
