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
         
         AntBusChannel.groupNotification.register("", group: "", owner: self) { group, groupIndex, data in
             //...
         }
         
         AntBusChannel.groupNotification.post("", group: "B", data: nil)
         AntBusChannel.groupNotification.post("", data: nil)
         AntBusChannel.groupNotification.remove("", group: "", owner: self)
         AntBusChannel.groupNotification.remove("", group: "")
         AntBusChannel.groupNotification.remove("")
         AntBusChannel.groupNotification.removeAll()
         
         
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
         
         
         AntBusChannel.notification.register("", owner: self) { _ in
             
         }
         AntBusChannel.notification.post("", data: nil)
         
         
         AntBusChannel.data.register("", owner: self) {
             
         }
         AntBusChannel.data.call("")
         
         
         
         AntBusChannel.router.register("", key: "") { params, resultBlock, _ in
             resultBlock("")
         }
         AntBusChannel.router.call("", key: "", params: nil, taskBlock: nil)
         
         
         
         AntBusChannel.service.register(TestLogin.self, method: #selector(login)) { _, _, _ in
             
         }
         AntBusChannel.service.call(TestLogin.self, method: #selector(login), params: nil, taskBlock: nil)
         
         
         */
        
        /*
         
         关于模块化：
         
         现有模块A、B
         中间件X
            中间件方案：
               1.MGJRouter   URL/字符串做为Key，字典传参数，需要存储空间
               2.CTMediator  通过Category扩展方法，动态调用，不需要多余存储空间
               3.AntBus      运用数据共享的方式通过协议关联调用，需要存储空间
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

