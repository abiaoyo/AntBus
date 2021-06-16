//
//  LoginAppDelegate.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit
import AntBus

class LoginAppDelegate: AntBusBaseModule,LoginModule{
    
    //MARK:LoginModule
    func logout() {
        
    }
    
    func goLoginPage() {
        
    }
    
    func showLoginPage(viewController: UIViewController!) {
        let loginCtl = LoginViewController.init(nibName: "LoginViewController", bundle: Bundle.init(for: LoginAppDelegate.self))
        viewController.present(loginCtl, animated: true, completion: nil)
    }
    
    //MARK:UIApplicationDelegate
    @discardableResult
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AntBusContainer<LoginModule>.single.register(self)
        
        AntBus.shared.register("login.hasLogin", owner: self) { () -> Any? in
            if let account:String = UserDefaults.standard.value(forKey: "login.user.account") as? String {
                return !account.isEmpty
            }
            return false
        }
        
        AntBus.shared.register("login.user.account", owner: self) { () -> Any? in
            return UserDefaults.standard.value(forKey: "login.user.account")
        }
        
        AntBus.router.register("LoginModule", key: "goLogin") { (params, resultBlock, taskBlock) in
            if let viewCtl:UIViewController = AntBus.shared.call("app.current.controller").data as? UIViewController {
                let loginCtl = LoginViewController.init(nibName: "LoginViewController", bundle: Bundle.init(for: LoginAppDelegate.self))
                viewCtl.present(loginCtl, animated: true, completion: nil)
            }
        }
        
        AntBus.router.register("LoginModule", key: "logout") { (params, resultBlock, taskBlock) in
            UserDefaults.standard.setValue(nil, forKey: "login.user.account")
            UserDefaults.standard.synchronize()
            AntBus.notification.post("logout.success")
        }
        
        AntBus.service.register(LoginModule.self, method: #selector(LoginModule.logout)) { (params, resultBlock, taskBlock) in
            UserDefaults.standard.setValue(nil, forKey: "login.user.account")
            UserDefaults.standard.synchronize()
            AntBus.notification.post("logout.success")
        }
        
        return true
    }
}
