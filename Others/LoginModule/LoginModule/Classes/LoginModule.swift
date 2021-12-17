//
//  LoginModule.swift
//  LoginModule
//
//  Created by abiaoyo
//

import Foundation
import AntBus
import CommonModule

class LoginModule:NSObject,IBaseModule, ILoginModule{
    
    //ILoginModule
    func logout() {
        UserDefaults.standard.setValue("", forKey: "user.account")
        UserDefaults.standard.synchronize()
        AntBus.notification.post("logout.success")
    }
    
    func showLoginPage() {
        let loginCtl = LoginPageViewController.init(nibName: "LoginPageViewController", bundle: Bundle.init(for: LoginModule.self))
        let curCtl:UIViewController = AntBus.data.call("app.current.controller").data as! UIViewController
        curCtl.present(loginCtl, animated: true, completion: nil)
        
    }
    
    //IBaseModule
    static func moduleInit() {
        let m = LoginModule.init()
        AntServiceInterface<ILoginModule>.single.register(m)
    }
    
    override init() {
        super.init()
        
        AntBus.data.register("login.user.account", owner: self) {
            let account = UserDefaults.standard.string(forKey: "user.account")
            return account
        }
    }
    
    
}
