# AntBus


```bash
pod 'AntBus', '~> 0.5.0'
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
AntBus<TestLogin>.multi.remove(["viewCtl"], self)
AntBus<TestLogin>.multi.remove("viewCtl", self)
AntBus<TestLogin>.multi.removeAll()
         
//======== Notification 通知 =========
AntBus.channel.notification.register("login.success", owner: self) { _ in
              
}
AntBus.channel.notification.post("login.success", data: nil)

//======== Notification Group  通知组，可让通知部分响应 =========
AntBusChannel.groupNotification.register("login.success", group: "A", owner: AAA) { group, groupIndex, data in
     print(" group:\(group)  groupIndex:\(groupIndex)  data:\(data ?? "nil")")
}
AntBusChannel.groupNotification.register("login.success", group: "A", owner: BBB) { group, groupIndex, data in
     print(" group:\(group)  groupIndex:\(groupIndex)  data:\(data ?? "nil")")
}
AntBusChannel.groupNotification.register("login.success", group: "B", owner: CCC) { group, groupIndex, data in
     print(" group:\(group)  groupIndex:\(groupIndex)  data:\(data ?? "nil")")
}
AntBusChannel.groupNotification.post("login.success", data: nil)
//AAA,BBB,CCC
AntBusChannel.groupNotification.post("login.success", group: "A", data: nil)
//AAA,BBB
         
//============== data 数据共享 ===============
AntBus.channel.data.register("user.name", owner: self) {
    return "user_001"             
}
AntBus.channel.data.call("user.name")
//user_001
         
//============ router （放弃了） ==============
AntBus.channel.router.register("login", key: "page") { params, resultBlock, _ in
     resultBlock("")
}
AntBus.channel.router.call("login", key: "page", params: nil, taskBlock: nil)
         
//============ service == router （放弃了）  =============
AntBus.channel.service.register(TestLogin.self, method: #selector(login)) { _, _, _ in
     
}
AntBus.channel.service.call(TestLogin.self, method: #selector(login), params: nil, taskBlock: nil)

```
