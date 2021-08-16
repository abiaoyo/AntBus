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
         
         
         AntBus.channel.notification.register("", owner: self) { _ in
             
         }
         AntBus.channel.notification.post("", data: nil)
         
         
         AntBus.channel.data.register("", owner: self) {
             
         }
         AntBus.channel.data.call("")
         
         
         
         AntBus.channel.router.register("", key: "") { params, resultBlock, _ in
             resultBlock("")
         }
         AntBus.channel.router.call("", key: "", params: nil, taskBlock: nil)
         
         
         
         AntBus.channel.service.register(TestLogin.self, method: #selector(login)) { _, _, _ in
             
         }
         AntBus.channel.service.call(TestLogin.self, method: #selector(login), params: nil, taskBlock: nil)
```
