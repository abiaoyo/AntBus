import Foundation

// single
final private class AntBusChannelSC{
    // <Key,Value>
    static let krMap = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    
    static func register(_ key:String, _ responder:AnyObject){
        AntBusDealloc.installDeallocHookForSingleChannel(to: responder, hkey: key) { hkeys in
            for hkey in hkeys {
                if krMap.object(forKey: hkey as NSString) == nil {
                    krMap.removeObject(forKey: hkey as NSString)
                }
            }
        }
        krMap.setObject(responder, forKey: key as NSString)
    }
    static func responder(_ key:String) -> AnyObject?{
        return krMap.object(forKey: key as NSString)
    }
    static func remove(_ key:String){
        krMap.removeObject(forKey: key as NSString)
    }
    static func removeAll(){
        krMap.removeAllObjects()
    }
}

final public class AntBusChannelSingle<R:AnyObject> {
    public func register(_ responder:R) -> Void{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusChannelSC.register(aliasName, responder)
    }
    public func responder() -> R?{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return AntBusChannelSC.responder(aliasName) as? R
    }
    public func remove() -> Void{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusChannelSC.remove(aliasName)
    }
}

// multi
final private class AntBusChannelMC{
    
    // <key,<alias,[Response]>>
    static var container = Dictionary<String,Dictionary<String,AntBusWeakSet<AnyObject>>>.init()
    
    static func register(_ aliasName:String, _ key:String, _ responder:AnyObject){
        var arMap = container[key]
        
        if arMap == nil {
            arMap = Dictionary<String,AntBusWeakSet<AnyObject>>.init()
            container[key] = arMap
        }
        var arMapSet = arMap![aliasName]
        if arMapSet == nil {
            arMapSet = AntBusWeakSet<AnyObject>.init()
            arMap![aliasName] = arMapSet
        }
        arMapSet!.insert(responder, hKey: key, deallocHandler: { hKeys in
            for hKey in hKeys {
                if let arMapSet = container[hKey]?[aliasName] {
                    if arMapSet.count() == 0 {
                        container[hKey]?.removeValue(forKey: aliasName)
                    }
                }else{
                    container[hKey]?.removeValue(forKey: aliasName)
                }
                if let arMap = container[hKey] {
                    if arMap.count == 0 {
                        container.removeValue(forKey: hKey)
                    }
                }else{
                    container.removeValue(forKey: hKey)
                }
            }
        })
    }
    
    static func responders(_ aliasName:String, _ key:String) -> [AnyObject]? {
        let arMap = container[key]
        let arMapSet = arMap?[aliasName]
        return arMapSet?.allValues()
    }
    
    static func allResponses(_ aliasName:String) -> [AnyObject]? {
//        let allValues = container.values
//        for let arMap in allValues {
//            arMap.keys
//        }
        return nil
    }
    
    static func remove(_ aliasName:String, _ keys:[String],_ responder:AnyObject) {
        for key in keys {
            self.remove(aliasName, key, responder)
        }
    }
    
    static func remove(_ aliasName:String, _ keys:[String]) -> Void {
        for key in keys {
            self.remove(aliasName, key)
        }
    }
    
    static func remove(_ aliasName:String, _ key:String,_ responder:AnyObject){
        let arMap = container[key]
        let arMapSet = arMap?[aliasName]
        arMapSet?.remove(responder)
    }
    
    static func remove(_ aliasName:String, _ key:String){
        container[key]?.removeValue(forKey: aliasName)
    }
    
    static func remove(_ aliasName:String) {
        container.removeValue(forKey: aliasName)
    }
}

final public class AntBusChannelMulti<R:AnyObject> {
    
    public func register(_ key:String, _ responder:R) -> Void{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusChannelMC.register(aliasName, key, responder)
    }
    
    public func register(_ keys:[String], _ responder:R) -> Void{
        for key in keys {
            register(key, responder)
        }
    }
    
    public func register(_ key:String, _ responders:[R]) -> Void{
        for responder in responders {
            register(key, responder)
        }
    }

    public func responders(_ key:String) -> [R]? {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return AntBusChannelMC.responders(aliasName, key)?.compactMap({ $0 as? R})
    }
    
    public func responders() -> [R]? {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return AntBusChannelMC.allResponses(aliasName)?.compactMap({ $0 as? R })
    }
    
    public func remove(_ keys:[String],_ responder:R) -> Void {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusChannelMC.remove(aliasName, keys, responder)
    }

    public func remove(_ keys:[String]) -> Void {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusChannelMC.remove(aliasName, keys)
    }

    public func remove(_ key:String,_ responder:R) -> Void{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusChannelMC.remove(aliasName, key, responder)
    }

    public func remove(_ key:String) -> Void{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusChannelMC.remove(aliasName, key)
    }

    public func remove() -> Void {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusChannelMC.remove(aliasName)
    }
}

public struct AntBusChannelI<T:AnyObject> {
    public static var single:AntBusChannelSingle<T> {
        get {
            return AntBusChannelSingle<T>.init()
        }
    }
    public static var multiple:AntBusChannelMulti<T> {
        get {
            return AntBusChannelMulti<T>.init()
        }
    }
}

public struct AntBusChannel{
    public static func singleI<I:AnyObject>(_ iType:I.Type) -> AntBusChannelSingle<I> {
        return AntBusChannelSingle<I>.init()
    }
    public static func multipleI<I:AnyObject>(_ iType:I.Type) -> AntBusChannelMulti<I> {
        return AntBusChannelMulti<I>.init()
    }
}
