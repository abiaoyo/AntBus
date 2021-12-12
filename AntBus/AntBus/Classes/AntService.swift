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

//MARK: - AntServiceMultiC
public class AntServiceMultiC<R:Any> {
    
    private var keyResponderContainer = Dictionary<String,Array<R>>.init()
    
    public func register(_ key:String, _ responder:R){
        if let _ = self.keyResponderContainer[key] {
            self.keyResponderContainer[key]?.append(responder)
        }else{
            var responders = Array<R>.init()
            responders.append(responder)
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
        return self.keyResponderContainer[key]
    }
    
    public func responders() -> [R]? {
        let krContainers = self.keyResponderContainer.values
        let results = NSMutableSet.init()
        for krContainer in krContainers {
            for responder in krContainer {
                results.add(responder)
            }
        }
        return results.allObjects as? [R]
    }
    
    public func remove(_ key:String, where shouldBeRemoved: (R) -> Bool) {
        self.keyResponderContainer[key]?.removeAll(where: { r in
            return shouldBeRemoved(r)
        })
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
    
    static func createSingleC<Interface:Any>(key:String) -> AntServiceSingleC<Interface>{
        var container = AntServiceUtil.singleCC[key]
        if container == nil {
            container = AntServiceSingleC<Interface>.init()
            AntServiceUtil.singleCC[key] = container
        }
        return container as! AntServiceSingleC<Interface>
    }
    
    static func createMultiC<Interface:Any>(key:String) -> AntServiceMultiC<Interface>{
        var container = AntServiceUtil.multiCC[key]
        if container == nil {
            container = AntServiceMultiC<Interface>.init()
            AntServiceUtil.multiCC[key] = container
        }
        return container as! AntServiceMultiC<Interface>
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
        let key = AntServiceUtil.getIKey(interface)
        return AntServiceUtil.createSingleC(key: key)
    }
    
    public static func multipleInterface<I:Any>(_ interface:I.Type) -> AntServiceMultiC<I> {
        let key = AntServiceUtil.getIKey(interface)
        return AntServiceUtil.createMultiC(key: key)
    }
}

/// 示例:
/// AntServiceInterface.single.register(xxx)  ⚠️⚠️⚠️
/// AntServiceInterface<Interface>.single.register(xxx)  ✅     OR    AntService.singleInterface(Interface.self).register(xxx)  ✅
