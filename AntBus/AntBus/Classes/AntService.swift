//
//  AntService.swift
//  AntBus
//
//  Created by abiaoyo
//

import Foundation

public class AntSingleService<T:Any>{
    private var _responder:T?
    
    public func register(_ response:T){
        _responder = response
    }
    
    public func responder() -> T?{
        return _responder;
    }
    
    public func remove(){
        _responder = nil
    }
}

public class AntMultiService<T:Any> {
    private var keyContainer = Dictionary<String,Dictionary<String,T>>.init()
    
    private func getTypContainer(key:String, create:Bool) -> Dictionary<String,T>? {
        var typeContainer = self.keyContainer[key]
        if create && typeContainer == nil {
            typeContainer = Dictionary<String,T>.init()
        }
        return typeContainer
    }
    
    public func register(_ keys:[String], _ responder:T){
        let type = "\(responder.self)"
        for key in keys {
            var typeContainer = self.getTypContainer(key: key, create: true)!
            typeContainer.updateValue(responder, forKey: type)
            self.keyContainer.updateValue(typeContainer, forKey: key)
        }
    }
    
    public func register(_ key:String, _ responders:[T]){
        var typeContainer = self.getTypContainer(key: key, create: true)!
        for responder in responders {
            let type = "\(responder.self)"
            typeContainer.updateValue(responder, forKey: type)
        }
        self.keyContainer.updateValue(typeContainer, forKey: key)
    }

    public func responders(_ key:String) -> [T]? {
        if let typeContainer = self.getTypContainer(key: key, create: false) {
            return typeContainer.compactMap({ $0.value })
        }
        return nil
    }
    
    public func responders() -> [T]? {
        let typeContainers = self.keyContainer.map({$0.value})
        var results = Dictionary<String,T>.init()
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
    
    public func remove(_ key:String, responder:T){
        var typeContainer = self.getTypContainer(key: key, create: false)
        if typeContainer != nil{
            let type = "\(responder.self)"
            typeContainer!.removeValue(forKey: type)
            self.keyContainer.updateValue(typeContainer!, forKey: key)
        }
    }

    public func remove(_ keys:[String]) {
        for key in keys {
            self.keyContainer.removeValue(forKey: key)
        }
    }

    public func remove(_ key:String){
        self.keyContainer.removeValue(forKey: key)
    }

    public func removeAll() {
        self.keyContainer.removeAll()
    }
}



fileprivate struct AntServiceCache{
    static var singleC = Dictionary<String,AnyObject>.init()
    static var multiC = Dictionary<String,AnyObject>.init()
}

public struct AntService<T:Any>{
    
    public static var single:AntSingleService<T> {
        get {
            let key = "\(T.self)"
            var container = AntServiceCache.singleC[key]
            if container == nil {
                container = AntSingleService<T>.init()
                AntServiceCache.singleC[key] = container
            }
            return container as! AntSingleService<T>
        }
    }
    
    public static var multiple:AntMultiService<T> {
        get {
            let key = "\(T.self)"
            var container = AntServiceCache.multiC[key]
            if container == nil {
                container = AntMultiService<T>.init()
                AntServiceCache.multiC[key] = container
            }
            return container as! AntMultiService<T>
        }
    }
}
