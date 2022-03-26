//
//  LoginModule.swift
//  AntBusDemo
//
//  Created by 李叶彪 on 2022/3/26.
//

import UIKit
import AntBus

class LoginModule: NSObject {
    
    var loginInfo:LoginInfo = LoginInfo.init()
    
    func goLoginPage() {
        let vctl = LoginViewController.init()
        AntBusChannelI<TabBarProtocol>.single.responder()?.currentNavController().present(vctl, animated: true, completion: nil)
    }
    
    func login(account:String) {
        print("Login: .account:\(account)")
        self.loginInfo.account = account
        AntBus.notification.post("login.success")
    }
    
    func logout() {
        self.loginInfo.account = nil
        AntBus.notification.post("logout.success")
    }
    
    
    
    
}
