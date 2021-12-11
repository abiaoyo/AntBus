//
//  AntService.swift
//  AntBus
//
//  Created by abiaoyo
//

import Foundation

//MARK: - AntSingleC
public class AntSingleC<R:AnyObject>{
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

//MARK: - AntMultiC
public class AntMultiC<R:AnyObject> {
    
    private var keyResponderContainer = Dictionary<String,NSHashTable<R>>.init()
    
    public func register(_ key:String, _ responder:R){
        if let responders = self.keyResponderContainer[key] {
            responders.add(responder)
        }else{
            let responders = NSHashTable<R>.init(options: .strongMemory)
            responders.add(responder)
            self.keyResponderContainer[key] = responders
        }
    }
    
    public func register(_ keys:[String], _ responder:R){
        for key in keys {
            self.register(key, responder)
        }
    }
    
    public func register(_ key:String, _ responders:[R]){
        for responder in responders {
            self.register(key, responder)
        }
    }

    public func responders(_ key:String) -> [R]? {
        if let responders = self.keyResponderContainer[key] {
            return responders.allObjects
        }
        return nil
    }
    
    public func responders() -> [R]? {
        let krContainers = self.keyResponderContainer.map({$0.value})
        let results = NSMutableSet.init()
        for krContainer in krContainers {
            for responder in krContainer.allObjects {
                results.add(responder)
            }
        }
        return results.allObjects as? [R]
    }
    
    public func remove(_ key:String, responder:R){
        self.keyResponderContainer[key]?.remove(responder)
    }
    
    public func remove(_ keys:[String]) {
        for key in keys {
            self.keyResponderContainer.removeValue(forKey: key)
        }
    }

    public func remove(_ key:String){
        self.keyResponderContainer.removeValue(forKey: key)
    }

    public func removeAll() {
        self.keyResponderContainer.removeAll()
    }
}

//MARK: - AntServiceUtil
fileprivate struct AntServiceUtil{
    static var singleCC = Dictionary<String,AnyObject>.init()
    static var multiCC = Dictionary<String,AnyObject>.init()
    
    static func createSingleC<Interface:Any>(key:String) -> AntSingleC<Interface>{
        var container = AntServiceUtil.singleCC[key]
        if container == nil {
            container = AntSingleC<Interface>.init()
            AntServiceUtil.singleCC[key] = container
        }
        return container as! AntSingleC<Interface>
    }
    
    static func createMultiC<Interface:Any>(key:String) -> AntMultiC<Interface>{
        var container = AntServiceUtil.multiCC[key]
        if container == nil {
            container = AntMultiC<Interface>.init()
            AntServiceUtil.multiCC[key] = container
        }
        return container as! AntMultiC<Interface>
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

//MARK: - AntServiceInterface
public struct AntServiceInterface<Interface:AnyObject>{
    public static var single:AntSingleC<Interface> {
        get {
            let interface = Interface.self
            return AntService.singleInterface(interface)
        }
    }

    public static var multiple:AntMultiC<Interface> {
        get {
            let interface = Interface.self
            return AntService.multipleInterface(interface)
        }
    }
}

//MARK: - AntService
public struct AntService{
    public static func singleInterface<I:AnyObject>(_ interface:I.Type) -> AntSingleC<I> {
        let key = AntServiceUtil.getIKey(interface)
        return AntServiceUtil.createSingleC(key: key)
    }
    
    public static func multipleInterface<I:AnyObject>(_ interface:I.Type) -> AntMultiC<I> {
        let key = AntServiceUtil.getIKey(interface)
        return AntServiceUtil.createMultiC(key: key)
    }
}

/// 示例：⚠️⚠️⚠️⚠️⚠️⚠️
/// AntServiceInterface.single.register(xxx)  ❌
/// AntServiceInterface<Interface>.single.register(xxx)  ✅     OR    AntService.singleInterface(Interface.self).register(xxx)  ✅
