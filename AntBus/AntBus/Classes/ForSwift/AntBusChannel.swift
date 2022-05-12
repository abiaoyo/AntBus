import Foundation

// Single
struct AntBusCSC {
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

// Multi
struct AntBusCMC {
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

public struct ABC_Single<T: Any> {
    private func anyObjectFromResponder(_ responder: Any) -> AnyObject? {
        return responder as AnyObject?
    }

    // ------------------
    public func register(_ responder: T) {
        guard let responder = anyObjectFromResponder(responder) else {
            return
        }
        let name = DynamicAliasUtil.getAliasName(T.self)
        AntBusCSC.register(name, responder)
    }

    public func responder() -> T? {
        let name = DynamicAliasUtil.getAliasName(T.self)
        return AntBusCSC.responder(name) as? T
    }

    public func remove() {
        let name = DynamicAliasUtil.getAliasName(T.self)
        AntBusCSC.remove(name)
    }
}

public struct ABC_Multi<T: Any> {
    private func anyObjectFromResponder(_ responder: Any) -> AnyObject? {
        return responder as AnyObject?
    }

    // ------------------
    public func register(_ responder: T, forKey key: String) {
        guard let responder = anyObjectFromResponder(responder) else {
            return
        }
        let aliasName = DynamicAliasUtil.getAliasName(T.self)
        AntBusCMC.register(aliasName, key, responder)
    }

    public func register(_ responders: [T], forKey key: String) {
        responders.forEach { responder in
            register(responder, forKey: key)
        }
    }

    public func register(_ responder: T, forKeys keys: [String]) {
        keys.forEach { key in
            register(responder, forKey: key)
        }
    }

    // ------------------
    public func responders(_ key: String) -> [T]? {
        let name = DynamicAliasUtil.getAliasName(T.self)
        return AntBusCMC.responders(name, key)?.compactMap { $0 as? T }
    }

    public func responders() -> [T]? {
        let name = DynamicAliasUtil.getAliasName(T.self)
        return AntBusCMC.responders(name)?.compactMap { $0 as? T }
    }

    // ------------------
    public func remove(_ responder: T, forKey key: String) {
        guard let responder = anyObjectFromResponder(responder) else {
            return
        }
        let name = DynamicAliasUtil.getAliasName(T.self)
        AntBusCMC.remove(name, key, responder)
    }

    public func remove(_ responder: T, forKeys keys: [String]) {
        keys.forEach { key in
            remove(responder, forKey: key)
        }
    }

    public func remove(_ responders: [T], forKey key: String) {
        responders.forEach { responder in
            remove(responder, forKey: key)
        }
    }

    public func remove(_ key: String) {
        let name = DynamicAliasUtil.getAliasName(T.self)
        AntBusCMC.remove(name, key)
    }

    public func remove(_ keys: [String]) {
        let name = DynamicAliasUtil.getAliasName(T.self)
        keys.forEach { key in
            AntBusCMC.remove(name, key)
        }
    }

    public func remove() {
        let name = DynamicAliasUtil.getAliasName(T.self)
        AntBusCMC.remove(name)
    }
}
