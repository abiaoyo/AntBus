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
         
         
         
         */
        
        /*
         
         关于模块化：
         
         现有模块A、B
         中间件X
            中间件方案：
               1.MGJRouter   URL/字符串做为Key，字典传参数，需要存储空间
               2.CTMediator  通过Category扩展方法，动态调用，不需要多余存储空间
               3.AntBus -    AntService/AntChannel 通过数据共享的方式通过协议关联调用，需要存储空间
         A到B的最短距离：
            1.A直接引用B
            2.A通过中间件X间接引用B
              1).引用方式
                 a.中间件X强引用B
                 b.中间件X弱引用B
              2).传参方式
                 a.通过字典传参(缺点是不知道参数内容)
                 b.通过协议方法传参
         
         */
        
    }
}

