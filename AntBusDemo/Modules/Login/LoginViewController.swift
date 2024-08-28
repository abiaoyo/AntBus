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
        
        AntBus.plus.kvo.add(keyPath: "title", for: self) { oldVal, newVal in
            print("title变动: .oldVal:\(oldVal)  .newVal:\(newVal)")
        }
        AntBus.plus.kvo.add(keyPath: "text", for: self.accountTF) { oldVal, newVal in
            print("accountTF.text变动: .oldVal:\(oldVal)  .newVal:\(newVal)")
        }
        self.title = "1234"
        self.accountTF.text = AntBus.service.single.responder(LoginService.self)?.loginInfo.account
        
        AntBus.plus.deallocHook.install(for: self, propertyKey: "key1", handlerKey: "keyHandle1") { handleKeys in
            
        }
        AntBus.plus.deallocHook.install(for: self, propertyKey: "key2", handlerKey: "keyHandle2") { handleKeys in
            
        }
        AntBus.plus.deallocHook.install(for: self, propertyKey: "key3", handlerKey: "keyHandle3") { handleKeys in
            
        }
        AntBus.plus.deallocHook.install(for: self.dictC, propertyKey: "TestDict", handlerKey: "TestDictHandler") { handleKeys in
            
        }
    }

    @IBAction func clickLogin(_ sender: Any) {
        AntBus.service.single.responder(LoginService.self)?.login(account: self.accountTF.text!)
        self.dismiss(animated: true, completion: nil)
    }

}
