# AntBus


```bash
pod 'AntBus', '~> 0.4.0'
```


##AntBusContainer
```swift

AntBus<TestLogin>.single.register(self);
AntBus<TestLogin>.single.responder()?.login()
AntBus<TestLogin>.single.remove()
         
         
AntBus<TestLogin>.multi.register(["viewCtl"], self)
AntBus<TestLogin>.multi.register("viewCtl", [self])
AntBus<TestLogin>.multi.responders("viewCtl")
AntBus<TestLogin>.multi.responders()
AntBus<TestLogin>.multi.remove(["viewCtl"])
AntBus<TestLogin>.multi.remove("viewCtl")
AntBus<TestLogin>.multi.remove(["viewCtl"], self)
AntBus<TestLogin>.multi.remove("viewCtl", self)
AntBus<TestLogin>.multi.removeAll()
         
//Notification
AntBus.channel.notification.register("login.success", owner: self) { _ in
              
}
AntBus.channel.notification.post("login.success", data: nil)
         
//data
AntBus.channel.data.register("user.name", owner: self) {
    return "user_001"             
}
AntBus.channel.data.call("user.name")
         
//router  
AntBus.channel.router.register("login", key: "page") { params, resultBlock, _ in
     resultBlock("")
}
AntBus.channel.router.call("login", key: "page", params: nil, taskBlock: nil)
         
//service == router  
AntBus.channel.service.register(TestLogin.self, method: #selector(login)) { _, _, _ in
     
}
AntBus.channel.service.call(TestLogin.self, method: #selector(login), params: nil, taskBlock: nil)

```
