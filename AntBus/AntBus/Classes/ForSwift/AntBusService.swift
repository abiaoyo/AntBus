import Foundation

// Single
struct AntBusSSC {
    static var container = [String: Any]()
    
    static func register(_ key: String, _ responder: Any) {
        let log = "AntBusService.single.register:  \(key) \t \(responder)"
        AntBus.serviceLog?(log)
        
        container[key] = responder
    }
    
    static func responder(_ key: String) -> Any? {
        let rs = container[key]
        
        let log = "AntBusService.single.responder:  \(key) \t \(String(describing: rs))"
        AntBus.serviceLog?(log)
        
        return rs
    }
    
    static func remove(_ key: String) {
        let log = "AntBusService.single.remove:  \(key)"
        AntBus.serviceLog?(log)
        
        container.removeValue(forKey: key)
    }
    
    static func removeAll() {
        let log = "AntBusService.single.removeAll"
        AntBus.serviceLog?(log)
        
        container.removeAll()
    }
}

// Multi
struct AntBusSMC {
    static var container = [String: [String: [Any]]]()
    
    static func register(_ type: String, _ key: String, _ responder: Any) {
        let log = "AntBusService.multi.register:  \(type) \t \(key) \t \(responder)"
        AntBus.serviceLog?(log)
        if let _ = container[type] {
            if let _ = container[type]![key] {
                container[type]![key]?.append(responder)
            } else {
                container[type]![key] = [responder]
            }
        } else {
            let responders = [responder]
            let keyContainers = [key: responders]
            container.updateValue(keyContainers, forKey: type)
        }
    }
    
    static func register(_ type: String, _ keys: [String], _ responder: Any) {
        for key in keys {
            register(type, key, responder)
        }
    }
    
    static func register(_ type: String, _ key: String, _ responders: [Any]) {
        for responder in responders {
            register(type, key, responder)
        }
    }
    
    static func responders(_ type: String, _ key: String) -> [Any]? {
        let rs = container[type]?[key]
        
        let log = "AntBusService.multi.responders:  \(type) \t \(key) \t \(String(describing: rs))"
        AntBus.serviceLog?(log)
        
        return rs
    }
    
    static func responders(_ type: String) -> [Any]? {
        let typeContainer = container[type]
        let results = typeContainer?.flatMap { $0.value }
        let uniqueResults = NSMutableSet(array: results ?? [])
        let rs = uniqueResults.allObjects
        
        let log = "AntBusService.multi.responders:  \(type) \t \(String(describing: rs))"
        AntBus.serviceLog?(log)
        
        return rs
    }
    
    static func remove(_ type: String, _ key: String, where shouldBeRemoved: (Any) -> Bool) {
        let log = "AntBusService.multi.remove:  \(type) \t \(key) \t where: .."
        AntBus.serviceLog?(log)
        
        container[type]?[key]?.removeAll(where: { r in
            shouldBeRemoved(r)
        })
    }
    
    static func remove(_ type: String, _ key: String) {
        let log = "AntBusService.multi.remove:  \(type) \t \(key)"
        AntBus.serviceLog?(log)
        
        container[type]?.removeValue(forKey: key)
    }
    
    static func remove(_ type: String) {
        let log = "AntBusService.multi.remove:  \(type)"
        AntBus.serviceLog?(log)
        
        container.removeValue(forKey: type)
    }
}

public struct ABS_Single<T: Any> {
    public func register(_ responder: T) {
        let name = AliasUtil.aliasForAny(T.self)
        AntBusSSC.register(name, responder)
    }
    
    public func responder() -> T? {
        let name = AliasUtil.aliasForAny(T.self)
        return AntBusSSC.responder(name) as? T
    }

    public func remove() {
        let name = AliasUtil.aliasForAny(T.self)
        AntBusSSC.remove(name)
    }
}

public struct ABS_Multi<T: Any> {
    public func register(_ responder: T, forKey key: String) {
        let name = AliasUtil.aliasForAny(T.self)
        AntBusSMC.register(name, key, responder)
    }
    
    public func register(_ responder: T, forKeys keys: [String]) {
        let name = AliasUtil.aliasForAny(T.self)
        AntBusSMC.register(name, keys, responder)
    }
    
    public func register(_ responders: [T], forKey key: String) {
        let name = AliasUtil.aliasForAny(T.self)
        AntBusSMC.register(name, key, responders)
    }
    
    public func responders(forKey key: String) -> [T]? {
        let name = AliasUtil.aliasForAny(T.self)
        return AntBusSMC.responders(name, key)?.compactMap { $0 as? T }
    }
    
    public func responders() -> [T]? {
        let name = AliasUtil.aliasForAny(T.self)
        return AntBusSMC.responders(name)?.compactMap { $0 as? T }
    }
    
    public func remove(forKey key: String, where shouldBeRemoved: (T) -> Bool) {
        let name = AliasUtil.aliasForAny(T.self)
        AntBusSMC.remove(name, key) { resp in
            shouldBeRemoved(resp as! T)
        }
    }
    
    public func remove(forKey key: String) {
        let name = AliasUtil.aliasForAny(T.self)
        AntBusSMC.remove(name, key)
    }
    
    public func remove(forKeys keys: [String]) {
        let name = AliasUtil.aliasForAny(T.self)
        keys.forEach { key in
            AntBusSMC.remove(name, key)
        }
    }
    
    public func remove() {
        let name = AliasUtil.aliasForAny(T.self)
        AntBusSMC.remove(name)
    }
}
