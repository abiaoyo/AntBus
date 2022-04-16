import Foundation

//Single
private class _AntBusCSC {
    static var container = NSMapTable<NSString,AnyObject>.strongToWeakObjects();
    static func register(_ key:String, _ responder:AnyObject) {
        container.setObject(responder, forKey: key as NSString)
        AntBusDealloc.installDeallocHook(to: responder, proKey: "_AntBusCSC", hkey: key) { hkeys in
            for hkey in hkeys {
                guard let _ = container.object(forKey: hkey as NSString) else {
                    container.removeObject(forKey: hkey as NSString)
                    break
                }
            }
        }
    }
    
    static func responder(_ key:String) -> AnyObject? {
        return container.object(forKey: key as NSString)
    }
    
    static func remove(_ key:String) {
        container.removeObject(forKey: key as NSString)
    }
    
    static func removeAll() {
        container.removeAllObjects()
    }
}


final public class _AntBusCS<R: AnyObject> {
    init() {}
    public func register(_ responder:R){
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusCSC.register(aliasName, responder)
    }
    public func responder() -> R?{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return _AntBusCSC.responder(aliasName) as? R
    }
    public func remove() {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusCSC.remove(aliasName)
    }
}

// Multi
private class _AntBusCMC {
    static var container = NSMutableDictionary.init()
    
    static func register(_ type:String, _ key:String, _ responder:AnyObject) {
        var typeContainer = container[type] as? NSMutableDictionary
        if typeContainer == nil {
            typeContainer = NSMutableDictionary.init()
            container[type] = typeContainer
        }
        var keyContainer = typeContainer![key] as? NSHashTable<AnyObject>
        if keyContainer == nil {
            keyContainer = NSHashTable<AnyObject>.weakObjects()
            typeContainer![key] = keyContainer
        }
        keyContainer!.add(responder)
        
        AntBusDealloc.installDeallocHook(to: responder, proKey: "_AntBusCMC", hkey: key) { hkeys in
            if let typeContainer = container[type] as? NSMutableDictionary {
                for hkey in hkeys {
                    if let keyContainer = typeContainer[hkey] as? NSHashTable<AnyObject> {
                        if keyContainer.count == 0 {
                            typeContainer.removeObject(forKey: hkey)
                        }
                    }else{
                        typeContainer.removeObject(forKey: hkey)
                    }
                }
                if typeContainer.allValues.count == 0 {
                    container.removeObject(forKey: type)
                }
            }
        }
    }
    static func register(_ type:String, _ key:String, _ responders:[AnyObject]) {
        responders.forEach { resp in
            register(type, key, resp)
        }
    }
    static func register(_ type:String, _ keys:[String], _ responder:AnyObject) {
        keys.forEach { key in
            register(type, key, responder)
        }
    }
    
    static func responders(_ type:String, _ key:String) -> [AnyObject]? {
        return ((container[type] as? NSMutableDictionary)?[key] as? NSHashTable<AnyObject>)?.allObjects
    }
    
    static func responders(_ type:String) -> [AnyObject]? {
        if let typeContainer = container[type] as? NSMutableDictionary {
            let rs = NSMutableSet.init()
            typeContainer.allKeys.forEach { key in
                if let keyContainer = typeContainer[key] as? NSHashTable<AnyObject> {
                    rs.addObjects(from: keyContainer.allObjects)
                }
            }
            return rs.allObjects.compactMap({ $0 as AnyObject})
        }
        return nil
    }
    
    static func remove(_ type:String, _ key:String,_ responder:AnyObject) {
        ((container[type] as? NSMutableDictionary)?[key] as? NSHashTable<AnyObject>)?.remove(responder)
    }
    
    static func remove(_ type:String, _ keys:[String],_ responder:AnyObject) {
        keys.forEach { key in
            remove(type, key, responder)
        }
    }
    
    static func remove(_ type:String, _ key:String,_ responders:[AnyObject]) {
        responders.forEach { resp in
            remove(type, key, resp)
        }
    }
    
    static func remove(_ type:String, _ key:String) {
        (container[type] as? NSMutableDictionary)?.removeObject(forKey: key)
    }
    
    static func remove(_ type:String, _ keys:[String]) {
        keys.forEach { key in
            remove(type, key)
        }
    }
    
    static func remove(_ type:String) {
        container.removeObject(forKey: type)
    }
}

final public class _AntBusCM<R: AnyObject> {
    init() {}
    public func register(_ key:String, _ responder:R) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusCMC.register(aliasName, key, responder)
    }
    public func register(_ key:String, _ responders:[R]) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusCMC.register(aliasName, key, responders)
    }
    public func register(_ keys:[String], _ responder:R) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusCMC.register(aliasName, keys, responder)
    }
    public func responders(_ key:String) -> [R]? {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return _AntBusCMC.responders(aliasName, key)?.compactMap({ $0 as? R })
    }
    
    public func responders() -> [R]? {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return _AntBusCMC.responders(aliasName)?.compactMap({ $0 as? R })
    }
    
    public func remove(_ key:String,_ responder:R) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusCMC.remove(aliasName, key, responder)
    }
    
    public func remove(_ keys:[String],_ responder:R) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusCMC.remove(aliasName, keys, responder)
    }
    
    public func remove(_ key:String,_ responders:[R]) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusCMC.remove(aliasName, key, responders)
    }
    
    public func remove(_ key:String) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusCMC.remove(aliasName, key)
    }
    
    public func remove(_ keys:[String]) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusCMC.remove(aliasName, keys)
    }
    
    public func removeAll() {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusCMC.remove(aliasName)
    }
}

public struct AntBusChannel{
    public static func singleI<T:AnyObject>(_ type:T.Type) -> _AntBusCS<T> {
        return _AntBusCS<T>.init()
    }
    public static func multiI<T:AnyObject>(_ type:T.Type) -> _AntBusCM<T> {
        return _AntBusCM<T>.init()
    }
}

public struct AntBusChannelI<T:AnyObject>{
    public static var single:_AntBusCS<T> {
        get {
            return _AntBusCS<T>.init()
        }
    }
    public static var multi:_AntBusCM<T> {
        get {
            return _AntBusCM<T>.init()
        }
    }
}
