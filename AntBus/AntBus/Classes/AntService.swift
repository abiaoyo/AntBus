//
//  AntService.swift
//  AntBus
//
//  Created by abiaoyo
//

import Foundation

/// 单个响应
public class AntSingleContainer<R:Any>{
    private var _responder:R?
    
    public func register(_ response:R){
        _responder = response
    }
    
    public func responder() -> R?{
        return _responder;
    }
    
    public func remove(){
        _responder = nil
    }
}

/// 多个响应
public class AntMultiContainer<R:Any> {
    
    private var keyContainer = Dictionary<String,Dictionary<String,R>>.init()
    
    private func getTypContainer(key:String, create:Bool) -> Dictionary<String,R>? {
        var typeContainer = self.keyContainer[key]
        if create && typeContainer == nil {
            typeContainer = Dictionary<String,R>.init()
        }
        return typeContainer
    }
    
    /// 注册 keys 到响应
    /// 注意：key下R.Type同类型的会覆盖上一个
    public func register(_ keys:[String], _ responder:R){
        let type = "\(responder.self)"
        for key in keys {
            var typeContainer = self.getTypContainer(key: key, create: true)!
            typeContainer.updateValue(responder, forKey: type)
            self.keyContainer.updateValue(typeContainer, forKey: key)
        }
    }
    
    /// 注册key相关的响应组
    /// 注意：key下R.Type同类型的会覆盖上一个
    public func register(_ key:String, _ responders:[R]){
        var typeContainer = self.getTypContainer(key: key, create: true)!
        for responder in responders {
            let type = "\(responder.self)"
            typeContainer.updateValue(responder, forKey: type)
        }
        self.keyContainer.updateValue(typeContainer, forKey: key)
    }

    /// 获取key相关的响应
    public func responders(_ key:String) -> [R]? {
        if let typeContainer = self.getTypContainer(key: key, create: false) {
            return typeContainer.compactMap({ $0.value })
        }
        return nil
    }
    
    /// 获取所有响应
    public func responders() -> [R]? {
        let typeContainers = self.keyContainer.map({$0.value})
        var results = Dictionary<String,R>.init()
        for typeContainer in typeContainers {
            for key in typeContainer.keys {
                if let value = typeContainer[key] {
                    results.updateValue(value, forKey: key)
                }
            }
        }
        if results.count == 0{
            return nil
        }
        return results.compactMap({$0.value})
    }
    
    /// 移除key相关的R.Type的响应
    public func remove(_ key:String, responder:R){
        var typeContainer = self.getTypContainer(key: key, create: false)
        if typeContainer != nil{
            let type = "\(responder.self)"
            typeContainer!.removeValue(forKey: type)
            self.keyContainer.updateValue(typeContainer!, forKey: key)
        }
    }
    
    /// 移除keys相关的响应
    public func remove(_ keys:[String]) {
        for key in keys {
            self.keyContainer.removeValue(forKey: key)
        }
    }

    /// 移除key相关的所有响应
    public func remove(_ key:String){
        self.keyContainer.removeValue(forKey: key)
    }

    /// 移除所有响应
    public func removeAll() {
        self.keyContainer.removeAll()
    }
}

/// 缓存
/// 仅管删除了key或响应，缓存将会残留Interface相关的容器，不过这不是问题; 因为Service 本来就是要一直存在的，所以正常情况不会去调用移除
fileprivate struct AntServiceCache{
    static var singleC = Dictionary<String,AnyObject>.init()
    static var multiC = Dictionary<String,AnyObject>.init()
    
    static func createSingleContainer<Interface:Any>(key:String) -> AntSingleContainer<Interface>{
        var container = AntServiceCache.singleC[key]
        if container == nil {
            container = AntSingleContainer<Interface>.init()
            AntServiceCache.singleC[key] = container
        }
        return container as! AntSingleContainer<Interface>
    }
    
    static func createMultipleContainer<Interface:Any>(key:String) -> AntMultiContainer<Interface>{
        var container = AntServiceCache.multiC[key]
        if container == nil {
            container = AntMultiContainer<Interface>.init()
            AntServiceCache.multiC[key] = container
        }
        return container as! AntMultiContainer<Interface>
    }
}

/// AntService - 服务
/// AntService是强引用，AntService用于长驻内存的服务;
/// AntChannel是弱引用，⚠️⚠️⚠️ 因为是弱引用 ，所以Interface注册用@objc的Protocol
/// AntService用于不同模块的调用，AntChannel是临时内存的访问且用于模块内的调用
/// 通过协议绑定实例达到不同模块的访问（强引用）
/// 存储结构：single <Interface,<Key,Responder>>        multiple <Interface,<Key,<R.Type,Responder>>>
/// Interface：协议 / 接口，用来对功能分组，用Interface生成的字符key来存储同一个功能容器
/// Key：关键值，用来对功能下的响应进行分组
/// R.Type：用来作为响应Responder的关键值     ⚠️⚠️  注意：R.Type相同时会覆盖上一次响应，所以项目中不要有相同的R.Type  ⚠️⚠️
/// Responder：响应，实现Interface的地方
/// 示例：⚠️⚠️⚠️⚠️⚠️⚠️
/// AntServiceInterface.single.register(xxx)  ❌
/// AntServiceInterface<Interface>.single.register(xxx)  ✅     OR    AntService.singleInterface(Interface.Type).register(xxx)  ✅
public struct AntServiceInterface<Interface:Any>{
    public static var single:AntSingleContainer<Interface> {
        get {
            let key = "\(Interface.self)"
            return AntServiceCache.createSingleContainer(key: key)
        }
    }

    public static var multiple:AntMultiContainer<Interface> {
        get {
            let key = "\(Interface.self)"
            return AntServiceCache.createMultipleContainer(key: key)
        }
    }
}

public struct AntService{
    public static func singleInterface<I:Any>(_ interface:I.Type) -> AntSingleContainer<I> {
        let key:String = "\(interface)"
        return AntServiceCache.createSingleContainer(key: key)
    }
    public static func multipleInterface<I:Any>(_ interface:I.Type) -> AntMultiContainer<I> {
        let key:String = "\(interface)"
        return AntServiceCache.createMultipleContainer(key: key)
    }
}
