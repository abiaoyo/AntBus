import Foundation

@objcMembers
public class OCAntBusNotification: NSObject {
    public static let shared = OCAntBusNotification()
    
    public func register(key: String, owner: AnyObject, handler: @escaping AntBusNotification.NotificationHandler) {
        AntBus.plus.notification.register(key, owner: owner, handler: handler)
    }
    
    public func post(key: String, data: Any?) {
        AntBus.plus.notification.post(key, data: data)
    }
    
    public func post(key: String) {
        AntBus.plus.notification.post(key)
    }
    
    public func remove(key: String, owner: AnyObject) {
        AntBus.plus.notification.remove(key, owner: owner)
    }
    
    public func remove(key: String) {
        AntBus.plus.notification.remove(key)
    }
    
    public func remove(owner: AnyObject) {
        AntBus.plus.notification.remove(owner: owner)
    }
    
    public func removeAll() {
        AntBus.plus.notification.removeAll()
    }
}
