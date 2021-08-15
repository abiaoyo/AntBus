//
//  AntBus.swift
//  AntBus
//  Created by abiaoyo
//

import Foundation

//MARK: AntBusSingle
public class AntBusSingle<T:NSObjectProtocol> {
    //<Key,AnyObject>
    var container = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    
    public func register(_ responder:T) -> Void{
        let key:String = "\(T.self)"
        self.container.setObject(responder, forKey: key as NSString)
    }
    public func responder() -> T?{
        let key:String = "\(T.self)"
        return self.container.object(forKey: key as NSString) as? T
    }
    public func remove() -> Void{
        let key:String = "\(T.self)"
        self.container.removeObject(forKey: key as NSString)
    }
}

//MARK: AntBusMulti
public class AntBusMulti<T:NSObjectProtocol> {
    //<Key,[AnyObject]>
    var container = NSMapTable<NSString,NSHashTable<T>>.strongToStrongObjects()
    
    private func getResponderSet(key:String) -> NSHashTable<T> {
        var responders = self.container.object(forKey: key as NSString)
        if responders == nil {
            responders = NSHashTable<T>.weakObjects()
            self.container.setObject(responders, forKey: key as NSString)
        }
        return responders!
    }
    
    public func register(_ keys:[String], _ responder:T) -> Void{
        for key in keys {
            self.getResponderSet(key: key).add(responder)
        }
    }
    
    public func register(_ key:String, _ responders:[T]) -> Void{
        let responderSet = self.getResponderSet(key: key)
        for responder in responders {
            responderSet.add(responder)
        }
    }

    @discardableResult
    public func responders(_ key:String) -> [T]? {
        let objects = self.container.object(forKey: key as NSString)
        return objects?.allObjects
    }
    
    @discardableResult
    public func responders() -> [T]? {
        var responders:[T]? = nil
        if let objects:[AnyObject] = self.container.objectEnumerator()?.allObjects.flatMap({ ($0 as! NSHashTable<AnyObject>).objectEnumerator().map{ $0 }}) as [AnyObject]? {
            let resultSet = NSHashTable<T>.init()
            for object in objects {
                resultSet.add(object as? T)
            }
            responders = resultSet.allObjects
        }
        return responders
    }
    
    public func remove(_ keys:[String],_ responder:T) -> Void {
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
    
    public func remove(_ key:String,_ responder:T) -> Void{
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

fileprivate struct AntBusCache{
    static var multiContainer = Dictionary<String,AnyObject>.init()
    static var singleContainer = Dictionary<String,AnyObject>.init()
}

/// AntBus
public class AntBus<T>{
    
}

//MARK: AntBus extension
extension AntBus where T:NSObjectProtocol{
    public static var single:AntBusSingle<T> {
        get {
            let key:String = "\(T.self)"
            guard let container = AntBusCache.singleContainer[key] else {
                let container = AntBusSingle<T>.init()
                AntBusCache.singleContainer[key] = container
                return container
            }
            return container as! AntBusSingle<T>
        }
    }
    public static var multi:AntBusMulti<T> {
        get {
            let key:String = "\(T.self)"
            guard let multiContainer = AntBusCache.multiContainer[key] else {
                let multiContainer = AntBusMulti<T>.init()
                AntBusCache.multiContainer[key] = multiContainer
                return multiContainer
            }
            return multiContainer as! AntBusMulti<T>
        }
    }
}

