//
//  AntChannel.swift
//  AntBus
//  Created by abiaoyo
//

import Foundation

//MARK: - AntChannelSingleC
public class AntChannelSingleCache{
    static var keyRespondersContainer = NSMapTable<NSString,AnyObject>.weakToWeakObjects()
    
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

private class AntChannelMultiCache{
    static var keyRespondersContainer = NSMapTable<NSString,NSHashTable<AnyObject>>.weakToStrongObjects()
    
    static func register(_ key:String, _ responder:AnyObject) -> Void{
        if let responders = keyRespondersContainer.object(forKey: key as NSString) {
            responders.add(responder)
        }else{
            let responders = NSHashTable<AnyObject>.weakObjects()
            responders.add(responder)
            keyRespondersContainer.setObject(responders, forKey: key as NSString)
        }
    }
    
    static func responders(_ key:String) -> NSHashTable<AnyObject>? {
        return keyRespondersContainer.object(forKey: key as NSString)
    }
    
    static func remove(_ keys:[String],_ responder:AnyObject) -> Void {
        
        for key in keys {
            if let objects = AntChannelMultiCache.keyRespondersContainer.object(forKey: key as NSString) {
                objects.remove(responder)
            }
        }
    }
    
    static func remove(_ keys:[String]) -> Void {
        for key in keys {
            AntChannelMultiCache.keyRespondersContainer.removeObject(forKey: key as NSString)
        }
    }
    
    static func remove(_ key:String,_ responder:AnyObject) -> Void{
        if let responders = AntChannelMultiCache.keyRespondersContainer.object(forKey: key as NSString) {
            responders.remove(responder)
        }
    }
    
    static func remove(_ key:String) -> Void{
        AntChannelMultiCache.keyRespondersContainer.removeObject(forKey: key as NSString)
    }
    
    static func remove() -> Void {
        AntChannelMultiCache.keyRespondersContainer.removeAllObjects()
    }
}

//MARK: - AntChannelMultiC
final public class AntChannelMultiC<R:AnyObject> {
    
    public func register(_ key:String, _ responder:R) -> Void{
        AntChannelMultiCache.register(key, responder)
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
        return AntChannelMultiCache.responders(key)?.allObjects.compactMap({ $0 as? R})
    }
    
    public func responders() -> [R]? {
        var responders:[R]? = nil
        
        if let objects:[AnyObject] = AntChannelMultiCache.keyRespondersContainer.objectEnumerator()?.allObjects.flatMap({ ($0 as! NSHashTable<AnyObject>).objectEnumerator().map{ $0 }}) as [AnyObject]? {
            let resultSet = NSHashTable<R>.init()
            for object in objects {
                resultSet.add(object as? R)
            }
            responders = resultSet.allObjects
        }
        return responders
    }
    
    public func remove(_ keys:[String],_ responder:R) -> Void {
        AntChannelMultiCache.remove(keys, responder)
    }
    
    public func remove(_ keys:[String]) -> Void {
        AntChannelMultiCache.remove(keys)
    }
    
    public func remove(_ key:String,_ responder:R) -> Void{
        AntChannelMultiCache.remove(key, responder)
    }
    
    public func remove(_ key:String) -> Void{
        AntChannelMultiCache.remove(key)
    }
    
    public func remove() -> Void {
        AntChannelMultiCache.remove()
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
