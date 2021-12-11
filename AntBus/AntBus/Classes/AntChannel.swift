//
//  AntChannel.swift
//  AntBus
//  Created by abiaoyo
//

import Foundation

//MARK: - AntChannelSingle
public class AntChannelSingle<R:AnyObject> {
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

//MARK: - AntChannelMultiple
public class AntChannelMultiple<R:AnyObject> {
    private var keyResponderContainer = NSMapTable<NSString,NSHashTable<R>>.strongToStrongObjects()
        
    public func register(_ key:String, _ responder:R) -> Void{
        if let responders = self.keyResponderContainer.object(forKey: key as NSString) {
            responders.add(responder)
        }else{
            let responders = NSHashTable<R>.weakObjects()
            responders.add(responder)
            self.keyResponderContainer.setObject(responders, forKey: key as NSString)
        }
    }
    
    public func register(_ keys:[String], _ responder:R) -> Void{
        for key in keys {
            self.register(key, responder)
        }
    }
    
    public func register(_ key:String, _ responders:[R]) -> Void{
        for responder in responders {
            self.register(key, responder)
        }
    }

    public func responders(_ key:String) -> [R]? {
        return self.keyResponderContainer.object(forKey: key as NSString)?.allObjects
    }
    
    public func responders() -> [R]? {
        var responders:[R]? = nil
        if let objects:[AnyObject] = self.keyResponderContainer.objectEnumerator()?.allObjects.flatMap({ ($0 as! NSHashTable<AnyObject>).objectEnumerator().map{ $0 }}) as [AnyObject]? {
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
            if let objects = self.keyResponderContainer.object(forKey: key as NSString) {
                objects.remove(responder)
            }
        }
    }
    
    public func remove(_ keys:[String]) -> Void {
        for key in keys {
            self.keyResponderContainer.removeObject(forKey: key as NSString)
        }
    }
    
    public func remove(_ key:String,_ responder:R) -> Void{
        if let responders = self.keyResponderContainer.object(forKey: key as NSString) {
            responders.remove(responder)
        }
    }
    
    public func remove(_ key:String) -> Void{
        self.keyResponderContainer.removeObject(forKey: key as NSString)
    }
    
    public func removeAll() -> Void {
        self.keyResponderContainer.removeAllObjects()
    }
}

//MARK: - AnChannelUtil
fileprivate struct AnChannelUtil{
    static var singleContainer = Dictionary<String,AnyObject>.init()
    static var multiContainer = Dictionary<String,AnyObject>.init()
    
    static func createSingleC<Interface:Any>(key:String) -> AntChannelSingle<Interface>{
        var container = AnChannelUtil.singleContainer[key]
        if container == nil {
            container = AntChannelSingle<Interface>.init()
            AnChannelUtil.singleContainer[key] = container
        }
        return container as! AntChannelSingle<Interface>
    }
    
    static func createMultipleC<Interface:Any>(key:String) -> AntChannelMultiple<Interface>{
        var container = AnChannelUtil.multiContainer[key]
        if container == nil {
            container = AntChannelMultiple<Interface>.init()
            AnChannelUtil.multiContainer[key] = container
        }
        return container as! AntChannelMultiple<Interface>
    }
    
    //ik
    static var ikGroupContainer = Dictionary<String,Array<iKey>>.init()
    static func getIKey<I:Any>(_ interface:I.Type) -> String{
        let iGroupKey = "\(interface)"
        if let array = ikGroupContainer[iGroupKey] {
            for ik in array {
                if interface == ik.interface as? Any.Type{
                    return ik.key
                }
            }
            let ik = iKey.createIKey(iGroupKey, interface: interface)
            ikGroupContainer[iGroupKey]?.append(ik)
            return ik.key
        }else{
            let ik = iKey.createIKey(iGroupKey, interface: interface)
            ikGroupContainer[iGroupKey] = [ik]
            return ik.key
        }
    }
    
    struct iKey {
        var key:String!
        var interface:Any!

        static func createIKey(_ groupKey:String,interface:Any) -> iKey{
            let key = "\(groupKey)_\(arc4random()%1000)_\(arc4random()%1000)"
            return iKey.init(key: key, interface: interface)
        }
    }
}

//MARK: - AntChannelInterface
public struct AntChannelInterface<Interface:AnyObject>{
    public static var single:AntChannelSingle<Interface> {
        get {
            return AntChannel.singleInterface(Interface.self)
        }
    }
    public static var multiple:AntChannelMultiple<Interface> {
        get {
            return AntChannel.multipleInterface(Interface.self)
        }
    }
}

//MARK: - AntChannel
public struct AntChannel{
    public static func singleInterface<I:AnyObject>(_ interface:I.Type) -> AntChannelSingle<I> {
        let key = AnChannelUtil.getIKey(interface)
        return AnChannelUtil.createSingleC(key: key)
    }
    public static func multipleInterface<I:AnyObject>(_ interface:I.Type) -> AntChannelMultiple<I> {
        let key = AnChannelUtil.getIKey(interface)
        return AnChannelUtil.createMultipleC(key: key)
    }
}



/// 示例：⚠️⚠️⚠️⚠️⚠️⚠️
/// AntChannelInterface.single.register(xxx)  ❌
/// AntChannelInterface<Interface>.single.register(xxx)  ✅     OR    AntChannel.singleInterface(Interface.self).register(xxx)  ✅
