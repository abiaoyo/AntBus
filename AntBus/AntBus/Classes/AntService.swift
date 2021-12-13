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
        
        let log = "AntServiceSingleC(\(#line)) - \(#function):  responder:\(responder)"
        AntServiceLog.handlerLog(.Responder, log)
    }
    
    public func responder() -> R?{
        let log = "AntServiceSingleC(\(#line)) - \(#function)  =\(String(describing: _responder))"
        AntServiceLog.handlerLog(.Responder, log)

        return _responder;
    }
    
    public func remove(){
        _responder = nil
        
        let log = "AntServiceSingleC(\(#line)) - \(#function)"
        AntServiceLog.handlerLog(.Responder, log)
    }
}

//MARK: - AntServiceMultiC
public class AntServiceMultiC<R:Any> {
    
    private var keyResponderContainer = Dictionary<String,Array<R>>.init()
    
    public func register(_ key:String, _ responder:R, where contains: (R) -> Bool){
        if let _ = keyResponderContainer[key] {
            if keyResponderContainer[key]?.contains(where: { r in
                return contains(r)
            }) == false {
                keyResponderContainer[key]?.append(responder)
            }
        }else{
            keyResponderContainer[key] = [responder]
        }
        
        let log = "AntServiceMultiC(\(#line)) - \(#function):  key:\(key)  responder:\(responder)"
        AntServiceLog.handlerLog(.Responder, log)
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
        
        let log = "AntServiceMultiC(\(#line)) - \(#function):  key:\(key)  responder:\(responder)"
        AntServiceLog.handlerLog(.Responder, log)
    }
    
    public func register(_ keys:[String], _ responder:R){
        let log = "AntServiceMultiC(\(#line)) - \(#function):  keys:\(keys)  responder:\(responder)"
        AntServiceLog.handlerLog(.Responder, log)
        
        for key in keys {
            _register(key, responder)
        }
    }
    
    public func register(_ key:String, _ responders:[R]){
        
        let log = "AntServiceMultiC(\(#line)) - \(#function):  key:\(key) responders:\(String(describing: responders))"
        AntServiceLog.handlerLog(.Responder, log)
        
        for responder in responders {
            _register(key, responder)
        }
    }

    public func responders(_ key:String) -> [R]? {
        let responders = keyResponderContainer[key]
        
        let log = "AntServiceMultiC(\(#line)) - \(#function):  key:\(key) =:\(String(describing: responders))"
        AntServiceLog.handlerLog(.Responder, log)
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
        
        let log = "AntServiceMultiC(\(#line)) - \(#function) =\(String(describing: results.allObjects))"
        AntServiceLog.handlerLog(.Responder, log)
        return results.allObjects as? [R]
    }
    
    public func remove(_ key:String, where shouldBeRemoved: (R) -> Bool) {
        keyResponderContainer[key]?.removeAll(where: { r in
            return shouldBeRemoved(r)
        })
        
        let log = "AntServiceMultiC(\(#line)) - \(#function): key:\(key)"
        AntServiceLog.handlerLog(.Responder, log)
    }
    
    public func remove(_ keys:[String]) {
        for key in keys {
            keyResponderContainer.removeValue(forKey: key)
        }
        
        let log = "AntServiceMultiC(\(#line)) - \(#function): keys:\(keys)"
        AntServiceLog.handlerLog(.Responder, log)
    }

    public func remove(_ key:String){
        keyResponderContainer.removeValue(forKey: key)
        
        let log = "AntServiceMultiC(\(#line)) - \(#function):  key:\(key)"
        AntServiceLog.handlerLog(.Responder, log)
    }

    public func removeAll() {
        keyResponderContainer.removeAll()
        
        let log = "AntServiceMultiC(\(#line)) - \(#function)"
        AntServiceLog.handlerLog(.Responder, log)
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
        let key = AntServiceUtil.getIKey(interface) { logOptions, log in
            AntServiceLog.handlerLog(logOptions, log)
        }
        return AntServiceUtil.createSingleC(key: key)
    }
    
    public static func multipleInterface<I:Any>(_ interface:I.Type) -> AntServiceMultiC<I> {
        let key = AntServiceUtil.getIKey(interface) { logOptions, log in
            AntServiceLog.handlerLog(logOptions, log)
        }
        return AntServiceUtil.createMultiC(key: key)
    }
}

/// 示例:
/// AntServiceInterface.single.register(xxx)  ⚠️⚠️⚠️
/// AntServiceInterface<Interface>.single.register(xxx)  ✅     OR    AntService.singleInterface(Interface.self).register(xxx)  ✅
