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
        AntBusChannel.notification.post("logout.success")
    }
    
    func showLoginPage() {
        let loginCtl = LoginPageViewController.init(nibName: "LoginPageViewController", bundle: Bundle.init(for: LoginModule.self))
        let curCtl:UIViewController = AntBusChannel.data.call("app.current.controller").data as! UIViewController
        curCtl.present(loginCtl, animated: true, completion: nil)
        
    }
    
    //IBaseModule
    func moduleInit() {
        AntService<ILoginModule>.single.register(self)
        
        AntBusChannel.data.register("login.user.account", owner: self) {
            let account = UserDefaults.standard.string(forKey: "user.account")
            return account
        }
    }
    
    
}
