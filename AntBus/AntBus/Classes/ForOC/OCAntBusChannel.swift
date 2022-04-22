import Foundation

@objcMembers
public class _OCAntBusChannelCS: NSObject {
    public func register(interface:Protocol, responder:AnyObject) {
        let aliasName = DynamicAliasUtil.getAliasNameWithInterface(interface)
        _AntBusCSC.register(aliasName, responder)
    }
    public func register(clazz:AnyObject.Type, responder:AnyObject){
        let aliasName = DynamicAliasUtil.getAliasNameWithType(clazz)
        _AntBusCSC.register(aliasName, responder)
    }
    public func responder(interface:Protocol) -> AnyObject?{
        let aliasName = DynamicAliasUtil.getAliasNameWithInterface(interface)
        return _AntBusCSC.responder(aliasName)
    }
    public func responder(clazz:AnyObject.Type) -> AnyObject?{
        let aliasName = DynamicAliasUtil.getAliasNameWithType(clazz)
        return _AntBusCSC.responder(aliasName)
    }
    public func remove(interface:Protocol) {
        let aliasName = DynamicAliasUtil.getAliasNameWithInterface(interface)
        _AntBusCSC.remove(aliasName)
    }
    public func remove(clazz:AnyObject.Type) {
        let aliasName = DynamicAliasUtil.getAliasNameWithType(clazz)
        _AntBusCSC.remove(aliasName)
    }
    public func removeAll() {
        _AntBusCSC.removeAll()
    }
}

@objcMembers
public class _OCAntBusChannelCM: NSObject {
    
    func conformsInterface(interface:Protocol, responder:AnyObject) -> Bool {
        return responder.conforms(to: interface)
    }
    func isKindOfClazz(clazz:AnyObject.Type, responder:AnyObject) -> Bool {
        return responder.isKind(of: clazz)
    }
    
    //-------
    public func register(interface:Protocol, key:String, responder:AnyObject) {
        if conformsInterface(interface: interface, responder: responder) {
            let aliasName = DynamicAliasUtil.getAliasNameWithInterface(interface)
            _AntBusCMC.register(aliasName, key, responder)
        }
    }
    public func register(clazz:AnyObject.Type, key:String, responder:AnyObject) {
        if isKindOfClazz(clazz: clazz, responder: responder) {
            let aliasName = DynamicAliasUtil.getAliasNameWithType(clazz)
            _AntBusCMC.register(aliasName, key, responder)
        }
    }
    public func register(interface:Protocol, keys:[String], responder:AnyObject) {
        if conformsInterface(interface: interface, responder: responder) {
            let aliasName = DynamicAliasUtil.getAliasNameWithInterface(interface)
            _AntBusCMC.register(aliasName, keys, responder)
        }
    }
    public func register(clazz:AnyObject.Type, keys:[String], responder:AnyObject) {
        if isKindOfClazz(clazz: clazz, responder: responder) {
            let aliasName = DynamicAliasUtil.getAliasNameWithType(clazz)
            _AntBusCMC.register(aliasName, keys, responder)
        }
    }
    public func register(interface:Protocol, key:String, responders:NSArray) {
        if let _resps = responders as Array<AnyObject>? {
            let aliasName = DynamicAliasUtil.getAliasNameWithInterface(interface)
            for resp in _resps {
                if conformsInterface(interface: interface, responder: resp) {
                    _AntBusCMC.register(aliasName, key, resp)
                }
            }
        }
    }
    public func register(clazz:AnyObject.Type, key:String, responders:NSArray) {
        if let _resps = responders as Array<AnyObject>? {
            let aliasName = DynamicAliasUtil.getAliasNameWithType(clazz)
            for resp in _resps {
                if isKindOfClazz(clazz: clazz, responder: resp) {
                    _AntBusCMC.register(aliasName, key, resp)
                }
            }
        }
    }
    //-------
    public func responder(interface:Protocol, key:String) -> NSArray?{
        let aliasName = DynamicAliasUtil.getAliasNameWithInterface(interface)
        return _AntBusCMC.responders(aliasName, key) as NSArray?
    }
    public func responder(clazz:AnyObject.Type, key:String) -> NSArray?{
        let aliasName = DynamicAliasUtil.getAliasNameWithType(clazz)
        return _AntBusCMC.responders(aliasName, key) as NSArray?
    }
    public func responder(interface:Protocol) -> NSArray?{
        let aliasName = DynamicAliasUtil.getAliasNameWithInterface(interface)
        return _AntBusCMC.responders(aliasName) as NSArray?
    }
    public func responder(clazz:AnyObject.Type) -> NSArray?{
        let aliasName = DynamicAliasUtil.getAliasNameWithType(clazz)
        return _AntBusCMC.responders(aliasName) as NSArray?
    }
    //-------
    public func remove(interface:Protocol, key:String, responder:AnyObject){
        let aliasName = DynamicAliasUtil.getAliasNameWithInterface(interface)
        _AntBusCMC.remove(aliasName, key, responder)
    }
    public func remove(clazz:AnyObject.Type, key:String, responder:AnyObject){
        let aliasName = DynamicAliasUtil.getAliasNameWithType(clazz)
        _AntBusCMC.remove(aliasName, key, responder)
    }
    public func remove(interface:Protocol, keys:[String], responder:AnyObject){
        let aliasName = DynamicAliasUtil.getAliasNameWithInterface(interface)
        _AntBusCMC.remove(aliasName, keys, responder)
    }
    public func remove(clazz:AnyObject.Type, key:String, responders:NSArray){
        let aliasName = DynamicAliasUtil.getAliasNameWithType(clazz)
        _AntBusCMC.remove(aliasName, key, responders)
    }
    public func remove(interface:Protocol, keys:[String]){
        let aliasName = DynamicAliasUtil.getAliasNameWithInterface(interface)
        _AntBusCMC.remove(aliasName, keys)
    }
    public func remove(clazz:AnyObject.Type, keys:[String]){
        let aliasName = DynamicAliasUtil.getAliasNameWithType(clazz)
        _AntBusCMC.remove(aliasName, keys)
    }
    public func remove(interface:Protocol, key:String){
        let aliasName = DynamicAliasUtil.getAliasNameWithInterface(interface)
        _AntBusCMC.remove(aliasName, key)
    }
    public func remove(clazz:AnyObject.Type, key:String){
        let aliasName = DynamicAliasUtil.getAliasNameWithType(clazz)
        _AntBusCMC.remove(aliasName, key)
    }
    public func remove(interface:Protocol){
        let aliasName = DynamicAliasUtil.getAliasNameWithInterface(interface)
        _AntBusCMC.remove(aliasName)
    }
    public func remove(clazz:AnyObject.Type){
        let aliasName = DynamicAliasUtil.getAliasNameWithType(clazz)
        _AntBusCMC.remove(aliasName)
    }
}

@objcMembers
public class OCAntBusChannel: NSObject {
    public static let single = _OCAntBusChannelCS.init()
    public static let multi = _OCAntBusChannelCM.init()
}
