//
//  ViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/11.
//

import UIKit
import AntBus

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         AntBusContainer
         
         1 to 1 delegate
         AntBusContainer<LoginModule>.single.register(self)
         AntBusContainer<LoginModule>.single.responser()
         AntBusContainer<LoginModule>.single.remove()
         
         multi delegate
         AntBusContainer<LoginModule>.multi.register(["H6143","H6159"],self)
         AntBusContainer<LoginModule>.multi.responsers("H6143")
         AntBusContainer<LoginModule>.multi.responsers()
         AntBusContainer<LoginModule>.multi.register(["H6143"], self)
         AntBusContainer<LoginModule>.multi.remove(["H6143"])
         AntBusContainer<LoginModule>.multi.remove(["H6143"], self)
         AntBusContainer<LoginModule>.multi.remove("H6143",self)
         AntBusContainer<LoginModule>.multi.remove("H6143")
         AntBusContainer<LoginModule>.multi.remove()
         
         1.ThirdPageViewController_A
         AntBusContainer<ThirdPageProtocol>.multi.register(["ThirdPageA","PageA"], self)
         AntBusContainer<ThirdPageProtocolA>.multi.register(["PageA"], self)
         
         2.ThirdPageViewController_B
         AntBusContainer<ThirdPageProtocol>.multi.register(["ThirdPageB"], self)
         
         
         3.ThirdPageViewController_C
         AntBusContainer<ThirdPageProtocol>.multi.register(["ThirdPageC"], self)
         
         @IBAction func removePageB(_ sender: Any) {
             AntBusContainer<ThirdPageProtocol>.multi.remove("ThirdPageB")
         }
         
         @IBAction func callResponsers(_ sender: Any) {
             let responserA = AntBusContainer<ThirdPageProtocol>.multi.responsers("ThirdPageA")
             print("ThirdPageProtocol.responserA:\(responserA)")
             
             let responserA2 = AntBusContainer<ThirdPageProtocol>.multi.responsers("PageA")
             print("ThirdPageProtocol.responserA2:\(responserA2)")
             
             let responserB = AntBusContainer<ThirdPageProtocol>.multi.responsers("ThirdPageB")
             print("ThirdPageProtocol.responserB:\(responserB)")
             
             let responserC = AntBusContainer<ThirdPageProtocol>.multi.responsers("ThirdPageC")
             print("ThirdPageProtocol.responserC:\(responserC)")
             
             let responsers = AntBusContainer<ThirdPageProtocol>.multi.responsers()
             print("ThirdPageProtocol:  .count:\(responsers?.count)   .responsers:\(responsers)")
             
             
             let PageA = AntBusContainer<ThirdPageProtocolA>.multi.responsers("PageA")
             print("ThirdPageProtocolA.PageA:\(PageA)")
         }
         
         
         
         
         */
        
        

        /*

         AntBus
         
        //注册数据：是否已经登录
        AntBus.shared.register("LoginModel.hasLogin", owner: self) { () -> Any? in
            if let account:String = UserDefaults.standard.value(forKey: "login.token") as? String {
                return !account.isEmpty
            }
            return false
        }
        //是否能调用
        if AntBus.shared.canCall("LoginModel.hasLogin") {
            //调用是否已经登录
            let result:AntBusResult = AntBus.shared.call("LoginModel.hasLogin")
            if result.success {
                print("call success")
                let hasLogin:Bool = result.data as! Bool
                if(hasLogin){
                    print("has login")
                }else{
                    print("not login")
                }
            }else{
                print("call failure")
            }
        }
        //移除 - 在不必要提前移除的时候可不调用，因为回调的生命周期与owner绑定在一起的
        AntBus.shared.remove("LoginModel.hasLogin")
        AntBus.shared.removeAll()
        
        
        //注册路由：到登录界面
        AntBus.router.register("LoginModule", key: "login.page.pop") { (params, resultBlock, taskBlock) in
            if let viewCtl:UIViewController = AntBus.shared.call("app.current.controller").data as? UIViewController {
                let loginCtl:LoginViewController = LoginViewController.init()
                viewCtl.present(loginCtl, animated: true, completion: nil)
            }
        }
        //是否能调用
        AntBus.router.canCall("LoginModule", key: "login.page.pop")
        //弹出登录界面
        AntBus.router.call("LoginModule", key: "login.page.pop", params: nil, taskBlock: nil)
        //移除路由：到登录界面
        AntBus.router.remove("LoginModule", key: "login.page.pop")
        //移除登录模块
        AntBus.router.remove("LoginModule")
        //移除所有模块
        AntBus.router.removeAll()
        
        
        //注册服务：与router一致，差别是提供了协议名调用
        AntBus.service.register(LoginModule.self, method: #selector(LoginModule.popLoginPage)) { (_, _, _) in
            if let viewCtl:UIViewController = AntBus.shared.call("app.current.controller").data as? UIViewController {
                let loginCtl:LoginViewController = LoginViewController.init()
                viewCtl.present(loginCtl, animated: true, completion: nil)
            }
        }
        AntBus.service.canCall(LoginModule.self, method: #selector(LoginModule.popLoginPage))
        AntBus.service.call(LoginModule.self, method: #selector(LoginModule.popLoginPage), params: nil, taskBlock: nil)
        AntBus.service.remove(LoginModule.self, method: #selector(LoginModule.popLoginPage))
        AntBus.service.remove(LoginModule.self)
        AntBus.service.removeAll()
        
        //service: 关于参数，任务回调
        AntBus.service.register(LoginModule.self, method: #selector(LoginModule.login(account:password:))) { (params, resultBlock, taskBlock) in
            let account:String? = params?["account"] as? String
            let password:String? = params?["password"] as? String
            if(account != nil && password != nil){
                let token:String = account!+"_"+password!
                resultBlock(token)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                if(taskBlock != nil){
                    taskBlock!("async task completion")
                }
            }
        }
        
        //注册通知：
        AntBus.notification.register("login.success", owner: self) { (data) in
            print("noti: .login.success")
        }
        AntBus.notification.post("login.success")
        AntBus.notification.post("login.success", data: nil)
        AntBus.notification.post("login.success", data: nil) { (owner,data) -> Bool in
            if(data == nil){
                return false
            }
            return true
        }
        AntBus.notification.remove("login.success")
        AntBus.notification.remove(owner: self)
        AntBus.notification.remove("login.success", owner: self)
        AntBus.notification.removeAll()
        
         */
    }
}

