import Foundation

//Single
class AntBusCSC {
    static let container = NSMapTable<NSString,AnyObject>.strongToWeakObjects();
    
    static func register(_ key:String, _ responder:AnyObject) {
        if AntBus.printChannel {
            print("AntBusChannel.single.register:  \(key) \t \(responder)")
        }
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
    
    static func responder(_ key:String) -> AnyObject? {
        let rs = container.object(forKey: key as NSString)
        if AntBus.printChannel {
            print("AntBusChannel.single.responder:  \(key) \t \(String(describing: rs))")
        }
        return rs
    }
    
    static func remove(_ key:String) {
        if AntBus.printChannel {
            print("AntBusChannel.single.remove:  \(key)")
        }
        container.removeObject(forKey: key as NSString)
    }
    
    static func removeAll() {
        if AntBus.printChannel {
            print("AntBusChannel.single.removeAll")
        }
        container.removeAllObjects()
    }
}


final public class AntBusCS<R: AnyObject> {
    init() {}
    public func register(_ responder:R){
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCSC.register(aliasName, responder)
    }
    public func responder() -> R?{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return AntBusCSC.responder(aliasName) as? R
    }
    public func remove() {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCSC.remove(aliasName)
    }
}

// Multi
class AntBusCMC {
    static let container = NSMutableDictionary.init()
    
    static func register(_ type:String, _ key:String, _ responder:AnyObject) {
        if AntBus.printChannel {
            print("AntBusChannel.multi.register:  \(type) \t \(key) \t \(responder)")
        }
        
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
        
        AntBusDeallocHook.shared.installDeallocHook(for: responder, propertyKey: "AntBusCMC", handlerKey: key) { hkeys in
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
        let rs = ((container[type] as? NSMutableDictionary)?[key] as? NSHashTable<AnyObject>)?.allObjects
        if AntBus.printChannel {
            print("AntBusChannel.multi.responders:  \(type) \t \(key) \t \(String(describing: rs))")
        }
        return rs
    }
    
    static func responders(_ type:String) -> [AnyObject]? {
        var rs:[AnyObject]? = nil
        if let typeContainer = container[type] as? NSMutableDictionary {
            let mset = NSMutableSet.init()
            typeContainer.allKeys.forEach { key in
                if let keyContainer = typeContainer[key] as? NSHashTable<AnyObject> {
                    mset.addObjects(from: keyContainer.allObjects)
                }
            }
            rs = mset.allObjects.compactMap({ $0 as AnyObject})
        }
        if AntBus.printChannel {
            print("AntBusChannel.multi.responders:  \(type) \t \(String(describing: rs))")
        }
        return rs
    }
    
    static func remove(_ type:String, _ key:String,_ responder:AnyObject) {
        if AntBus.printChannel {
            print("AntBusChannel.multi.remove:  \(type) \t \(key) \t \(responder)")
        }
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
        if AntBus.printChannel {
            print("AntBusChannel.multi.remove:  \(type) \t \(key)")
        }
        (container[type] as? NSMutableDictionary)?.removeObject(forKey: key)
    }
    
    static func remove(_ type:String, _ keys:[String]) {
        keys.forEach { key in
            remove(type, key)
        }
    }
    
    static func remove(_ type:String) {
        if AntBus.printChannel {
            print("AntBusChannel.multi.remove:  \(type)")
        }
        container.removeObject(forKey: type)
    }
}

final public class AntBusCM<R: AnyObject> {
    init() {}
    public func register(_ key:String, _ responder:R) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.register(aliasName, key, responder)
    }
    public func register(_ key:String, _ responders:[R]) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.register(aliasName, key, responders)
    }
    public func register(_ keys:[String], _ responder:R) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.register(aliasName, keys, responder)
    }
    public func responders(_ key:String) -> [R]? {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return AntBusCMC.responders(aliasName, key)?.compactMap({ $0 as? R })
    }
    
    public func responders() -> [R]? {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return AntBusCMC.responders(aliasName)?.compactMap({ $0 as? R })
    }
    
    public func remove(_ key:String,_ responder:R) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.remove(aliasName, key, responder)
    }
    
    public func remove(_ keys:[String],_ responder:R) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.remove(aliasName, keys, responder)
    }
    
    public func remove(_ key:String,_ responders:[R]) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.remove(aliasName, key, responders)
    }
    
    public func remove(_ key:String) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.remove(aliasName, key)
    }
    
    public func remove(_ keys:[String]) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.remove(aliasName, keys)
    }
    
    public func removeAll() {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusCMC.remove(aliasName)
    }
}

public struct AntBusChannel{
    public static func singleI<T:AnyObject>(_ type:T.Type) -> AntBusCS<T> {
        return AntBusCS<T>.init()
    }
    public static func multiI<T:AnyObject>(_ type:T.Type) -> AntBusCM<T> {
        return AntBusCM<T>.init()
    }
}

public struct AntBusChannelI<T:AnyObject>{
    public static var single:AntBusCS<T> {
        get {
            return AntBusCS<T>.init()
        }
    }
    public static var multi:AntBusCM<T> {
        get {
            return AntBusCM<T>.init()
        }
    }
}
