import Foundation

// Single
private class _AntBusSSC {
    static var container = Dictionary<String,Any>.init()
    static func register(_ key:String, _ responder:Any) {
        container[key] = responder
    }
    
    static func responder(_ key:String) -> Any? {
        return container[key]
    }
    
    static func remove(_ key:String) {
        container.removeValue(forKey: key)
    }
    
    static func removeAll() {
        container.removeAll()
    }
}


final public class _AntBusSS<R: Any> {
    init() {}
    public func register(_ responder:R){
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusSSC.register(aliasName, responder)
    }
    public func responder() -> R?{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return _AntBusSSC.responder(aliasName) as? R
    }
    public func remove() {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusSSC.remove(aliasName)
    }
}

// Multi
final public class AntBusSMResp{
    public private(set) var responder:Any!
    public init(_ responder:Any) {
        self.responder = responder
    }
}


private class _AntBusSMC{
    /// <aliasName,<key,[responder]>>
    static var container = Dictionary<String,Dictionary<String,Array<AntBusSMResp>>>.init()
    
    static func register(_ type:String, _ key:String, _ responder:AntBusSMResp){
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
    
    static func register(_ type:String, _ keys:[String], _ responder:AntBusSMResp){
        for key in keys {
            register(type, key, responder)
        }
    }
    
    static func register(_ type:String, _ key:String, _ responders:[AntBusSMResp]){
        for responder in responders {
            register(type, key, responder)
        }
    }
    
    static func responders(_ type:String, _ key:String) -> [AntBusSMResp]? {
        return container[type]?[key]
    }
    
    static func responders(_ type:String)  -> [AntBusSMResp]? {
        let typeContainer = container[type]
        let results = typeContainer?.flatMap({ $0.value })
        let uniqueResults = NSMutableSet.init(array: results ?? [])
        return uniqueResults.allObjects.compactMap({ $0 as? AntBusSMResp})
    }
    
    static func remove(_ type:String, _ key:String, where shouldBeRemoved: (AntBusSMResp) -> Bool) {
        container[type]?[key]?.removeAll(where: { r in
            return shouldBeRemoved(r)
        })
    }
    
    static func remove(_ type:String, _ key:String){
        container[type]?.removeValue(forKey: key)
    }
    
    static func remove(_ type:String) {
        container.removeValue(forKey: type)
    }
    
}


final public class _AntBusSM<R:Any> {

    public func register(_ key:String, _ responder:R){
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusSMC.register(aliasName, key, AntBusSMResp.init(responder))
    }
    
    public func register(_ keys:[String], _ responder:R){
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusSMC.register(aliasName, keys, AntBusSMResp.init(responder))
    }
    
    public func register(_ key:String, _ responders:[R]){
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusSMC.register(aliasName, key, responders.compactMap({ AntBusSMResp.init($0) }))
    }
    
    public func responders(_ key:String) -> [R]? {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return _AntBusSMC.responders(aliasName, key)?.compactMap({ $0.responder as? R })
    }
    
    public func responders()  -> [R]? {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return _AntBusSMC.responders(aliasName)?.compactMap({ $0.responder as? R })
    }
    
    public func remove(_ key:String, where shouldBeRemoved: (AntBusSMResp) -> Bool) {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusSMC.remove(aliasName, key, where: shouldBeRemoved)
    }
    
    public func remove(_ key:String){
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusSMC.remove(aliasName, key)
    }
    
    public func remove() {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        _AntBusSMC.remove(aliasName)
    }
    
}

//MARK: - AntBusService
public struct AntBusServiceI<T:Any> {
    public static var single:_AntBusSS<T>{
        return _AntBusSS<T>.init()
    }
    public static var multi:_AntBusSM<T>{
        return _AntBusSM<T>.init()
    }
}

public struct AntBusService{
    public static func singleI<T:Any>(_ type:T.Type) -> _AntBusSS<T> {
        return _AntBusSS<T>.init()
    }
    public static func multi<T:Any>(_ type:T.Type) -> _AntBusSM<T> {
        return _AntBusSM<T>.init()
    }
}
