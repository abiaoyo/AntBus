import Foundation

@objcMembers
public class OCAntBusChannelCS: NSObject {
    public func register(interface:Protocol, responder:AnyObject) {
        let aliasName = DynamicAliasUtil.getAliasNameForInterface(interface)
        AntBusCSC.register(aliasName, responder)
    }
    public func register(clazz:AnyObject.Type, responder:AnyObject){
        let aliasName = DynamicAliasUtil.getAliasNameForType(clazz)
        AntBusCSC.register(aliasName, responder)
    }
    public func responder(interface:Protocol) -> AnyObject?{
        let aliasName = DynamicAliasUtil.getAliasNameForInterface(interface)
        return AntBusCSC.responder(aliasName)
    }
    public func responder(clazz:AnyObject.Type) -> AnyObject?{
        let aliasName = DynamicAliasUtil.getAliasNameForType(clazz)
        return AntBusCSC.responder(aliasName)
    }
    public func remove(interface:Protocol) {
        let aliasName = DynamicAliasUtil.getAliasNameForInterface(interface)
        AntBusCSC.remove(aliasName)
    }
    public func remove(clazz:AnyObject.Type) {
        let aliasName = DynamicAliasUtil.getAliasNameForType(clazz)
        AntBusCSC.remove(aliasName)
    }
    public func removeAll() {
        AntBusCSC.removeAll()
    }
}

@objcMembers
public class OCAntBusChannelCM: NSObject {
    
    func conformsInterface(interface:Protocol, responder:AnyObject) -> Bool {
        return responder.conforms(to: interface)
    }
    func isKindOfClazz(clazz:AnyObject.Type, responder:AnyObject) -> Bool {
        return responder.isKind(of: clazz)
    }
    
    //-------
    public func register(interface:Protocol, key:String, responder:AnyObject) {
        if conformsInterface(interface: interface, responder: responder) {
            let aliasName = DynamicAliasUtil.getAliasNameForInterface(interface)
            AntBusCMC.register(aliasName, key, responder)
        }
    }
    public func register(clazz:AnyObject.Type, key:String, responder:AnyObject) {
        if isKindOfClazz(clazz: clazz, responder: responder) {
            let aliasName = DynamicAliasUtil.getAliasNameForType(clazz)
            AntBusCMC.register(aliasName, key, responder)
        }
    }
    public func register(interface:Protocol, keys:[String], responder:AnyObject) {
        if conformsInterface(interface: interface, responder: responder) {
            let aliasName = DynamicAliasUtil.getAliasNameForInterface(interface)
            AntBusCMC.register(aliasName, keys, responder)
        }
    }
    public func register(clazz:AnyObject.Type, keys:[String], responder:AnyObject) {
        if isKindOfClazz(clazz: clazz, responder: responder) {
            let aliasName = DynamicAliasUtil.getAliasNameForType(clazz)
            AntBusCMC.register(aliasName, keys, responder)
        }
    }
    public func register(interface:Protocol, key:String, responders:NSArray) {
        if let _resps = responders as Array<AnyObject>? {
            let aliasName = DynamicAliasUtil.getAliasNameForInterface(interface)
            for resp in _resps {
                if conformsInterface(interface: interface, responder: resp) {
                    AntBusCMC.register(aliasName, key, resp)
                }
            }
        }
    }
    public func register(clazz:AnyObject.Type, key:String, responders:NSArray) {
        if let _resps = responders as Array<AnyObject>? {
            let aliasName = DynamicAliasUtil.getAliasNameForType(clazz)
            for resp in _resps {
                if isKindOfClazz(clazz: clazz, responder: resp) {
                    AntBusCMC.register(aliasName, key, resp)
                }
            }
        }
    }
    //-------
    public func responder(interface:Protocol, key:String) -> NSArray?{
        let aliasName = DynamicAliasUtil.getAliasNameForInterface(interface)
        return AntBusCMC.responders(aliasName, key) as NSArray?
    }
    public func responder(clazz:AnyObject.Type, key:String) -> NSArray?{
        let aliasName = DynamicAliasUtil.getAliasNameForType(clazz)
        return AntBusCMC.responders(aliasName, key) as NSArray?
    }
    public func responder(interface:Protocol) -> NSArray?{
        let aliasName = DynamicAliasUtil.getAliasNameForInterface(interface)
        return AntBusCMC.responders(aliasName) as NSArray?
    }
    public func responder(clazz:AnyObject.Type) -> NSArray?{
        let aliasName = DynamicAliasUtil.getAliasNameForType(clazz)
        return AntBusCMC.responders(aliasName) as NSArray?
    }
    //-------
    public func remove(interface:Protocol, key:String, responder:AnyObject){
        let aliasName = DynamicAliasUtil.getAliasNameForInterface(interface)
        AntBusCMC.remove(aliasName, key, responder)
    }
    public func remove(clazz:AnyObject.Type, key:String, responder:AnyObject){
        let aliasName = DynamicAliasUtil.getAliasNameForType(clazz)
        AntBusCMC.remove(aliasName, key, responder)
    }
    public func remove(interface:Protocol, keys:[String], responder:AnyObject){
        let aliasName = DynamicAliasUtil.getAliasNameForInterface(interface)
        AntBusCMC.remove(aliasName, keys, responder)
    }
    public func remove(clazz:AnyObject.Type, key:String, responders:NSArray){
        let aliasName = DynamicAliasUtil.getAliasNameForType(clazz)
        AntBusCMC.remove(aliasName, key, responders)
    }
    public func remove(interface:Protocol, keys:[String]){
        let aliasName = DynamicAliasUtil.getAliasNameForInterface(interface)
        AntBusCMC.remove(aliasName, keys)
    }
    public func remove(clazz:AnyObject.Type, keys:[String]){
        let aliasName = DynamicAliasUtil.getAliasNameForType(clazz)
        AntBusCMC.remove(aliasName, keys)
    }
    public func remove(interface:Protocol, key:String){
        let aliasName = DynamicAliasUtil.getAliasNameForInterface(interface)
        AntBusCMC.remove(aliasName, key)
    }
    public func remove(clazz:AnyObject.Type, key:String){
        let aliasName = DynamicAliasUtil.getAliasNameForType(clazz)
        AntBusCMC.remove(aliasName, key)
    }
    public func remove(interface:Protocol){
        let aliasName = DynamicAliasUtil.getAliasNameForInterface(interface)
        AntBusCMC.remove(aliasName)
    }
    public func remove(clazz:AnyObject.Type){
        let aliasName = DynamicAliasUtil.getAliasNameForType(clazz)
        AntBusCMC.remove(aliasName)
    }
}
