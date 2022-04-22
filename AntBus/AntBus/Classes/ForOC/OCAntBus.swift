import Foundation

@objcMembers
public class OCAntBusData:NSObject{
    
    public func register(key:String,owner:AnyObject,handler:@escaping AntBusDataHandler){
        AntBus.data.register(key, owner: owner, handler: handler)
    }
    
    public func canCall(key:String) -> Bool {
        return AntBus.data.canCall(key)
    }
    
    public func call(key:String) -> Any?{
        return AntBus.data.call(key).value
    }
    
    public func remove(key:String){
        AntBus.data.remove(key)
    }
    
    public func removeAll(){
        AntBus.data.removeAll()
    }
}

@objcMembers
public class OCAntBusNoti: NSObject{
    
    public func register(key:String,owner:AnyObject,handler:@escaping AntBusResultBlock){
        AntBus.notification.register(key, owner: owner, handler: handler)
    }
    
    public func post(key:String,data:Any?){
        AntBus.notification.post(key, data: data)
    }
    
    public func post(key:String){
        AntBus.notification.post(key)
    }
    
    public func remove(key:String,owner:AnyObject){
        AntBus.notification.remove(key, owner: owner)
    }
    
    public func remove(key:String){
        AntBus.notification.remove(key)
    }
    
    public func remove(owner:AnyObject){
        AntBus.notification.remove(owner: owner)
    }
    
    public func removeAll(){
        AntBus.notification.removeAll()
    }
}


@objcMembers
public class OCAntBus: NSObject {
    
    public static let data = OCAntBusData.init()
    public static let notification = OCAntBusNoti.init()
    public static let deallocHook = OCAntBusDeallocHook.shared
    public static let listener = OCAntBusListener.init()
    public static var printAliasName:Bool {
        get {
            return AntBus.printAliasName
        }
        set {
            AntBus.printAliasName = newValue
        }
    }
}
