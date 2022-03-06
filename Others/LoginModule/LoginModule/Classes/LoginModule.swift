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
//        UserDefaults.standard.setValue("", forKey: "user.account")
//        UserDefaults.standard.synchronize()
//        AntBusObject<LoginUser>.shared.object()?.account = ""
        AntBus.sharedObject.object(LoginUser.self)?.account = ""
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
        
//        AntBus.data.register("login.user.account", owner: self) {
//            let account = UserDefaults.standard.string(forKey: "user.account")
//            return account
//        }
        AntBus.sharedObject.register(LoginUser.init(), type: LoginUser.self, owner: self)
//        AntBusObject<LoginUser>.shared.register(LoginUser.init(), owner:self)
    }
    
    
}
