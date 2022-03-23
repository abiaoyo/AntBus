//
//  AntChannel.swift
//  AntBus
//  Created by abiaoyo
//

import Foundation

//MARK: - AntChannelSingleC
public class AntChannelSingleCache{
    
    static var keyRespondersContainer = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    
    static func register(_ key:String, _ responder:AnyObject) -> Void{
        keyRespondersContainer.setObject(responder, forKey: key as NSString)
    }
    static func responder(_ key:String) -> AnyObject?{
        return keyRespondersContainer.object(forKey: key as NSString)
    }
    static func remove(_ key:String) -> Void{
        keyRespondersContainer.removeObject(forKey: key as NSString)
    }
    static func removeAll() -> Void{
        keyRespondersContainer.removeAllObjects()
    }
}

final public class AntChannelSingleC<R:AnyObject> {

    public func register(_ responder:R) -> Void{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntChannelSingleCache.register(aliasName, responder)
    }
    public func responder() -> R?{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        return AntChannelSingleCache.responder(aliasName) as? R
    }
    public func remove() -> Void{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntChannelSingleCache.remove(aliasName)
    }
}


// ==================================================================================
//MARK: - AntChannelMultiCache
private class AntChannelMultiCache{
    
    // <AliasName,<Key,[Response]>>
    static var container = Dictionary<String,NSMapTable<NSString,NSHashTable<AnyObject>>>.init()
    
    static func register(_ aliasName:String, _ key:String, _ responder:AnyObject) -> Void{
        
        var keyContainer = container[aliasName]
        if keyContainer == nil {
            keyContainer = NSMapTable<NSString,NSHashTable<AnyObject>>.init()
            container[aliasName] = keyContainer
        }
        
        var responders = keyContainer?.object(forKey: key as NSString)
        if responders == nil {
            responders = NSHashTable<AnyObject>.weakObjects()
            keyContainer?.setObject(responders, forKey: key as NSString)
        }
        responders?.add(responder)
    }
    
    static func responders(_ aliasName:String, _ key:String) -> [AnyObject]? {
        let keyContainer = container[aliasName]
        return keyContainer?.object(forKey: key as NSString)?.allObjects
    }
    
    static func remove(_ aliasName:String, _ keys:[String],_ responder:AnyObject) -> Void {
        let keyContainer = container[aliasName]
        for key in keys {
            keyContainer?.object(forKey: key as NSString)?.remove(responder)
        }
    }
    
    static func remove(_ aliasName:String, _ keys:[String]) -> Void {
        let keyContainer = container[aliasName]
        for key in keys {
            keyContainer?.removeObject(forKey: key as NSString)
        }
    }
    
    static func remove(_ aliasName:String, _ key:String,_ responder:AnyObject) -> Void{
        let keyContainer = container[aliasName]
        keyContainer?.object(forKey: key as NSString)?.remove(responder)
    }
    
    static func remove(_ aliasName:String, _ key:String) -> Void{
        let keyContainer = container[aliasName]
        keyContainer?.removeObject(forKey: key as NSString)
    }
    
    static func remove(_ aliasName:String) -> Void {
        container.removeValue(forKey: aliasName)
    }
}

//MARK: - AntChannelMultiC
final public class AntChannelMultiC<R:AnyObject> {
    
    public func register(_ key:String, _ responder:R) -> Void{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntChannelMultiCache.register(aliasName, key, responder)
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
        return AntChannelMultiCache.responders(aliasName, key)?.compactMap({ $0 as? R})
    }
    
    public func responders() -> [R]? {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        let keyContainer = AntChannelMultiCache.container[aliasName]
        var responders:[R]? = nil
        if let objects:[AnyObject] = keyContainer?.objectEnumerator()?.allObjects.flatMap({ ($0 as! NSHashTable<AnyObject>).objectEnumerator().map{ $0 }}) as [AnyObject]? {
            let resultSet = NSHashTable<R>.init()
            for object in objects {
                resultSet.add(object as? R)
            }
            responders = resultSet.allObjects
        }
        return responders
    }
    
    public func remove(_ keys:[String],_ responder:R) -> Void {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntChannelMultiCache.remove(aliasName, keys, responder)
    }

    public func remove(_ keys:[String]) -> Void {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntChannelMultiCache.remove(aliasName, keys)
    }

    public func remove(_ key:String,_ responder:R) -> Void{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntChannelMultiCache.remove(aliasName, key, responder)
    }

    public func remove(_ key:String) -> Void{
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntChannelMultiCache.remove(aliasName, key)
    }

    public func remove() -> Void {
        let aliasName = DynamicAliasUtil.getAliasName(R.self)
        AntChannelMultiCache.remove(aliasName)
    }
}

//MARK: - AntChannelInterface
public struct AntChannelInterface<Interface:AnyObject>{
    public static var single:AntChannelSingleC<Interface> {
        get {
            return AntChannelSingleC<Interface>.init()
        }
    }
    public static var multiple:AntChannelMultiC<Interface> {
        get {
            return AntChannelMultiC<Interface>.init()
        }
    }
}

//MARK: - AntChannel
public struct AntChannel{
    public static func singleInterface<I:AnyObject>(_ interface:I.Type) -> AntChannelSingleC<I> {
        return AntChannelSingleC<I>.init()
    }
    public static func multipleInterface<I:AnyObject>(_ interface:I.Type) -> AntChannelMultiC<I> {
        return AntChannelMultiC<I>.init()
    }
}

/// 示例：
/// AntChannelInterface.single.register(xxx)  ⚠️⚠️⚠️
/// AntChannelInterface<Interface>.single.register(xxx)  ✅     OR    AntChannel.singleInterface(Interface.self).register(xxx)  ✅
