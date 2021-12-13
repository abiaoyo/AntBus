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
        let log = "AntChannelSingleC(\(#line)) - \(#function):  responder:\(responder)"
        AntChannelLog.handlerLog(.Responder, log)
    }
    public func responder() -> R?{
        let log = "AntChannelSingleC(\(#line)) - \(#function)  =\(String(describing: _responder))"
        AntChannelLog.handlerLog(.Responder, log)
        
        return _responder
    }
    public func remove() -> Void{
        _responder = nil
        
        let log = "AntChannelSingleC(\(#line)) - \(#function)"
        AntChannelLog.handlerLog(.Responder, log)
    }
}

//MARK: - AntChannelMultiC
public class AntChannelMultiC<R:AnyObject> {
    private var keyResponderContainer = NSMapTable<NSString,NSHashTable<R>>.strongToStrongObjects()
        
    public func register(_ key:String, _ responder:R) -> Void{
        let log = "AntChannelMultiC(\(#line)) - \(#function):  key:\(key) responder:\(responder)"
        AntChannelLog.handlerLog(.Responder, log)
        
        if let responders = keyResponderContainer.object(forKey: key as NSString) {
            responders.add(responder)
        }else{
            let responders = NSHashTable<R>.weakObjects()
            responders.add(responder)
            keyResponderContainer.setObject(responders, forKey: key as NSString)
        }
    }
    
    public func register(_ keys:[String], _ responder:R) -> Void{
        let log = "AntChannelMultiC(\(#line)) - \(#function):  keys:\(keys) responder:\(responder)"
        AntChannelLog.handlerLog(.Responder, log)
        
        for key in keys {
            register(key, responder)
        }
    }
    
    public func register(_ key:String, _ responders:[R]) -> Void{
        let log = "AntChannelMultiC(\(#line)) - \(#function):  key:\(key) responders:\(String(describing: responders))"
        AntChannelLog.handlerLog(.Responder, log)
        
        for responder in responders {
            register(key, responder)
        }
    }

    public func responders(_ key:String) -> [R]? {
        let responders = keyResponderContainer.object(forKey: key as NSString)?.allObjects
        
        let log = "AntChannelMultiC(\(#line)) - \(#function):  .key:\(key) \t  =\(String(describing: responders))"
        AntChannelLog.handlerLog(.Responder, log)
        
        return responders
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
        let log = "AntChannelMultiC(\(#line)) - \(#function)  =\(String(describing: responders)))"
        AntChannelLog.handlerLog(.Responder, log)
        
        return responders
    }
    
    public func remove(_ keys:[String],_ responder:R) -> Void {
        let log = "AntChannelMultiC(\(#line)) - \(#function):  keys:\(keys)  responder:\(responder)"
        AntChannelLog.handlerLog(.Responder, log)
        
        for key in keys {
            if let objects = keyResponderContainer.object(forKey: key as NSString) {
                objects.remove(responder)
            }
        }
    }
    
    public func remove(_ keys:[String]) -> Void {
        let log = "AntChannelMultiC(\(#line)) - \(#function):  keys:\(keys)"
        AntChannelLog.handlerLog(.Responder, log)
        
        for key in keys {
            keyResponderContainer.removeObject(forKey: key as NSString)
        }
    }
    
    public func remove(_ key:String,_ responder:R) -> Void{
        if let responders = keyResponderContainer.object(forKey: key as NSString) {
            responders.remove(responder)
        }
        
        let log = "AntChannelMultiC(\(#line)) - \(#function):  key:\(key)  responder:\(responder)"
        AntChannelLog.handlerLog(.Responder, log)
    }
    
    public func remove(_ key:String) -> Void{
        keyResponderContainer.removeObject(forKey: key as NSString)
        let log = "AntChannelMultiC(\(#line)) - \(#function):  key:\(key)"
        AntChannelLog.handlerLog(.Responder, log)
    }
    
    public func removeAll() -> Void {
        keyResponderContainer.removeAllObjects()
        let log = "AntChannelMultiC(\(#line)) - \(#function)"
        AntChannelLog.handlerLog(.Responder, log)
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
        let key = AnChannelUtil.getIKey(interface) { logOptions, log in
            AntChannelLog.handlerLog(logOptions, log)
        }
        return AnChannelUtil.createSingleC(key: key)
    }
    public static func multipleInterface<I:AnyObject>(_ interface:I.Type) -> AntChannelMultiC<I> {
        let key = AnChannelUtil.getIKey(interface) { logOptions, log in
            AntChannelLog.handlerLog(logOptions, log)
        }
        return AnChannelUtil.createMultipleC(key: key)
    }
}

/// 示例：
/// AntChannelInterface.single.register(xxx)  ⚠️⚠️⚠️
/// AntChannelInterface<Interface>.single.register(xxx)  ✅     OR    AntChannel.singleInterface(Interface.self).register(xxx)  ✅
