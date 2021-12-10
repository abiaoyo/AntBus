//
//  AntChannel.swift
//  AntBus
//  Created by abiaoyo
//

import Foundation

//MARK: AntChannelSingle
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

//MARK: AntChannelMultiple
public class AntChannelMultiple<R:AnyObject> {
    //<Key,[AnyObject]>
    var container = NSMapTable<NSString,NSHashTable<R>>.strongToStrongObjects()
    
    private func getResponderSet(key:String) -> NSHashTable<R> {
        var responders = self.container.object(forKey: key as NSString)
        if responders == nil {
            responders = NSHashTable<R>.weakObjects()
            self.container.setObject(responders, forKey: key as NSString)
        }
        return responders!
    }
    
    public func register(_ key:String, _ responder:R) -> Void{
        self.getResponderSet(key: key).add(responder)
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
        let objects = self.container.object(forKey: key as NSString)
        return objects?.allObjects
    }
    
    public func responders() -> [R]? {
        var responders:[R]? = nil
        if let objects:[AnyObject] = self.container.objectEnumerator()?.allObjects.flatMap({ ($0 as! NSHashTable<AnyObject>).objectEnumerator().map{ $0 }}) as [AnyObject]? {
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
            if let objects = self.container.object(forKey: key as NSString) {
                objects.remove(responder)
            }
        }
    }
    
    public func remove(_ keys:[String]) -> Void {
        for key in keys {
            self.container.removeObject(forKey: key as NSString)
        }
    }
    
    public func remove(_ key:String,_ responder:R) -> Void{
        if let responders = self.container.object(forKey: key as NSString) {
            responders.remove(responder)
        }
    }
    
    public func remove(_ key:String) -> Void{
        self.container.removeObject(forKey: key as NSString)
    }
    
    public func removeAll() -> Void {
        self.container.removeAllObjects()
    }
}

/// 缓存
/// 仅管删除了key或响应，缓存将会残留Interface相关的容器
fileprivate struct AntServiceUtil{
    static var multiContainer = Dictionary<String,AnyObject>.init()
    static var singleContainer = Dictionary<String,AnyObject>.init()
    
    static func createSingleContainer<Interface:Any>(key:String) -> AntChannelSingle<Interface>{
        var container = AntServiceUtil.singleContainer[key]
        if container == nil {
            container = AntChannelSingle<Interface>.init()
            AntServiceUtil.singleContainer[key] = container
        }
        return container as! AntChannelSingle<Interface>
    }
    
    static func createMultipleContainer<Interface:Any>(key:String) -> AntChannelMultiple<Interface>{
        var container = AntServiceUtil.multiContainer[key]
        if container == nil {
            container = AntChannelMultiple<Interface>.init()
            AntServiceUtil.multiContainer[key] = container
        }
        return container as! AntChannelMultiple<Interface>
    }
}

/// AntChannel - 通道
/// AntChannel是弱引用，⚠️⚠️⚠️ 因为是弱引用 ，所以Interface注册用@objc的Protocol
/// AntService是强引用，AntService用于长驻内存的服务;
/// AntService用于不同模块的调用，AntChannel是临时内存的访问且用于模块内的调用
/// 通过协议绑定实例达到不同模块的访问（弱引用）
/// 存储结构：single <Interface,<Key,Responder>>   multiple <Interface,<Key,[Responder]>>
/// Interface：协议 / 接口，用来对功能分组，用Interface生成的字符key来存储同一个功能容器
/// Key：关键值，用来对功能下的响应进行分组
/// Responder：响应，实现Interface的地方
/// 示例：⚠️⚠️⚠️⚠️⚠️⚠️
/// AntChannelInterface.single.register(xxx)  ❌
/// AntChannelInterface<Interface>.single.register(xxx)  ✅     OR    AntChannel.singleInterface(Interface.Type).register(xxx)  ✅
public struct AntChannel{
    public static func singleInterface<I:AnyObject>(_ interface:I.Type) -> AntChannelSingle<I> {
        let key:String = "\(interface)"
        return AntServiceUtil.createSingleContainer(key: key)
    }
    public static func multipleInterface<I:AnyObject>(_ interface:I.Type) -> AntChannelMultiple<I> {
        let key:String = "\(interface)"
        return AntServiceUtil.createMultipleContainer(key: key)
    }
}

public struct AntChannelInterface<Interface:AnyObject>{
    public static var single:AntChannelSingle<Interface> {
        get {
            let key:String = "\(Interface.self)"
            return AntServiceUtil.createSingleContainer(key: key)
        }
    }
    public static var multiple:AntChannelMultiple<Interface> {
        get {
            let key:String = "\(Interface.self)"
            return AntServiceUtil.createMultipleContainer(key: key)
        }
    }
}
