import Foundation


@objcMembers
public class _OCAntBusServiceSS: NSObject {
    public func register(interface:Protocol, responder:AnyObject) {
        let aliasName = DynamicAliasUtil.getAliasNameWithObject(obj: interface)
        _AntBusSSC.register(aliasName, responder)
    }
    public func register(clazz:AnyObject.Type, responder:AnyObject){
        let aliasName = DynamicAliasUtil.getAliasNameWithType(type: clazz)
        _AntBusSSC.register(aliasName, responder)
    }
    public func responder(interface:Protocol) -> AnyObject?{
        let aliasName = DynamicAliasUtil.getAliasNameWithObject(obj: interface)
        return _AntBusSSC.responder(aliasName) as AnyObject?
    }
    public func responder(clazz:AnyObject.Type) -> AnyObject?{
        let aliasName = DynamicAliasUtil.getAliasNameWithType(type: clazz)
        return _AntBusSSC.responder(aliasName) as AnyObject?
    }
    public func remove(interface:Protocol) {
        let aliasName = DynamicAliasUtil.getAliasNameWithObject(obj: interface)
        _AntBusSSC.remove(aliasName)
    }
    public func remove(clazz:AnyObject.Type) {
        let aliasName = DynamicAliasUtil.getAliasNameWithType(type: clazz)
        _AntBusSSC.remove(aliasName)
    }
    public func removeAll() {
        _AntBusSSC.removeAll()
    }
}

@objcMembers
public class _OCAntBusServiceSM: NSObject {
    
    func conformsInterface(interface:Protocol, responder:AnyObject) -> Bool {
        return responder.conforms(to: interface)
    }
    func isKindOfClazz(clazz:AnyObject.Type, responder:AnyObject) -> Bool {
        return responder.isKind(of: clazz)
    }
    
