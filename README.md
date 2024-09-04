# AntBus 2.0.0 

AntBus: iOS模块化/组件化/通讯中间件，兼容Swift和OC

## 安装
```swift
   只支持Swift使用如下：
   pod 'AntBus', '~> 2.0.0'
   支持OC使用如下：
   pod 'AntBus/OC', '~> 2.0.0'
```

## 介绍
```swift
AntBus：
   服务：AntBus.service
        用于注册/调用模块服务
        AntBus.service.single   一对一的服务
        AntBus.service.multiple   多对多的服务
   扩展：AntBus.plus
        AntBus.plus.data   共享局部数据
        AntBus.plus.notification    自定义的通知
        AntBus.plus.callback        回调
        AntBus.plus.deallocHook     dealloc/deinit回调
        AntBus.plus.kvo             KVO监听
        AntBus.plus.container       对象容器
优点：
   模块化方便快捷，简单易用，Swift、OC兼容
缺点：
   需提前注册，占用内存，不可动态配置服务
```
> Note: 模块间通过服务协议关联，那么服务协议放哪里比较合适呢？
```swift
  #利用pod创建一个Services库，专门用来放服务协议; 
  pod lib create Service
```   

## AntBus.service用法用例
1.在AppDelegate中进行注册及日志打印
   ```swift
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        //打印日志 
        AntBus.log.setHandler { type, log in
            AntBus.log.printLog(log)
        }
        #endif
        //注册一对一服务
        AntBus.service.single.register()
        //注册多对多服务
        AntBus.service.multiple.register()
        
        return true
  }
  ```
  
2.模块(服务)注册(创建)，在模块代码的入口类实现AntBusService协议
  一对一服务，如：登录模块代码
  ```swift
  //登录模块
  public class Login:AntBusServiceSingle, LoginService {
  
    //AntBusServiceSingle
    static func atbsSingleInitConfig() -> AntBusServiceSingleConfig {
        return AntBusServiceSingleConfig.createForSwift(LoginService.self, cache: true) {
            return Login.init()
        }
    }
    
    //LoginService
    public func login(username: String, password: String, complete: (Error?) -> Void) {
        print("login success")
        complete(nil)
    }
  }
  ```
  多对多服务，如设备模块代码
  ```swift
  //H6143设备模块
  public class H6143:AntBusServiceMultiple, DeviceService {
    
    //AntBusServiceMultiple
    //这里是初始化的注册
    public static func atbsMultipleInitConfigs() -> [AntBusServiceMultipleConfig] {
        let config = AntBusServiceMultipleConfig.createForSwift(DeviceService.self, keys: ["H6143","H6163"], createService: {
            return H6143.shared
        })
        return [config]
    }
    //这里是更新的key变动(保留，一般不会用到）
    public static func atbsMultipleUpdateConfigs() -> [AntBusServiceMultipleUpdateConfig]? {
        let config = AntBusServiceMultipleUpdateConfig.createForSwift(DeviceService.self, addKeys: ["H611A"], deleteKeys: [])
        return [config]
    }
    
    //DeviceService
    public func support(_ sku: String, _ version: Int) -> Bool{
         return version <= 2
    }
    
    static let shared = H6143.init()
 }
 ```
  
3.调用模块，任意地方都可调用
  单服务调用
```swift
  //登录模块代码
  let loginService = AntBus.service.single.responder(LoginService.self)
  loginService?.login(username: "user001", password: "123456", complete: { _ in
     //..
  })
```
 多服务调用
```swift
  //h6143模块代码
  //取全部h6143服务
  let h6143s = AntBus.service.multiple.responders(DeviceService.self, "H6163")
  
  //取一个h6143支持version为3的服务
  let h6143 = AntBus.service.multiple.responder(DeviceService.self, "H6163") { resp in
     return resp.support("H6163", 3)
  }
```
## AntBus.plus用法用例
```swift

    数据：远程数据/共享数据/绑定数据
    func testData(){
        AntBus.plus.data.register("int", owner: self) {
            return 100
        }
        let val = AntBus.plus.data.call("int")
        print("val:\(val)") //100
    }

    代替系统通知
    func testNotification() {
        AntBus.plus.notification.register("sss", owner: self) { data in
            print("noti.sss:\(data)")
        }
        AntBus.plus.notification.post("sss", data: "hello!")
        AntBus.plus.notification.post("sss") 
        //hello!
    }

    容器：远程对象/共享对象/绑定对象，一对一/一对多
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

    回调：远程回调
    func testCallback() {
        AntBus.plus.callback.register("dd", owner: self) { data, responseHandler in
            print("callback.data:\(data)")
            responseHandler(4000)
        }
        AntBus.plus.callback.call("dd", data: 2000) { data in
            print("response:\(data)")
        }
    }

    对象销毁回调
    func testDeallocHook(){
        let vctl = UIViewController.init()
        AntBus.plus.deallocHook.install(for: vctl, propertyKey: "A", handlerKey: "B") { handleKeys in
            print("handleKeys:\(handleKeys)")
        }
    }

    代替系统KVO
    func testKVO(){
        let vctl = UIViewController.init()
        AntBus.plus.kvo.add(keyPath: "title", for: vctl) { oldVal, newVal in
            print("oldVal:\(oldVal)     newVal:\(newVal)")
        }
        vctl.title = "vctl001"
    }

```
