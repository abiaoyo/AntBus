//
//  AntService.swift
//  AntBus
//
//  Created by abiaoyo
//

import Foundation

//MARK: - AntServiceSingleC
public class AntServiceSingleC<R:Any>{
    private var _responder:R?
    
    public func register(_ responder:R){
        _responder = responder
        
        if AntServiceLog.shared.enabled {
            let log = "singleC - \(#function):  responder:\(responder)"
            AntServiceLog.handlerLog(.responder, log)
        }
    }
    
    public func responder() -> R?{
        
        if AntServiceLog.shared.enabled {
            let log = "singleC - \(#function)  = \(String(describing: _responder))"
            AntServiceLog.handlerLog(.responder, log)
        }
        return _responder;
    }
    
    public func remove(){
        _responder = nil
        
        if AntServiceLog.shared.enabled {
            let log = "singleC - \(#function)"
            AntServiceLog.handlerLog(.responder, log)
        }
    }
}

public class AntServiceResponder<R:Any>{
    public var responder:R!
    public init(_ responder:R) {
        self.responder = responder
    }
}

//MARK: - AntServiceMultiC
public class AntServiceMultiC<R:Any> {
    
    private var keyResponderContainer = Dictionary<String,Array<AntServiceResponder<R>>>.init()
    
    private func _register(_ key:String, _ responder:AntServiceResponder<R>){
        if let _ = keyResponderContainer[key] {
            keyResponderContainer[key]?.append(responder)
        }else{
            keyResponderContainer[key] = [responder]
        }
    }
    
    @discardableResult
    public func register(_ key:String, _ responder:R) -> AntServiceResponder<R>{
        let resp = AntServiceResponder<R>.init(responder)
        _register(key, resp)
        
        if AntServiceLog.shared.enabled {
            let log = "multiC - \(#function):  key:\(key)  responder:\(responder)"
            AntServiceLog.handlerLog(.responder, log)
        }
        return resp
    }
    
    @discardableResult
    public func register(_ keys:[String], _ responder:R) -> AntServiceResponder<R>{
        let resp = AntServiceResponder<R>.init(responder)
        for key in keys {
            _register(key, resp)
        }
        
        if AntServiceLog.shared.enabled {
            let log = "multiC - \(#function):  keys:\(keys)  responder:\(responder)"
            AntServiceLog.handlerLog(.responder, log)
        }
        return resp
    }
    
    @discardableResult
    public func register(_ key:String, _ responders:[R]) -> [AntServiceResponder<R>]{
        if AntServiceLog.shared.enabled {
            let log = "multiC - \(#function):  key:\(key) responders:\(String(describing: responders))"
            AntServiceLog.handlerLog(.responder, log)
        }
        var resps:[AntServiceResponder<R>] = []
        for responder in responders {
            let resp = AntServiceResponder<R>.init(responder)
            _register(key, resp)
            resps.append(resp)
        }
        return resps
    }

    public func responders(_ key:String) -> [R]? {
        let responders = keyResponderContainer[key]?.compactMap({ $0.responder })
        if AntServiceLog.shared.enabled {
            let log = "multiC - \(#function):  key:\(key)  = \(String(describing: responders))"
            AntServiceLog.handlerLog(.responder, log)
        }
        return responders
    }
    
    public func responders() -> [R]? {
        let results = keyResponderContainer.flatMap({ $0.value })
        let uniqueResults = NSMutableSet.init(array: results)
        let responders = uniqueResults.allObjects.compactMap({ ($0 as! AntServiceResponder<R>).responder })
        
        if AntServiceLog.shared.enabled {
            let log = "multiC - \(#function)  = \(String(describing: responders))"
            AntServiceLog.handlerLog(.responder, log)
        }
        return responders.count > 0 ? responders : nil
    }
    
    public func remove(_ key:String, where shouldBeRemoved: (AntServiceResponder<R>) -> Bool) {
        keyResponderContainer[key]?.removeAll(where: { r in
            return shouldBeRemoved(r)
        })
        
        if AntServiceLog.shared.enabled {
            let log = "multiC - \(#function): key:\(key)"
            AntServiceLog.handlerLog(.responder, log)
        }
    }
    
    public func remove(_ keys:[String]) {
        for key in keys {
            keyResponderContainer.removeValue(forKey: key)
        }
        
        if AntServiceLog.shared.enabled {
            let log = "multiC - \(#function): keys:\(keys)"
            AntServiceLog.handlerLog(.responder, log)
        }
    }

    public func remove(_ key:String){
        keyResponderContainer.removeValue(forKey: key)
        
        if AntServiceLog.shared.enabled {
            let log = "multiC - \(#function):  key:\(key)"
            AntServiceLog.handlerLog(.responder, log)
        }
    }

    public func removeAll() {
        keyResponderContainer.removeAll()
        
        if AntServiceLog.shared.enabled {
            let log = "multiC - \(#function)"
            AntServiceLog.handlerLog(.responder, log)
        }
    }
}

//MARK: - AntServiceInterface
public struct AntServiceInterface<I:Any>{
    
    public static var single:AntServiceSingleC<I> {
        get {
            return AntService.singleInterface(I.self)
        }
    }
    public static var multiple:AntServiceMultiC<I> {
        get {
            return AntService.multipleInterface(I.self)
        }
    }
}

//MARK: - AntService
public struct AntService{
    public static func singleInterface<I:Any>(_ interface:I.Type) -> AntServiceSingleC<I> {
        let aliasName = AntServiceCacheUtil.getAliasName(interface) { logOptions, log in
            AntServiceLog.handlerLog(logOptions, log)
        }
        return AntServiceCacheUtil.createSingleC(aliasName)
    }
    
    public static func multipleInterface<I:Any>(_ interface:I.Type) -> AntServiceMultiC<I> {
        let aliasName = AntServiceCacheUtil.getAliasName(interface) { logOptions, log in
            AntServiceLog.handlerLog(logOptions, log)
        }
        return AntServiceCacheUtil.createMultiC(aliasName)
    }
}