    //-------
    public func register(interface:Protocol, key:String, responder:AnyObject) {
        if conformsInterface(interface: interface, responder: responder) {
            let aliasName = DynamicAliasUtil.getAliasNameWithObject(obj: interface)
            _AntBusSMC.register(aliasName, key, responder)
        }
    }
    public func register(clazz:AnyObject.Type, key:String, responder:AnyObject) {
        if isKindOfClazz(clazz: clazz, responder: responder) {
            let aliasName = DynamicAliasUtil.getAliasNameWithType(type: clazz)
            _AntBusSMC.register(aliasName, key, responder)
        }
    }
    public func register(interface:Protocol, keys:[String], responder:AnyObject) {
        if conformsInterface(interface: interface, responder: responder) {
            let aliasName = DynamicAliasUtil.getAliasNameWithObject(obj: interface)
            _AntBusSMC.register(aliasName, keys, responder)
        }
    }
    public func register(clazz:AnyObject.Type, keys:[String], responder:AnyObject) {
        if isKindOfClazz(clazz: clazz, responder: responder) {
            let aliasName = DynamicAliasUtil.getAliasNameWithType(type: clazz)
            _AntBusSMC.register(aliasName, keys, responder)
        }
    }
    public func register(interface:Protocol, key:String, responders:NSArray) {
        if let _resps = responders as Array<AnyObject>? {
            let aliasName = DynamicAliasUtil.getAliasNameWithObject(obj: interface)
            for resp in _resps {
                if conformsInterface(interface: interface, responder: resp) {
                    _AntBusSMC.register(aliasName, key, resp)
                }
            }
        }
    }
    public func register(clazz:AnyObject.Type, key:String, responders:NSArray) {
        if let _resps = responders as Array<AnyObject>? {
            let aliasName = DynamicAliasUtil.getAliasNameWithType(type: clazz)
            for resp in _resps {
                if isKindOfClazz(clazz: clazz, responder: resp) {
                    _AntBusSMC.register(aliasName, key, resp)
                }
            }
        }
    }
    //-------
    public func responder(interface:Protocol, key:String) -> NSArray?{
        let aliasName = DynamicAliasUtil.getAliasNameWithObject(obj: interface)
        return _AntBusSMC.responders(aliasName, key) as NSArray?
    }
    public func responder(clazz:AnyObject.Type, key:String) -> NSArray?{
        let aliasName = DynamicAliasUtil.getAliasNameWithType(type: clazz)
        return _AntBusSMC.responders(aliasName, key) as NSArray?
    }
    public func responder(interface:Protocol) -> NSArray?{
        let aliasName = DynamicAliasUtil.getAliasNameWithObject(obj: interface)
        return _AntBusSMC.responders(aliasName) as NSArray?
    }
    public func responder(clazz:AnyObject.Type) -> NSArray?{
        let aliasName = DynamicAliasUtil.getAliasNameWithType(type: clazz)
        return _AntBusSMC.responders(aliasName) as NSArray?
    }
    //-------
    public func remove(interface:Protocol, key:String, responder:AnyObject){
        let aliasName = DynamicAliasUtil.getAliasNameWithObject(obj: interface)
        _AntBusSMC.remove(aliasName, key) { smResp in
            if let resp:AnyObject = smResp as AnyObject? {
                return resp === responder
            }
            return false
        }
    }
    public func remove(clazz:AnyObject.Type, key:String, responder:AnyObject){
        let aliasName = DynamicAliasUtil.getAliasNameWithType(type: clazz)
        _AntBusSMC.remove(aliasName, key) { smResp in
            if let resp:AnyObject = smResp as AnyObject? {
                return resp === responder
            }
            return false
        }
    }
    public func remove(interface:Protocol, keys:[String], responder:AnyObject){
        let aliasName = DynamicAliasUtil.getAliasNameWithObject(obj: interface)
        for key in keys {
            _AntBusSMC.remove(aliasName, key) { smResp in
                if let resp:AnyObject = smResp as AnyObject? {
                    return resp === responder
                }
                return false
            }
        }
    }
    public func remove(clazz:AnyObject.Type, key:String, responders:NSArray){
        if let _responders = responders as Array<AnyObject>? {
            let aliasName = DynamicAliasUtil.getAliasNameWithType(type: clazz)
            for responder in _responders {
                _AntBusSMC.remove(aliasName, key) { smResp in
                    if let resp:AnyObject = smResp as AnyObject? {
                        return resp === responder
                    }
                    return false
                }
            }
        }
    }
    public func remove(interface:Protocol, keys:[String]){
        let aliasName = DynamicAliasUtil.getAliasNameWithObject(obj: interface)
        for key in keys {
            _AntBusSMC.remove(aliasName, key)
        }
    }
    public func remove(clazz:AnyObject.Type, keys:[String]){
        let aliasName = DynamicAliasUtil.getAliasNameWithType(type: clazz)
        for key in keys {
            _AntBusSMC.remove(aliasName, key)
        }
    }
    public func remove(interface:Protocol, key:String){
        let aliasName = DynamicAliasUtil.getAliasNameWithObject(obj: interface)
        _AntBusSMC.remove(aliasName, key)
    }
    public func remove(clazz:AnyObject.Type, key:String){
        let aliasName = DynamicAliasUtil.getAliasNameWithType(type: clazz)
        _AntBusSMC.remove(aliasName, key)
    }
    public func remove(interface:Protocol){
        let aliasName = DynamicAliasUtil.getAliasNameWithObject(obj: interface)
        _AntBusSMC.remove(aliasName)
    }
    public func remove(clazz:AnyObject.Type){
        let aliasName = DynamicAliasUtil.getAliasNameWithType(type: clazz)
        _AntBusSMC.remove(aliasName)
    }
}

@objcMembers
public class OCAntBusService: NSObject {
    public static let single = _OCAntBusServiceSS.init()
    public static let multi = _OCAntBusServiceSM.init()
}
