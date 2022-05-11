import Foundation

@objcMembers
public class OCAntBusData: NSObject {
    public static let shared = OCAntBusData()
    
    public func register(key: String, owner: AnyObject, handler: @escaping AntBusData.DataHandler) {
        AntBus.data.register(key, owner: owner, handler: handler)
    }
    
    public func canCall(key: String) -> Bool {
        return AntBus.data.canCall(key)
    }
    
    public func call(key: String) -> Any? {
        return AntBus.data.call(key)
    }
    
    public func remove(key: String) {
        AntBus.data.remove(key)
    }
    
    public func removeAll() {
        AntBus.data.removeAll()
    }
}

@objcMembers
public class OCAntBusNoti: NSObject {
    public static let shared = OCAntBusNoti()
    
    public func register(key: String, owner: AnyObject, handler: @escaping AntBusNotification.NotificationHandler) {
        AntBus.notification.register(key, owner: owner, handler: handler)
    }
    
    public func post(key: String, data: Any?) {
        AntBus.notification.post(key, data: data)
    }
    
    public func post(key: String) {
        AntBus.notification.post(key)
    }
    
    public func remove(key: String, owner: AnyObject) {
        AntBus.notification.remove(key, owner: owner)
    }
    
    public func remove(key: String) {
        AntBus.notification.remove(key)
    }
    
    public func remove(owner: AnyObject) {
        AntBus.notification.remove(owner: owner)
    }
    
    public func removeAll() {
        AntBus.notification.removeAll()
    }
}

@objcMembers
public class OCAntBusChannel: NSObject {
    public static let shared = OCAntBusChannel()
    
    public let single = OCAntBusChannelCS()
    public let multi = OCAntBusChannelCM()
}

@objcMembers
public class OCAntBusService: NSObject {
    public static let shared = OCAntBusService()
    
    public let single = OCAntBusServiceSS()
    public let multi = OCAntBusServiceSM()
}

@objcMembers
public class OCAntBus: NSObject {
    public static let data = OCAntBusData.shared
    public static let notification = OCAntBusNoti.shared
    public static let deallocHook = OCAntBusDeallocHook.shared
    public static let listener = OCAntBusListener.shared
    public static let channel = OCAntBusChannel.shared
    public static let service = OCAntBusService.shared
}

public extension OCAntBus {
    static var deallocLog: ((_ log: String) -> Void)? {
        set { AntBus.deallocLog = newValue }
        get { return AntBus.deallocLog }
    }

    static var channelLog: ((_ log: String) -> Void)? {
        set { AntBus.channelLog = newValue }
        get { return AntBus.channelLog }
    }

    static var serviceLog: ((_ log: String) -> Void)? {
        set { AntBus.serviceLog = newValue }
        get { return AntBus.serviceLog }
    }
    
    static func printLog(_ str: String) {
        AntBus.printLog(str)
    }
}
