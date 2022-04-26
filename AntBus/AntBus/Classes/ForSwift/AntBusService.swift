import Foundation

// Single
class AntBusSSC {
    static var container = Dictionary<String,Any>.init()
    static func register(_ key:String, _ responder:Any) {
        let log = "AntBusService.single.register:  \(key) \t \(responder)"
        AntBus.serviceLog?(log)
        
        container[key] = responder
    }
    
    static func responder(_ key:String) -> Any? {
        let rs = container[key]
        let log = "AntBusService.single.responder:  \(key) \t \(String(describing: rs))"
        AntBus.serviceLog?(log)
        return rs
    }
    
    static func remove(_ key:String) {
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


final public class AntBusSS<R: Any> {
    init() {}
    public func register(_ responder:R){
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusSSC.register(aliasName, responder)
    }
    public func responder() -> R?{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return AntBusSSC.responder(aliasName) as? R
    }
    public func remove() {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusSSC.remove(aliasName)
    }
}

// Multi
class AntBusSMC{
    /// <aliasName,<key,[responder]>>
    static var container = Dictionary<String,Dictionary<String,Array<Any>>>.init()
    
    static func register(_ type:String, _ key:String, _ responder:Any){
        let log = "AntBusService.multi.register:  \(type) \t \(key) \t \(responder)"
        AntBus.serviceLog?(log)
        
        if let _ = container[type] {
            if let _ = container[type]![key] {
                container[type]![key]?.append(responder)
            }else{
                container[type]![key] = [responder]
            }
        }else{
            let responders = [responder]
            let keyContainers = [key:responders]
            container.updateValue(keyContainers, forKey: type)
        }
    }
    
    static func register(_ type:String, _ keys:[String], _ responder:Any){
        for key in keys {
            register(type, key, responder)
        }
    }
    
    static func register(_ type:String, _ key:String, _ responders:[Any]){
        for responder in responders {
            register(type, key, responder)
        }
    }
    
    static func responders(_ type:String, _ key:String) -> [Any]? {
        let rs = container[type]?[key]
        
        let log = "AntBusService.multi.responders:  \(type) \t \(key) \t \(String(describing: rs))"
        AntBus.serviceLog?(log)
        
        return rs
    }
    
    static func responders(_ type:String)  -> [Any]? {
        let typeContainer = container[type]
        let results = typeContainer?.flatMap({ $0.value })
        let uniqueResults = NSMutableSet.init(array: results ?? [])
        let rs = uniqueResults.allObjects
        
        let log = "AntBusService.multi.responders:  \(type) \t \(String(describing: rs))"
        AntBus.serviceLog?(log)
        
        return rs
    }
    
    static func remove(_ type:String, _ key:String, where shouldBeRemoved: (Any) -> Bool) {
        let log = "AntBusService.multi.remove:  \(type) \t \(key) \t where: .."
        AntBus.serviceLog?(log)
        
        container[type]?[key]?.removeAll(where: { r in
            return shouldBeRemoved(r)
        })
    }
    
    static func remove(_ type:String, _ key:String){
        let log = "AntBusService.multi.remove:  \(type) \t \(key)"
        AntBus.serviceLog?(log)
        container[type]?.removeValue(forKey: key)
    }
    
    static func remove(_ type:String) {
        let log = "AntBusService.multi.remove:  \(type)"
        AntBus.serviceLog?(log)
        container.removeValue(forKey: type)
    }
    
}


final public class AntBusSM<R:Any> {

    public func register(_ key:String, _ responder:R){
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusSMC.register(aliasName, key, responder)
    }
    
    public func register(_ keys:[String], _ responder:R){
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusSMC.register(aliasName, keys, responder)
    }
    
    public func register(_ key:String, _ responders:[R]){
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusSMC.register(aliasName, key, responders)
    }
    
    public func responders(_ key:String) -> [R]? {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return AntBusSMC.responders(aliasName, key)?.compactMap({ $0 as? R })
    }
    
    public func responders()  -> [R]? {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return AntBusSMC.responders(aliasName)?.compactMap({ $0 as? R })
    }
    
    public func remove(_ key:String, where shouldBeRemoved: (Any) -> Bool) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusSMC.remove(aliasName, key, where: shouldBeRemoved)
    }
    
    public func remove(_ key:String){
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusSMC.remove(aliasName, key)
    }
    
    public func remove() {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntBusSMC.remove(aliasName)
    }
    
}

//MARK: - AntBusService
public struct AntBusServiceI<T:Any> {
    public static var single:AntBusSS<T>{
        return AntBusSS<T>.init()
    }
    public static var multi:AntBusSM<T>{
        return AntBusSM<T>.init()
    }
}

public struct AntBusService{
    public static func singleI<T:Any>(_ type:T.Type) -> AntBusSS<T> {
        return AntBusSS<T>.init()
    }
    public static func multi<T:Any>(_ type:T.Type) -> AntBusSM<T> {
        return AntBusSM<T>.init()
    }
}
