# AntBus


```bash
pod 'AntBus', '~> 0.2.1'
```


```swift
1.shared
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


2.router
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


3.service
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

4.notification
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
```
