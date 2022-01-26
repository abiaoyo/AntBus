//
//  AntService.swift
//  AntBus
//
//  Created by abiaoyo
//

import Foundation

/// MARK: AntServiceSingleCache
fileprivate class AntServiceSingleCache{
    static var container = Dictionary<String,Any>.init()
    static func register(_ aliasName:String,_ responder:Any) {
        self.container.updateValue(responder, forKey: aliasName)
    }
    static func responder(_ aliasName:String) -> Any?{
        return self.container[aliasName]
    }
    static func remove(_ aliasName:String){
        self.container.removeValue(forKey: aliasName)
    }
}

extension AntServiceSingleCache{
    public static func containerContent() -> Dictionary<String,Any> {
        return AntServiceSingleCache.container;
    }
}

/// MARK: AntServiceSingleC
public class AntServiceSingleC<I:Any> {
    public func register(_ responder:I){
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        AntServiceSingleCache.register(aliasName, responder)
    }
    public func responder() -> I?{
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        return AntServiceSingleCache.responder(aliasName) as? I
    }
    public func remove(){
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        AntServiceSingleCache.remove(aliasName)
    }
}

/// MARK: AntServiceResponder
public class AntServiceResponder{
    public var responder:Any!
    public init(_ responder:Any) {
        self.responder = responder
    }
}

/// MARK: AntServiceMultiCache
fileprivate class AntServiceMultiCache{
    /// <aliasName,<key,[responder]>>
    static var container = Dictionary<String,Dictionary<String,Array<AntServiceResponder>>>.init()
    
    static func register(_ aliasName:String, _ key:String, _ responder:AntServiceResponder){
        if let _ = container[aliasName] {
            if let _ = container[aliasName]![key] {
                container[aliasName]![key]?.append(responder)
            }else{
                container[aliasName]![key] = [responder]
            }
        }else{
            let responders = [responder]
            let keyContainers = [key:responders]
            container.updateValue(keyContainers, forKey: aliasName)
        }
    }
    
    static func responders(_ aliasName:String, _ key:String) -> [AntServiceResponder]? {
        return container[aliasName]?[key]
    }
    
    static func responders(_ aliasName:String)  -> [AntServiceResponder]? {
        let keyContainers = container[aliasName]
        let results = keyContainers?.flatMap({ $0.value })
        let uniqueResults = NSMutableSet.init(array: results ?? [])
        return uniqueResults.allObjects.compactMap({ $0 as? AntServiceResponder})
    }
    
    static func remove(_ aliasName:String, _ key:String, where shouldBeRemoved: (AntServiceResponder) -> Bool) {
        container[aliasName]?[key]?.removeAll(where: { r in
            return shouldBeRemoved(r)
        })
    }
    
    static func remove(_ aliasName:String, _ key:String){
        container[aliasName]?.removeValue(forKey: key)
    }
    
    static func removeAll(_ aliasName:String) {
        container.removeValue(forKey: aliasName)
    }
    
}

extension AntServiceMultiCache {
    public static func containerContent() -> Dictionary<String,Dictionary<String,Array<Any>>> {
        var container = Dictionary<String,Dictionary<String,Array<Any>>>.init()
        for key1 in AntServiceMultiCache.container.keys {
            var keyContainer = Dictionary<String,Array<Any>>.init()
            
            if let keyC = AntServiceMultiCache.container[key1] {
                for key2 in keyC.keys {
                    if let resps = keyC[key2]?.compactMap({ $0.responder }) {
                        keyContainer.updateValue(resps, forKey: key2)
                    }
                }
            }
            container.updateValue(keyContainer, forKey: key1)
        }
        return container
    }
}


/// MARK: AntServiceMultiC
public class AntServiceMultiC<I:Any> {
    
    public func register(_ key:String, _ responder:I) -> AntServiceResponder{
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        let resp = AntServiceResponder.init(responder)
        AntServiceMultiCache.register(aliasName, key, resp)
        return resp
    }
    
    @discardableResult
    public func register(_ keys:[String], _ responder:I) -> AntServiceResponder{
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        let resp = AntServiceResponder.init(responder)
        for key in keys {
            AntServiceMultiCache.register(aliasName, key, resp)
        }
        return resp
    }
    
    @discardableResult
    public func register(_ key:String, _ responders:[I]) -> [AntServiceResponder]{
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        var resps:[AntServiceResponder] = []
        for responder in responders {
            let resp = AntServiceResponder.init(responder)
            AntServiceMultiCache.register(aliasName, key, resp)
            resps.append(resp)
        }
        return resps
    }
    
    public func responders(_ key:String) -> [I]? {
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        var responders = AntServiceMultiCache.responders(aliasName, key)?.compactMap({ $0.responder as? I})
        
        if let _ = responders {
            responders = responders!.count > 0 ? responders : nil
        }
        return responders
    }
    
    public func responders() -> [I]? {
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        let results = AntServiceMultiCache.responders(aliasName)
        var responders = results?.compactMap({ $0.responder as? I})
        if let _ = responders {
            responders = responders!.count > 0 ? responders : nil
        }
        return responders
    }
    
    public func remove(_ key:String, where shouldBeRemoved: (AntServiceResponder) -> Bool) {
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        AntServiceMultiCache.remove(aliasName, key, where: shouldBeRemoved)
    }
    
    public func remove(_ keys:[String]) {
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        for key in keys {
            AntServiceMultiCache.remove(aliasName, key)
        }
    }
    
    public func remove(_ key:String){
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        AntServiceMultiCache.remove(aliasName, key)
    }
    
    public func removeAll() {
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        AntServiceMultiCache.removeAll(aliasName)
    }
}


/// AntService
public class AntServiceInterface<I:Any> {
    public static var single:AntServiceSingleC<I>{
        return AntServiceSingleC<I>.init()
    }
    public static var multiple:AntServiceMultiC<I>{
        return AntServiceMultiC<I>.init()
    }
}

extension AntServiceInterface{
    public static func singleContainer() -> Dictionary<String,Any> {
        return AntServiceSingleCache.containerContent();
    }
    
    public static func multiContainer() -> Dictionary<String,Dictionary<String,Array<Any>>> {
        return AntServiceMultiCache.containerContent()
    }
}

//MARK: - AntService
public struct AntService{
    public static func singleInterface<I:Any>(_ interface:I.Type) -> AntServiceSingleC<I> {
        return AntServiceSingleC<I>.init()
    }
    public static func multipleInterface<I:Any>(_ interface:I.Type) -> AntServiceMultiC<I> {
        return AntServiceMultiC<I>.init()
    }
}

extension AntService{
    public static func singleContainer() -> Dictionary<String,Any> {
        return AntServiceSingleCache.containerContent();
    }
    
    public static func multiContainer() -> Dictionary<String,Dictionary<String,Array<Any>>> {
        return AntServiceMultiCache.containerContent()
    }
}
