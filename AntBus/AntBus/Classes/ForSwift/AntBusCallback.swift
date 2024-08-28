import Foundation

public struct AntBusCallback {
    
    public typealias ResponseHandler = (_ data: Any?) -> Void
    public typealias CallbackHandler = (_ data: Any?, _ responseHandler: @escaping ResponseHandler) -> Void
    
    public static let shared = AntBusCallback()
    
    // <key,owner> key owner map
    private static var koContainer = SafeMapTable<NSString, AnyObject>.strongToWeak()
    
    // <owner,[<key,handler>]> owner handler map
    private static var ohContainer = WeakMapTable<AnyObject, SafeMapTable<NSString, AnyObject>>.init()
    
    private func clearOwner(forKey key: String) {
        guard let owner = AntBusCallback.koContainer.object(forKey: key as NSString) else {
            return
        }
        AntBusCallback.ohContainer.value(forKey: owner)?.removeObject(forKey: key as NSString?)
    }
    
}

public extension AntBusCallback{
    
    func register(_ key: String, owner: AnyObject, handler: @escaping CallbackHandler) {

        AntBus.log.handler?(.callback, "AntBus.plus.callback.register: key:\(key) \t owner:\(owner) \t handler:\(String(describing: handler))")
        
        if let oldOwner = AntBusCallback.koContainer.object(forKey: key as NSString), oldOwner !== owner {
            if let oldOmhMap = AntBusCallback.ohContainer.value(forKey: owner) {
                oldOmhMap.removeObject(forKey: key as NSString)
            }
        }
        AntBusCallback.koContainer.setObject(owner, forKey: key as NSString)
        
        let omhMap = AntBusCallback.ohContainer.value(forKey: owner) ?? SafeMapTable<NSString, AnyObject>.strongToStrong()
        omhMap.setObject(handler as AnyObject, forKey: key as NSString)
        
        AntBusCallback.ohContainer.setValue(omhMap, forKey: owner)
        AntBusDeallocHook.shared.install(for: owner, propertyKey: "AntBusCallback", handlerKey: key) { _ in
            AntBusCallback.koContainer.removeObject(forKey: key as NSString)
        }
    }
    
    func call(_ key: String, data: Any?, responseHandler: ResponseHandler? = nil) {

        AntBus.log.handler?(.callback, "AntBus.plus.callback.call: key:\(key) \t data:\(String(describing: data ?? nil)) \t responseHandler:\(String(describing: responseHandler))")
        guard let owner = AntBusCallback.koContainer.object(forKey: key as NSString) else {
            return
        }
        guard let omhMap = AntBusCallback.ohContainer.value(forKey: owner) else {
            return
        }
        guard let handler = omhMap.object(forKey: key as NSString) as? CallbackHandler else {
            return
        }
        handler(data, { data in
            AntBus.log.handler?(.callback, "AntBus.plus.callback.call_responseHandler: key:\(key) \t response.data:\(String(describing: data ?? nil))")
            responseHandler?(data)
        })
    }
    
    func remove(forKey key: String) {
        AntBus.log.handler?(.callback, "AntBus.plus.callback.remove: key:\(key)")
        clearOwner(forKey: key)
    }
    
    func removeAll() {

        AntBus.log.handler?(.callback, "AntBus.plus.callback.removeAll")
        
        AntBusCallback.koContainer.removeAllObjects()
        AntBusCallback.ohContainer.removeAll()
    }
}
