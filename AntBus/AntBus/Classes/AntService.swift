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

//MARK: - AntServiceMultiC
public class AntServiceMultiC<R:Any> {
    
    private var keyResponderContainer = Dictionary<String,Array<R>>.init()
    
    public func register(_ key:String, _ responder:R, where contains: (R) -> Bool){
        if let _ = keyResponderContainer[key] {
            if keyResponderContainer[key]!.contains(where: { r in
                return contains(r)
            }) {
                
                if AntServiceLog.shared.enabled {
                    let log = "multiC - \(#function):  ⚠️ contains(key:\(key)  responder:\(responder))"
                    AntServiceLog.handlerLog(.responder, log)
                }
                return
            }
            keyResponderContainer[key]?.append(responder)
        }else{
            keyResponderContainer[key] = [responder]
        }
        
        if AntServiceLog.shared.enabled {
            let log = "multiC - \(#function):  key:\(key)  responder:\(responder)"
            AntServiceLog.handlerLog(.responder, log)
        }
    }
    
    private func _register(_ key:String, _ responder:R){
        if let _ = keyResponderContainer[key] {
            keyResponderContainer[key]?.append(responder)
        }else{
            keyResponderContainer[key] = [responder]
        }
    }
    
    public func register(_ key:String, _ responder:R){
        _register(key, responder)
        
        if AntServiceLog.shared.enabled {
            let log = "multiC - \(#function):  key:\(key)  responder:\(responder)"
            AntServiceLog.handlerLog(.responder, log)
        }
    }
    
    public func register(_ keys:[String], _ responder:R){
        if AntServiceLog.shared.enabled {
            let log = "multiC - \(#function):  keys:\(keys)  responder:\(responder)"
            AntServiceLog.handlerLog(.responder, log)
        }
        for key in keys {
            _register(key, responder)
        }
    }
    
    public func register(_ key:String, _ responders:[R]){
        if AntServiceLog.shared.enabled {
            let log = "multiC - \(#function):  key:\(key) responders:\(String(describing: responders))"
            AntServiceLog.handlerLog(.responder, log)
        }
        for responder in responders {
            _register(key, responder)
        }
    }

    public func responders(_ key:String) -> [R]? {
        let responders = keyResponderContainer[key]
        
        if AntServiceLog.shared.enabled {
            let log = "multiC - \(#function):  key:\(key)  = \(String(describing: responders))"
            AntServiceLog.handlerLog(.responder, log)
        }
        return responders
    }
    
    public func responders() -> [R]? {
        let krContainers = keyResponderContainer.values
        let results = NSMutableSet.init()
        for krContainer in krContainers {
            for responder in krContainer {
                results.add(responder)
            }
        }
        
        if AntServiceLog.shared.enabled {
            let log = "multiC - \(#function)  = \(String(describing: results.allObjects))"
            AntServiceLog.handlerLog(.responder, log)
        }
        return results.allObjects as? [R]
    }
    
    public func remove(_ key:String, where shouldBeRemoved: (R) -> Bool) {
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

/// 示例:
/// AntServiceInterface.single.register(xxx)  ⚠️⚠️⚠️
/// AntServiceInterface<Interface>.single.register(xxx)  ✅     OR    AntService.singleInterface(Interface.self).register(xxx)  ✅
