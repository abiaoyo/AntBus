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
public class OCAntBusChannel: NSObject{
    public let single = OCAntBusChannelCS.init()
    public let multi = OCAntBusChannelCM.init()
}

@objcMembers
public class OCAntBusService: NSObject{
    public let single = OCAntBusServiceSS.init()
    public let multi = OCAntBusServiceSM.init()
}

@objcMembers
public class OCAntBus: NSObject {
    
    public static let data = OCAntBusData.init()
    public static let notification = OCAntBusNoti.init()
    public static let deallocHook = OCAntBusDeallocHook.shared
    public static let listener = OCAntBusListener.init()
    public static let channel = OCAntBusChannel.init()
    public static let service = OCAntBusService.init()
}

extension OCAntBus {
    public static var deallocLog:((_ log: String) -> Void)? {
        set {
            AntBus.deallocLog = newValue
        }
        get {
            return AntBus.deallocLog
        }
    }
    public static var channelLog:((_ log: String) -> Void)? {
        set {
            AntBus.channelLog = newValue
        }
        get {
            return AntBus.channelLog
        }
    }
    public static var serviceLog:((_ log: String) -> Void)? {
        set {
            AntBus.serviceLog = newValue
        }
        get {
            return AntBus.serviceLog
        }
    }
    
    
    
    public static func printLog(_ str:String) {
        AntBus.printLog(str)
    }
}
