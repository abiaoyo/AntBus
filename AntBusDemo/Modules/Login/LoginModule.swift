//
//  LoginModule.swift
//  AntBusDemo
//

//

import UIKit
import AntBus

class LoginModule: AntBusServiceSingle, LoginService {
    static func atbsSingleInitConfig() -> AntBusServiceSingleConfig {
        AntBusServiceSingleConfig.createForSwift(LoginService.self, serviceObj: LoginModule())
    }
    
    var loginInfo: LoginInfo = LoginInfo.init()

    func viewController() -> UIViewController {
        return LoginViewController.init()
    }
    
    func login(account:String) {
        print("Login: .account:\(account)")
        self.loginInfo.account = account
        AntBus.plus.notification.post("login.success")
    }
    
    func logout() {
        self.loginInfo.account = nil
        AntBus.plus.notification.post("logout.success")
    }
    
    
    
    
}
