import Foundation
import AntBus

class Demo {

    func testData(){
        AntBus.plus.data.register("int", owner: self) {
            return 100
        }
        let val = AntBus.plus.data.call("int")
        print("val:\(val)")
    }
    
    func testNotification() {
        AntBus.plus.notification.register("sss", owner: self) { data in
            print("noti.sss:\(data)")
        }
        AntBus.plus.notification.post("sss", data: "hello!")
        AntBus.plus.notification.post("sss")
    }
    
    func testContainer() {
        let sObj = ViewController.init()
        
        AntBus.plus.container.single.register(ViewController.self, object: sObj)
        AntBus.plus.container.single.object(ViewController.self)
        
        
        let mObj = ViewController.init()
        AntBus.plus.container.multiple.register(ViewController.self, object: mObj, forKeys: ["AA","BB"])
        AntBus.plus.container.multiple.register(ViewController.self, objects: [mObj], forKey: "CC")
        AntBus.plus.container.multiple.objects(ViewController.self, forKey: "AA")
        AntBus.plus.container.multiple.objects(ViewController.self, forKey: "BB")
        AntBus.plus.container.multiple.objects(ViewController.self)
        
    }
    
    func testCallback() {
        AntBus.plus.callback.register("dd", owner: self) { data, responseHandler in
            print("callback.data:\(data)")
            responseHandler(4000)
        }
        AntBus.plus.callback.call("dd", data: 2000) { data in
            print("response:\(data)")
        }
    }
    
    func testDeallocHook(){
        let vctl = UIViewController.init()
        AntBus.plus.deallocHook.install(for: vctl, propertyKey: "A", handlerKey: "B") { handleKeys in
            print("handleKeys:\(handleKeys)")
        }
    }
    
    func testKVO(){
        let vctl = UIViewController.init()
        AntBus.plus.kvo.add(keyPath: "title", for: vctl) { oldVal, newVal in
            print("oldVal:\(oldVal)     newVal:\(newVal)")
        }
        vctl.title = "vctl001"
    }
    
    func testMultiple() {
        let h6143s = AntBus.service.multiple.responders(DeviceProtocol.self, key:"H2001")
        
        let allDeviceService = AntBus.service.multiple.responders(DeviceProtocol.self)
        
        let h6143 = AntBus.service.multiple.responder(DeviceProtocol.self, key:"H2001") { resp in
            return resp.isSupport(sku: "H2001")
        }
    }

    func testSingle(){
        let loginService = AntBus.service.single.responder(LoginService.self)
        print("loginService:\(loginService)")
        loginService?.login(account: "")
    }
    
    func testAll(){
        let allSingleService = AntBus.service.single.allService()
        let allMultipleService = AntBus.service.multiple.allService()
        
        print("allSingleService:\(allSingleService as NSDictionary)")
        print("allMultipleService:\(allMultipleService as NSDictionary)")
        
    }
    
}
