import Foundation

@objcMembers
public class OCAntBusChannelCS: NSObject {
    public func register(interface: Protocol, responder: AnyObject) {
        let name = DynamicAliasUtil.getAliasNameForInterface(interface)
        AntBusCSC.register(name, responder)
    }

    public func register(clazz: AnyObject.Type, responder: AnyObject) {
        let name = DynamicAliasUtil.getAliasNameForType(clazz)
        AntBusCSC.register(name, responder)
    }

    public func responder(interface: Protocol) -> AnyObject? {
        let name = DynamicAliasUtil.getAliasNameForInterface(interface)
        return AntBusCSC.responder(name)
    }

    public func responder(clazz: AnyObject.Type) -> AnyObject? {
        let name = DynamicAliasUtil.getAliasNameForType(clazz)
        return AntBusCSC.responder(name)
    }

    public func remove(interface: Protocol) {
        let name = DynamicAliasUtil.getAliasNameForInterface(interface)
        AntBusCSC.remove(name)
    }

    public func remove(clazz: AnyObject.Type) {
        let name = DynamicAliasUtil.getAliasNameForType(clazz)
        AntBusCSC.remove(name)
    }

    public func removeAll() {
        AntBusCSC.removeAll()
    }
}

@objcMembers
public class OCAntBusChannelCM: NSObject {
    private func conformsInterface(interface: Protocol, responder: AnyObject) -> Bool {
        return responder.conforms(to: interface)
    }

    private func isKindOfClazz(clazz: AnyObject.Type, responder: AnyObject) -> Bool {
        return responder.isKind(of: clazz)
    }

    // -------
    public func register(interface: Protocol, key: String, responder: AnyObject) {
        if conformsInterface(interface: interface, responder: responder) {
            let name = DynamicAliasUtil.getAliasNameForInterface(interface)
            AntBusCMC.register(name, key, responder)
        }
    }

    public func register(clazz: AnyObject.Type, key: String, responder: AnyObject) {
        if isKindOfClazz(clazz: clazz, responder: responder) {
            let name = DynamicAliasUtil.getAliasNameForType(clazz)
            AntBusCMC.register(name, key, responder)
        }
    }

    public func register(interface: Protocol, forKeys keys: [String], responder: AnyObject) {
        if conformsInterface(interface: interface, responder: responder) {
            let name = DynamicAliasUtil.getAliasNameForInterface(interface)
            AntBusCMC.register(name, keys, responder)
        }
    }

    public func register(clazz: AnyObject.Type, forKeys keys: [String], responder: AnyObject) {
        if isKindOfClazz(clazz: clazz, responder: responder) {
            let name = DynamicAliasUtil.getAliasNameForType(clazz)
            AntBusCMC.register(name, keys, responder)
        }
    }

    public func register(interface: Protocol, key: String, responders: NSArray) {
        if let _resps = responders as [AnyObject]? {
            let name = DynamicAliasUtil.getAliasNameForInterface(interface)
            for resp in _resps {
                if conformsInterface(interface: interface, responder: resp) {
                    AntBusCMC.register(name, key, resp)
                }
            }
        }
    }

    public func register(clazz: AnyObject.Type, key: String, responders: NSArray) {
        if let _resps = responders as [AnyObject]? {
            let name = DynamicAliasUtil.getAliasNameForType(clazz)
            for resp in _resps {
                if isKindOfClazz(clazz: clazz, responder: resp) {
                    AntBusCMC.register(name, key, resp)
                }
            }
        }
    }

    // -------
    public func responder(interface: Protocol, key: String) -> NSArray? {
        let name = DynamicAliasUtil.getAliasNameForInterface(interface)
        return AntBusCMC.responders(name, key) as NSArray?
    }

    public func responder(clazz: AnyObject.Type, key: String) -> NSArray? {
        let name = DynamicAliasUtil.getAliasNameForType(clazz)
        return AntBusCMC.responders(name, key) as NSArray?
    }

    public func responder(interface: Protocol) -> NSArray? {
        let name = DynamicAliasUtil.getAliasNameForInterface(interface)
        return AntBusCMC.responders(name) as NSArray?
    }

    public func responder(clazz: AnyObject.Type) -> NSArray? {
        let name = DynamicAliasUtil.getAliasNameForType(clazz)
        return AntBusCMC.responders(name) as NSArray?
    }

    // -------
    public func remove(interface: Protocol, key: String, responder: AnyObject) {
        let name = DynamicAliasUtil.getAliasNameForInterface(interface)
        AntBusCMC.remove(name, key, responder)
    }

    public func remove(clazz: AnyObject.Type, key: String, responder: AnyObject) {
        let name = DynamicAliasUtil.getAliasNameForType(clazz)
        AntBusCMC.remove(name, key, responder)
    }

    public func remove(interface: Protocol, forKeys keys: [String], responder: AnyObject) {
        let name = DynamicAliasUtil.getAliasNameForInterface(interface)
        AntBusCMC.remove(name, keys, responder)
    }

    public func remove(clazz: AnyObject.Type, key: String, responders: NSArray) {
        let name = DynamicAliasUtil.getAliasNameForType(clazz)
        AntBusCMC.remove(name, key, responders)
    }

    public func remove(interface: Protocol, forKeys keys: [String]) {
        let name = DynamicAliasUtil.getAliasNameForInterface(interface)
        AntBusCMC.remove(name, keys)
    }

    public func remove(forKeys keys: [String], clazz: AnyObject.Type) {
        let name = DynamicAliasUtil.getAliasNameForType(clazz)
        AntBusCMC.remove(name, keys)
    }

    public func remove(interface: Protocol, key: String) {
        let name = DynamicAliasUtil.getAliasNameForInterface(interface)
        AntBusCMC.remove(name, key)
    }

    public func remove(clazz: AnyObject.Type, key: String) {
        let name = DynamicAliasUtil.getAliasNameForType(clazz)
        AntBusCMC.remove(name, key)
    }

    public func remove(interface: Protocol) {
        let name = DynamicAliasUtil.getAliasNameForInterface(interface)
        AntBusCMC.remove(name)
    }

    public func remove(clazz: AnyObject.Type) {
        let name = DynamicAliasUtil.getAliasNameForType(clazz)
        AntBusCMC.remove(name)
    }
}

@objcMembers
public class OCAntBusChannel: NSObject {
    public static let shared = OCAntBusChannel()

    public let single = OCAntBusChannelCS()
    public let multi = OCAntBusChannelCM()
}
