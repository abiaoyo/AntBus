//
//  AntChannel.swift
//  AntBus
//  Created by abiaoyo
//

import Foundation

//MARK: - AntChannelSingleC
public class AntChannelSingleC<R:AnyObject> {
    private weak var _responder:R?
    
    public func register(_ responder:R) -> Void{
        _responder = responder
    }
    public func responder() -> R?{
        return _responder
    }
    public func remove() -> Void{
        _responder = nil
    }
}

//MARK: - AntChannelMultiC
public class AntChannelMultiC<R:AnyObject> {
    private var keyResponderContainer = NSMapTable<NSString,NSHashTable<R>>.strongToStrongObjects()
        
    public func register(_ key:String, _ responder:R) -> Void{
        if let responders = keyResponderContainer.object(forKey: key as NSString) {
            responders.add(responder)
        }else{
            let responders = NSHashTable<R>.weakObjects()
            responders.add(responder)
            keyResponderContainer.setObject(responders, forKey: key as NSString)
        }
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
        return keyResponderContainer.object(forKey: key as NSString)?.allObjects
    }
    
    public func responders() -> [R]? {
        var responders:[R]? = nil
        if let objects:[AnyObject] = keyResponderContainer.objectEnumerator()?.allObjects.flatMap({ ($0 as! NSHashTable<AnyObject>).objectEnumerator().map{ $0 }}) as [AnyObject]? {
            let resultSet = NSHashTable<R>.init()
            for object in objects {
                resultSet.add(object as? R)
            }
            responders = resultSet.allObjects
        }
        return responders
    }
    
    public func remove(_ keys:[String],_ responder:R) -> Void {
        
        for key in keys {
            if let objects = keyResponderContainer.object(forKey: key as NSString) {
                objects.remove(responder)
            }
        }
    }
    
    public func remove(_ keys:[String]) -> Void {
        for key in keys {
            keyResponderContainer.removeObject(forKey: key as NSString)
        }
    }
    
    public func remove(_ key:String,_ responder:R) -> Void{
        if let responders = keyResponderContainer.object(forKey: key as NSString) {
            responders.remove(responder)
        }
    }
    
    public func remove(_ key:String) -> Void{
        keyResponderContainer.removeObject(forKey: key as NSString)
    }
    
    public func removeAll() -> Void {
        keyResponderContainer.removeAllObjects()
    }
}

//MARK: - AntChannelUtil
struct AntChannelCacheUtil{
    static var singleCs = Dictionary<String,AnyObject>.init()
    static var multiCs = Dictionary<String,AnyObject>.init()
    
    static func createSingleC<Interface:Any>(_ aliasName:String) -> AntChannelSingleC<Interface>{
        var container = AntChannelCacheUtil.singleCs[aliasName]
        if container == nil {
            container = AntChannelSingleC<Interface>.init()
            AntChannelCacheUtil.singleCs[aliasName] = container
        }
        
        return container as! AntChannelSingleC<Interface>
    }
    
    static func createMultipleC<Interface:Any>(_ aliasName:String) -> AntChannelMultiC<Interface>{
        var container = AntChannelCacheUtil.multiCs[aliasName]
        if container == nil {
            container = AntChannelMultiC<Interface>.init()
            AntChannelCacheUtil.multiCs[aliasName] = container
        }
        
        return container as! AntChannelMultiC<Interface>
    }
}


//MARK: - AntChannelInterface
public struct AntChannelInterface<Interface:AnyObject>{
    public static var single:AntChannelSingleC<Interface> {
        get {
            return AntChannel.singleInterface(Interface.self)
        }
    }
    public static var multiple:AntChannelMultiC<Interface> {
        get {
            return AntChannel.multipleInterface(Interface.self)
        }
    }
}

//MARK: - AntChannel
public struct AntChannel{
    public static func singleInterface<I:AnyObject>(_ interface:I.Type) -> AntChannelSingleC<I> {
        let aliasName = DynamicAliasUtil.getAliasName(interface)
        return AntChannelCacheUtil.createSingleC(aliasName)
    }
    public static func multipleInterface<I:AnyObject>(_ interface:I.Type) -> AntChannelMultiC<I> {
        let aliasName = DynamicAliasUtil.getAliasName(interface)
        return AntChannelCacheUtil.createMultipleC(aliasName)
    }
}

/// 示例：
/// AntChannelInterface.single.register(xxx)  ⚠️⚠️⚠️
/// AntChannelInterface<Interface>.single.register(xxx)  ✅     OR    AntChannel.singleInterface(Interface.self).register(xxx)  ✅
