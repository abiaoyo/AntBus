# AntBus


```bash
pod 'AntBus', '~> 0.6.3'
```


##AntBusContainer
```swift

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
