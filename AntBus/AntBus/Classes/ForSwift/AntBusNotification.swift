import Foundation

// MARK: - AntBusNotification

public final class AntBusNotification {
    public typealias NotificationHandler = (_ data: Any?) -> Void
    
    public static let shared = AntBusNotification()
    
    // <key,owners>
    private static var koContainer = SafeDictionary<String, SafeHashTable<AnyObject>>.init()
    // <owner,[<key,handler>]>
    private static var ohContainer = WeakMapTable<AnyObject, SafeMapTable<NSString, AnyObject>>.init()
        
    public func register(_ key: String, owner: AnyObject, handler: @escaping NotificationHandler) {
        
        AntBus.log.handler?(.notification, "AntBus.plus.notification.register: key:\(key) \t owner:\(owner) \t handler:\(String(describing: handler))")
        
        let oTable = AntBusNotification.koContainer[key] ?? SafeHashTable<AnyObject>.weakObjects()
        oTable.add(owner)
        
        AntBusNotification.koContainer[key] = oTable
        
        let khMap = AntBusNotification.ohContainer.value(forKey: owner) ?? SafeMapTable<NSString, AnyObject>.strongToStrong()
        khMap.setObject(handler as AnyObject, forKey: key as NSString)
        
        AntBusNotification.ohContainer.setValue(khMap, forKey: owner)
        
        AntBusDeallocHook.shared.install(for: owner, propertyKey: "AntBusNotification", handlerKey: key) { hkeys in
            for hkey in hkeys {
                if AntBusNotification.koContainer[hkey]?.allObjects.count == 0 {
                    AntBusNotification.koContainer.removeValue(forKey: hkey)
                }
            }
        }
    }
    
    public func post(_ key: String, data: Any? = nil) {

        AntBus.log.handler?(.notification, "AntBus.plus.notification.post: key:\(key) \t data:\(String(describing: data))")
        
        guard let oTable = AntBusNotification.koContainer[key] else {
            return
        }
        oTable.allObjects.forEach { owner in
            (AntBusNotification.ohContainer.value(forKey: owner)?.object(forKey: key as NSString) as? NotificationHandler)?(data)
        }
    }
    
    public func remove(_ key: String, owner: AnyObject? = nil) {

        AntBus.log.handler?(.notification, "AntBus.plus.notification.remove: key:\(key) \t owner:\(String(describing: owner))")
        
        if let o = owner {
            AntBusNotification.koContainer[key]?.remove(o)
            AntBusNotification.ohContainer.value(forKey: o)?.removeObject(forKey: key as NSString?)
        } else {
            guard let owners = AntBusNotification.koContainer[key] else {
                return
            }
            owners.allObjects.forEach { owner in
                AntBusNotification.ohContainer.value(forKey: owner)?.removeObject(forKey: key as NSString?)
            }
            owners.removeAllObjects()
        }
    }
    
    public func remove(owner: AnyObject) {

        AntBus.log.handler?(.notification, "AntBus.plus.notification.remove: owner:\(String(describing: owner))")
        AntBusNotification.ohContainer.remove(forKey: owner)
    }
    
    public func removeAll() {

        AntBus.log.handler?(.notification, "AntBus.plus.notification.removeAll")
        AntBusNotification.koContainer.removeAll()
        AntBusNotification.ohContainer.removeAll()
    }
}
