import Foundation

// Single
class AntBusCSC {
    static let container = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    
    static func register(_ key: String, _ responder: AnyObject) {
        let log = "AntBusChannel.single.register:  \(key) \t \(responder)"
        AntBus.channelLog?(log)
        
        container.setObject(responder, forKey: key as NSString)
        AntBusDeallocHook.shared.installDeallocHook(for: responder, propertyKey: "AntBusCSC", handlerKey: key) { hkeys in
            for hkey in hkeys {
                guard let _ = container.object(forKey: hkey as NSString) else {
                    container.removeObject(forKey: hkey as NSString)
                    break
                }
            }
        }
    }
    
    static func responder(_ key: String) -> AnyObject? {
        let rs = container.object(forKey: key as NSString)
        
        let log = "AntBusChannel.single.responder:  \(key) \t \(String(describing: rs))"
        AntBus.channelLog?(log)
        
        return rs
    }
    
    static func remove(_ key: String) {
        let log = "AntBusChannel.single.remove:  \(key)"
        AntBus.channelLog?(log)
        
        container.removeObject(forKey: key as NSString)
    }
    
    static func removeAll() {
        let log = "AntBusChannel.single.removeAll"
        AntBus.channelLog?(log)
        
        container.removeAllObjects()
    }
}

public final class AntBusCS<R: AnyObject> {
    init() {}
    public func register(_ responder: R) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCSC.register(aliasName, responder)
    }

    public func responder() -> R? {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return AntBusCSC.responder(aliasName) as? R
    }

    public func remove() {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCSC.remove(aliasName)
    }
}

// Multi
enum AntBusCMC {
    static let container = NSMutableDictionary()
    
    static func register(_ type: String, _ key: String, _ responder: AnyObject) {
        let log = "AntBusChannel.multi.register:  \(type) \t \(key) \t \(responder)"
        AntBus.channelLog?(log)
        
        let typeContainer = (container[type] as? NSMutableDictionary) ?? NSMutableDictionary()
        container[type] = typeContainer
        
        let keyContainer = (typeContainer[key] as? NSHashTable<AnyObject>) ?? NSHashTable<AnyObject>.weakObjects()
        keyContainer.add(responder)
        
        typeContainer[key] = keyContainer
        
        AntBusDeallocHook.shared.installDeallocHook(for: responder, propertyKey: "AntBusCMC", handlerKey: key) { hkeys in
            if let typeContainer = container[type] as? NSMutableDictionary {
                for hkey in hkeys {
                    if let keyContainer = typeContainer[hkey] as? NSHashTable<AnyObject> {
                        if keyContainer.count == 0 {
                            typeContainer.removeObject(forKey: hkey)
                        }
                    } else {
                        typeContainer.removeObject(forKey: hkey)
                    }
                }
                if typeContainer.allValues.count == 0 {
                    container.removeObject(forKey: type)
                }
            }
        }
    }

    static func register(_ type: String, _ key: String, _ responders: [AnyObject]) {
        responders.forEach { resp in
            register(type, key, resp)
        }
    }

    static func register(_ type: String, _ keys: [String], _ responder: AnyObject) {
        keys.forEach { key in
            register(type, key, responder)
        }
    }
    
    static func responders(_ type: String, _ key: String) -> [AnyObject]? {
        let rs = ((container[type] as? NSMutableDictionary)?[key] as? NSHashTable<AnyObject>)?.allObjects
        
        let log = "AntBusChannel.multi.responders:  \(type) \t \(key) \t \(String(describing: rs))"
        AntBus.channelLog?(log)
        
        return rs
    }
    
    static func responders(_ type: String) -> [AnyObject]? {
        var rs: [AnyObject]?
        
        if let typeContainer = container[type] as? NSMutableDictionary {
            let mset = NSMutableSet()
            typeContainer.allKeys.forEach { key in
                if let keyContainer = typeContainer[key] as? NSHashTable<AnyObject> {
                    mset.addObjects(from: keyContainer.allObjects)
                }
            }
            rs = mset.allObjects.compactMap { $0 as AnyObject }
        }
        
        let log = "AntBusChannel.multi.responders:  \(type) \t \(String(describing: rs))"
        AntBus.channelLog?(log)
        
        return rs
    }
    
    static func remove(_ type: String, _ key: String, _ responder: AnyObject) {
        let log = "AntBusChannel.multi.remove:  \(type) \t \(key) \t \(responder)"
        AntBus.channelLog?(log)
        
        ((container[type] as? NSMutableDictionary)?[key] as? NSHashTable<AnyObject>)?.remove(responder)
    }
    
    static func remove(_ type: String, _ keys: [String], _ responder: AnyObject) {
        keys.forEach { key in
            remove(type, key, responder)
        }
    }
    
    static func remove(_ type: String, _ key: String, _ responders: [AnyObject]) {
        responders.forEach { resp in
            remove(type, key, resp)
        }
    }
    
    static func remove(_ type: String, _ key: String) {
        let log = "AntBusChannel.multi.remove:  \(type) \t \(key)"
        AntBus.channelLog?(log)
        
        (container[type] as? NSMutableDictionary)?.removeObject(forKey: key)
    }
    
    static func remove(_ type: String, _ keys: [String]) {
        keys.forEach { key in
            remove(type, key)
        }
    }
    
    static func remove(_ type: String) {
        let log = "AntBusChannel.multi.remove:  \(type)"
        AntBus.channelLog?(log)
        
        container.removeObject(forKey: type)
    }
}

public final class AntBusCM<R: AnyObject> {
    init() {}
    public func register(_ key: String, _ responder: R) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.register(aliasName, key, responder)
    }

    public func register(_ key: String, _ responders: [R]) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.register(aliasName, key, responders)
    }

    public func register(_ keys: [String], _ responder: R) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.register(aliasName, keys, responder)
    }

    public func responders(_ key: String) -> [R]? {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return AntBusCMC.responders(aliasName, key)?.compactMap { $0 as? R }
    }
    
    public func responders() -> [R]? {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return AntBusCMC.responders(aliasName)?.compactMap { $0 as? R }
    }
    
    public func remove(_ key: String, _ responder: R) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.remove(aliasName, key, responder)
    }
    
    public func remove(_ keys: [String], _ responder: R) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.remove(aliasName, keys, responder)
    }
    
    public func remove(_ key: String, _ responders: [R]) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.remove(aliasName, key, responders)
    }
    
    public func remove(_ key: String) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.remove(aliasName, key)
    }
    
    public func remove(_ keys: [String]) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.remove(aliasName, keys)
    }
    
    public func removeAll() {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.remove(aliasName)
    }
}

public enum AntBusChannel {
    public static func singleI<T: AnyObject>(_ type: T.Type) -> AntBusCS<T> { AntBusCS<T>.init() }
    public static func multiI<T: AnyObject>(_ type: T.Type) -> AntBusCM<T> { AntBusCM<T>.init() }
}

public struct AntBusChannelI<T: AnyObject> {
    public static var single: AntBusCS<T> { AntBusCS<T>.init() }
    public static var multi: AntBusCM<T> { AntBusCM<T>.init() }
}
