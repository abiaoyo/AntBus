import Foundation

public final class AntBusData {
    public typealias DataHandler = () -> Any?
    
    public static let shared = AntBusData()
    
    // <key,owner>
    private static var koContainer = SafeMapTable<NSString, AnyObject>.strongToWeak()
    
    // <owner,[<key,handler>]>
    private static var ohContainer = WeakMapTable<AnyObject, SafeMapTable<NSString, AnyObject>>.init()
    
    private func clearOwner(_ key: String) {
        guard let owner = AntBusData.koContainer.object(forKey: key as NSString) else {
            return
        }
        AntBusData.ohContainer.value(forKey: owner)?.removeObject(forKey: key as NSString?)
    }
    
    private func handler(forKey key: String) -> DataHandler? {
        guard let owner = AntBusData.koContainer.object(forKey: key as NSString) else {
            return nil
        }
        return AntBusData.ohContainer.value(forKey: owner)?.object(forKey: key as NSString) as? DataHandler
    }
    
}

public extension AntBusData {
    func register(_ key: String, owner: AnyObject, handler: @escaping DataHandler) {

        AntBus.log.handler?(.data, "AntBus.plus.data.register: key:\(key) \t owner:\(owner) \t handler:\(String(describing: handler))")
        
        clearOwner(key)
        
        AntBusData.koContainer.setObject(owner, forKey: key as NSString)
        
        let khMap = AntBusData.ohContainer.value(forKey: owner) ?? SafeMapTable<NSString, AnyObject>.strongToStrong()

        khMap.setObject(handler as AnyObject, forKey: key as NSString)
        
        AntBusData.ohContainer.setValue(khMap, forKey: owner)
        
        AntBusDeallocHook.shared.install(for: owner, propertyKey: "AntBusData", handlerKey: key) { _ in
            AntBusData.koContainer.removeObject(forKey: key as NSString)
        }
    }
    
    func canCall(_ key: String) -> Bool {
        return handler(forKey: key) != nil
    }
    
    func call(_ key: String) -> Any? {
        let handler = handler(forKey: key)
        
        AntBus.log.handler?(.data, "AntBus.plus.data.call: key:\(key) \t handler:\(String(describing: handler))")
        
        return handler?()
    }
    
    func remove(_ key: String) {

        AntBus.log.handler?(.data, "AntBus.plus.data.remove: key:\(key)")
        
        clearOwner(key)
    }
    
    func removeAll() {
        
        AntBus.log.handler?(.data, "AntBus.plus.data.removeAll")
        
        AntBusData.koContainer.removeAllObjects()
        AntBusData.ohContainer.removeAll()
    }
}
