//
//  LoginAppDelegate.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit

class LoginAppDelegate: NSObject {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        AntBus.data.register("login.hasLogin") { (_) -> Any? in
            if let account:String = UserDefaults.standard.value(forKey: "login.user.account") as? String {
                return !account.isEmpty
            }
            return false
        }
        
        AntBus.data.register("login.user.account") { (_) -> Any? in
            return UserDefaults.standard.value(forKey: "login.user.account")
        }
        
        AntBus.router.register("LoginService.login", owner: self) { (_, _, _) in
            if let viewCtl:UIViewController = AntBus.data.call("app.current.controller").data as? UIViewController {
                let loginCtl:LoginViewController = LoginViewController.init()
                viewCtl.present(loginCtl, animated: true, completion: nil)
            }
        }
        AntBus.router.register("LoginService.logout", owner: self) { (_, _, _) in
            UserDefaults.standard.setValue(nil, forKey: "login.user.account")
            UserDefaults.standard.synchronize()
            AntBus.notification.post("logout.success")
        }
        
        AntBus.service.register(LoginService.self, method: #selector(LoginService.logout), owner: self) { (_, _, _) in
            UserDefaults.standard.setValue(nil, forKey: "login.user.account")
            UserDefaults.standard.synchronize()
            AntBus.notification.post("logout.success")
        }
        
        
        
    }
    
}
