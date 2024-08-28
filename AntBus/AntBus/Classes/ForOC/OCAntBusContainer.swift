import Foundation

@objcMembers
public class OCAntBusContainer: NSObject {
    public static let shared = OCAntBusContainer()
    public let single = OCAntBusSC.init()
    public let multiple = OCAntBusMC.init()
    
    
}

@objcMembers
public class OCAntBusSC: NSObject {
    public func all() -> NSDictionary {
        return AntBusContainerSC.all()
    }

    public func register(interface: Protocol, object: AnyObject) {
        let name = AliasUtil.aliasForInterface(interface)
        if object.conforms(to: interface) {
            AntBusContainerSC.register(name, object)
        }else {
            AntBus.log.handler?(.container, "AntBus.plus.container.single.register:  \(name) \t **** error: \"\(object) not conforms to \(interface)\" ****")
            assertionFailure("error: \"\(object) not conforms to \(interface)\"")
        }
    }

    public func register(clazz: AnyObject.Type, object: AnyObject) {
        let name = AliasUtil.aliasForAnyObject(clazz)
        if object.isKind(of: clazz) {
            AntBusContainerSC.register(name, object)
        }else {
            AntBus.log.handler?(.container, "AntBus.plus.container.single.register:  \(name) \t **** error: \"\(object) not isKind of \(clazz)\" ****")
            assertionFailure("error: \"\(object) not isKind of \(clazz)\"")
        }
    }

    public func object(interface: Protocol) -> AnyObject? {
        let name = AliasUtil.aliasForInterface(interface)
        return AntBusContainerSC.object(name)
    }

    public func object(clazz: AnyObject.Type) -> AnyObject? {
        let name = AliasUtil.aliasForAnyObject(clazz)
        return AntBusContainerSC.object(name)
    }

    public func remove(interface: Protocol) {
        let name = AliasUtil.aliasForInterface(interface)
        AntBusContainerSC.remove(name)
    }

    public func remove(clazz: AnyObject.Type) {
        let name = AliasUtil.aliasForAnyObject(clazz)
        AntBusContainerSC.remove(name)
    }

    public func removeAll() {
        AntBusContainerSC.removeAll()
    }
}

@objcMembers
public class OCAntBusMC: NSObject {
    public func all() -> NSDictionary {
        return AntBusContainerMC.all()
    }

    public func register(interface: Protocol, object: AnyObject, forKey key: String) {
        let typeStr = AliasUtil.aliasForInterface(interface)
        if object.conforms(to: interface) {
            AntBusContainerMC.register(typeStr, key, object)
        }else {
            AntBus.log.handler?(.container, "AntBus.plus.container.multiple.register:  \(typeStr) \t **** error: \"\(object) not conforms to \(interface)\" ****")
            assertionFailure("error: \"\(object) not conforms to \(interface)\"")
        }
    }
    
    public func register(clazz: AnyObject.Type, object: AnyObject, forKey key: String) {
        let typeStr = AliasUtil.aliasForAnyObject(clazz)
        if object.isKind(of: clazz) {
            AntBusContainerMC.register(typeStr, key, object)
        }else {
            AntBus.log.handler?(.container, "AntBus.plus.container.multiple.register:  \(typeStr) \t **** error: \"\(object) not isKind of \(clazz)\" ****")
            assertionFailure("error: \"\(object) not isKind of \(clazz)\"")
        }
    }
    
    //---
    public func register(interface: Protocol, objects: [AnyObject], forKey key: String) {
        objects.forEach { object in
            register(interface: interface, object: object, forKey: key)
        }
    }
    
    public func register(clazz: AnyObject.Type, objects: [AnyObject], forKey key: String) {
        objects.forEach { object in
            register(clazz: clazz, object: object, forKey: key)
        }
    }
    
    //---
    public func register(interface: Protocol, object: AnyObject, forKeys keys: [String]) {
        keys.forEach { key in
            register(interface: interface, object: object, forKey: key)
        }
    }
    
    public func register(clazz: AnyObject.Type, object: AnyObject, forKeys keys: [String]) {
        keys.forEach { key in
            register(clazz: clazz, object: object, forKey: key)
        }
    }
    
    //---
    public func objects(interface: Protocol, forKey key: String) -> [AnyObject]? {
        let typeStr = AliasUtil.aliasForInterface(interface)
        return AntBusContainerMC.objects(typeStr, key)
    }
    
    public func objects(clazz: AnyObject.Type, forKey key: String) -> [AnyObject]? {
        let typeStr = AliasUtil.aliasForAnyObject(clazz)
        return AntBusContainerMC.objects(typeStr, key)
    }
    
    //---
    public func objects(interface: Protocol) -> [AnyObject]? {
        let typeStr = AliasUtil.aliasForInterface(interface)
        return AntBusContainerMC.objects(typeStr)
    }
    
    public func objects(clazz: AnyObject.Type) -> [AnyObject]? {
        let typeStr = AliasUtil.aliasForAnyObject(clazz)
        return AntBusContainerMC.objects(typeStr)
    }
    
    //---
    public func remove(interface: Protocol, object: AnyObject, forKey key: String) {
        let typeStr = AliasUtil.aliasForInterface(interface)
        AntBusContainerMC.remove(typeStr, key, object)
    }
    public func remove(clazz: AnyObject.Type, object: AnyObject, forKey key: String) {
        let typeStr = AliasUtil.aliasForAnyObject(clazz)
        AntBusContainerMC.remove(typeStr, key, object)
    }
    
    //---
    public func remove(interface: Protocol, object: AnyObject, forKeys keys: [String]) {
        keys.forEach { key in
            remove(interface: interface, object: object, forKey: key)
        }
    }
    
    public func remove(clazz: AnyObject.Type, object: AnyObject, forKeys keys: [String]) {
        keys.forEach { key in
            remove(clazz: clazz, object: object, forKey: key)
        }
    }
    
    //---
    public func remove(interface: Protocol, objects: [AnyObject], forKey key: String) {
        objects.forEach { object in
            remove(interface: interface, object: object, forKey: key)
        }
    }
    
    public func remove(clazz: AnyObject.Type, objects: [AnyObject], forKey key: String) {
        objects.forEach { object in
            remove(clazz: clazz, object: object, forKey: key)
        }
    }
    
    //---
    public func remove(interface: Protocol, forKey key: String) {
        let typeStr = AliasUtil.aliasForInterface(interface)
        AntBusContainerMC.remove(typeStr, key)
    }
    
    public func remove(clazz: AnyObject.Type, forKey key: String) {
        let typeStr = AliasUtil.aliasForAnyObject(clazz)
        AntBusContainerMC.remove(typeStr, key)
    }
    
    //---
    public func remove(interface: Protocol, forKeys keys: [String]) {
        keys.forEach { key in
            remove(interface: interface, forKey: key)
        }
    }
    
    public func remove(clazz: AnyObject.Type, forKeys keys: [String]) {
        keys.forEach { key in
            remove(clazz: clazz, forKey: key)
        }
    }
    
    //---
    public func remove(interface: Protocol) {
        let typeStr = AliasUtil.aliasForInterface(interface)
        AntBusContainerMC.remove(typeStr)
    }
    public func remove(clazz: AnyObject.Type) {
        let typeStr = AliasUtil.aliasForAnyObject(clazz)
        AntBusContainerMC.remove(typeStr)
    }
}
