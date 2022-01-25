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

/// MARK: AntServiceSingleC
public class AntServiceSingleC<I:Any> {
    public func register(_ responder:I){
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        AntServiceSingleCache.register(aliasName, responder)
        
        if AntServiceLog.enabled {
            let log = "singleC - \(aliasName) \(#function):  responder:\(responder)"
            AntServiceLog.handlerLog(.responder, log)
        }
    }
    public func responder() -> I?{
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        let responder = AntServiceSingleCache.responder(aliasName) as? I
        
        if AntServiceLog.enabled {
            let log = "singleC - \(aliasName) \(#function):  responder:\(responder)"
            AntServiceLog.handlerLog(.responder, log)
        }
        return responder
    }
    public func remove(){
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        AntServiceSingleCache.remove(aliasName)
        
        if AntServiceLog.enabled {
            let log = "singleC - \(aliasName) \(#function):  "
            AntServiceLog.handlerLog(.responder, log)
        }
    }
}

public class AntServiceResponder{
    public var responder:Any!
    public init(_ responder:Any) {
        self.responder = responder
    }
}

/// MARK: AntServiceMultiCache
fileprivate class AntServiceMultiCache{
    /// <aliasName,<key,[responder]>>
    private static var container = Dictionary<String,Dictionary<String,Array<AntServiceResponder>>>.init()
    
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
        let responders = uniqueResults.allObjects.compactMap({ $0 as? AntServiceResponder})
        return responders
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


/// MARK: AntServiceMultiC
public class AntServiceMultiC<I:Any> {
    
    public func register(_ key:String, _ responder:I) -> AntServiceResponder{
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        let resp = AntServiceResponder.init(responder)
        AntServiceMultiCache.register(aliasName, key, resp)
        
        if AntServiceLog.enabled {
            let log = "multiC - \(aliasName) \(#function):  key:\(key)  responder:\(responder)"
            AntServiceLog.handlerLog(.responder, log)
        }
        
        return resp
    }
    
    @discardableResult
    public func register(_ keys:[String], _ responder:I) -> AntServiceResponder{
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        let resp = AntServiceResponder.init(responder)
        for key in keys {
            AntServiceMultiCache.register(aliasName, key, resp)
        }
        if AntServiceLog.enabled {
            let log = "multiC - \(aliasName) \(#function):  keys:\(keys)  responder:\(responder)"
            AntServiceLog.handlerLog(.responder, log)
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
        if AntServiceLog.enabled {
            let log = "multiC - \(aliasName) \(#function):  key:\(key) responders:\(String(describing: responders))"
            AntServiceLog.handlerLog(.responder, log)
        }
        return resps
    }
    
    public func responders(_ key:String) -> [I]? {
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        var responders = AntServiceMultiCache.responders(aliasName, key)?.compactMap({ $0.responder as? I})
        
        if let _ = responders {
            responders = responders!.count > 0 ? responders : nil
        }
        
        if AntServiceLog.enabled {
            let log = "multiC - \(aliasName) \(#function):  key:\(key)  = \(String(describing: responders))"
            AntServiceLog.handlerLog(.responder, log)
        }
        
        return responders
    }
    
    public func responders() -> [I]? {
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        let uniqueResults = AntServiceMultiCache.responders(aliasName)
        var responders = uniqueResults?.compactMap({ $0.responder as? I})
        if let _ = responders {
            responders = responders!.count > 0 ? responders : nil
        }
        
        if AntServiceLog.enabled {
            let log = "multiC - \(aliasName) \(#function)  = \(String(describing: responders))"
            AntServiceLog.handlerLog(.responder, log)
        }
        return responders
    }
    
    public func remove(_ key:String, where shouldBeRemoved: (AntServiceResponder) -> Bool) {
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        AntServiceMultiCache.remove(aliasName, key, where: shouldBeRemoved)
        
        if AntServiceLog.enabled {
            let log = "multiC - \(aliasName) \(#function): key:\(key)"
            AntServiceLog.handlerLog(.responder, log)
        }
    }
    
    public func remove(_ keys:[String]) {
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        for key in keys {
            AntServiceMultiCache.remove(aliasName, key)
        }
        if AntServiceLog.enabled {
            let log = "multiC - \(aliasName) \(#function): keys:\(keys)"
            AntServiceLog.handlerLog(.responder, log)
        }
    }
    
    public func remove(_ key:String){
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        AntServiceMultiCache.remove(aliasName, key)
        
        if AntServiceLog.enabled {
            let log = "multiC - \(aliasName) \(#function):  key:\(key)"
            AntServiceLog.handlerLog(.responder, log)
        }
    }
    
    public func removeAll() {
        let aliasName = DynamicAliasUtil.getAliasName(I.self)
        AntServiceMultiCache.removeAll(aliasName)
        
        if AntServiceLog.enabled {
            let log = "multiC - \(aliasName) \(#function)"
            AntServiceLog.handlerLog(.responder, log)
        }
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

//MARK: - AntService
public struct AntService{
    public static func singleInterface<I:Any>(_ interface:I.Type) -> AntServiceSingleC<I> {
        return AntServiceSingleC<I>.init()
    }
    
    public static func multipleInterface<I:Any>(_ interface:I.Type) -> AntServiceMultiC<I> {
        return AntServiceMultiC<I>.init()
    }
}
