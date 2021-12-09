# AntBus


```bash
pod 'AntBus', '~> 0.6.3'
```


##AntBusContainer
```swift

===== AntService >>>>> 强引用 =====
-------- AntService.multiple 一对多的情况 -----------
AntService<ModuleInterface>.multiple.register("A", moduleA_V1)
AntService<ModuleInterface>.multiple.register("A", moduleA_V2)
AntService<ModuleInterface>.multiple.register("B", moduleB)

AntService<ModuleInterface>.multiple.responders()
//moduleA_V1,moduleA_V2,moduleB

AntService<ModuleInterface>.multiple.responders("A")
//moduleA_V1,moduleA_V2

AntService<ModuleInterface>.multiple.responders("B")
//moduleB

-------- AntService.single 一对一的情况 -----------
AntService<ModuleInterface>.multiple.register(moduleA)

AntService<ModuleInterface>.multiple.responder()
//moduleA


==== AntBus >>>>> 弱引用 =====
AntBus<TestLogin>.single.register(self);
AntBus<TestLogin>.single.responder()?.login()
AntBus<TestLogin>.single.remove()
         
         
AntBus<TestLogin>.multi.register(["viewCtl"], self)
AntBus<TestLogin>.multi.register("viewCtl", [self])
AntBus<TestLogin>.multi.responders("viewCtl")
AntBus<TestLogin>.multi.responders()
AntBus<TestLogin>.multi.remove(["viewCtl"])
AntBus<TestLogin>.multi.remove("viewCtl")
/*
         ------------------------------------------------------
         AntBus.data
         AntBus.method
         AntBus.notification
         AntBus.groupNotification
         
         AntChannel.singleInterface
         AntChannel.multipleInterface
         AntChannelInterface
         
         AntService.singleInterface
         AntService.multipleInterface
         AntServiceInterface
         ------------------------------------------------------
         
         eg: AntChannel.singleInterface(LoginInterface.self).register(self)
             AntChannel.singleInterface(LoginInterface.self).responder()
             
             AntChannel.multipleInterface(LoginInterface.self).register(["TA","TB"],self)
             ==> AntChannel.multipleInterface(LoginInterface.self).register("TA",self)
                 AntChannel.multipleInterface(LoginInterface.self).register("TB",self)
         
             AntChannel.multipleInterface(LoginInterface.self).responders("TA")
         
             ❌: AntChannelInterface.single.register(self)
             ✅: AntChannelInterface<LoginInterface>.single.register(self)
             ✅: AntChannelInterface<LoginInterface>.single.responder()
             
             ❌: AntChannelInterface.multiple.register(["TA","TB"],self)
             ✅: AntChannelInterface<LoginInterface>.multiple.register(["TA","TB"],self)
             ✅: AntChannelInterface<LoginInterface>.multiple.responders("TA")
         
             
         eg: AntService.singleInterface(LoginInterface.self).register()
             AntService.singleInterface(LoginInterface.self).responder()
         
             AntService.multipleInterface(LoginInterface.self).register(["A","B"],self)
             ==> AntService.multipleInterface(LoginInterface.self).register("A",self)
                 AntService.multipleInterface(LoginInterface.self).register("B",self)
         
             AntService.multipleInterface(LoginInterface.self).responders("A")
             
             ❌: AntServiceInterface.single.register(self)
             ✅: AntServiceInterface<LoginInterface>.single.register()
             ✅: AntServiceInterface<LoginInterface>.single.responder()
         
             ❌: AntServiceInterface.multiple.register(["A","B"],self)
             ✅: AntServiceInterface<LoginInterface>.multiple.register(["A","B"],self)
             ✅: AntServiceInterface<LoginInterface>.multiple.responders("A")
         
         ------------------------------------------------------
         ------------------------------------------------------
         ------------------------------------------------------
         
         AntBus.groupNotification.register("", group: "", owner: self) { group, groupIndex, data in
             //...
         }
         
         AntBus.groupNotification.post("", group: "B", data: nil)
         AntBus.groupNotification.post("", data: nil)
         AntBus.groupNotification.remove("", group: "", owner: self)
         AntBus.groupNotification.remove("", group: "")
         AntBus.groupNotification.remove("")
         AntBus.groupNotification.removeAll()
         
         
         AntChannelInterface<TestLogin>.single.register(self);
         AntChannelInterface<TestLogin>.single.responder()?.login()
         AntChannelInterface<TestLogin>.single.remove()
         
         AntChannelInterface<TestLogin>.multi.register(["viewCtl"], self)
         AntChannelInterface<TestLogin>.multi.register("viewCtl", [self])
         AntChannelInterface<TestLogin>.multi.responders("viewCtl")
         AntChannelInterface<TestLogin>.multi.responders()
         AntChannelInterface<TestLogin>.multi.remove(["viewCtl"])
         AntChannelInterface<TestLogin>.multi.remove("viewCtl")
         AntChannelInterface<TestLogin>.multi.remove(["viewCtl"], self)
         AntChannelInterface<TestLogin>.multi.remove("viewCtl", self)
         AntChannelInterface<TestLogin>.multi.removeAll()
         
         
         
         
         AntBus.notification.register("login.success", owner: self) { _ in
             //login.success
         }
         AntBus.notification.post("login.success", data: nil)
         
         
         
         
         AntBus.data.register("hasLogin", owner: self) {
             return true
         }
         let hasLogin = AntBus.data.call("hasLogin").data
         >>>> print
         true
         
         AntBus.method.register("FirstPage", key: "hello") { data, resultBlock, taskBlock in
            resultBlock("Hi")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                taskBlock?("task Hi")
            }
         }
         let result = AntBus.method.call("FirstPage", method: "hello", data: nil) { data in
             print("taskBlock:\(data)")
         }
         print("success:\(result.success) dataBlock:\(result.data)")
         >>>> print
         success:true dataBlock:Optional("Hi")
         taskBlock:Optional("task Hi")

```
