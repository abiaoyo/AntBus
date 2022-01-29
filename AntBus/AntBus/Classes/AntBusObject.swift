//
//  AntBusObject.swift
//  AntBus
//
//  Created by abiaoyo
//

import Foundation

fileprivate class AntBusObjectCache{
    static var typeOwnerMap = NSMapTable<AnyObject,AnyObject>.strongToWeakObjects()
    static var ownerObjectMap = NSMapTable<AnyObject,AnyObject>.weakToStrongObjects()
}

public class AntBusObjectC<Object:AnyObject>{
    
    public func register(_ object:Object, owner:AnyObject){
        AntBusObjectCache.typeOwnerMap.setObject(owner, forKey: Object.self)
        AntBusObjectCache.ownerObjectMap.setObject(object, forKey: owner)
    }
    
    public func object() -> Object?{
        if let owner = AntBusObjectCache.typeOwnerMap.object(forKey: Object.self) {
            return AntBusObjectCache.ownerObjectMap.object(forKey: owner) as? Object
        }
        return nil
    }
    
    public func remove() {
        if let owner = AntBusObjectCache.typeOwnerMap.object(forKey: Object.self) {
            AntBusObjectCache.ownerObjectMap.removeObject(forKey: owner)
        }
        AntBusObjectCache.typeOwnerMap.removeObject(forKey: Object.self)
    }
    
    public func removeInvalid() {
        let types = AntBusObjectCache.typeOwnerMap.keyEnumerator().allObjects.compactMap({ $0 as AnyObject?})
        for type in types {
            guard let _ = AntBusObjectCache.ownerObjectMap.object(forKey: type) else {
                AntBusObjectCache.typeOwnerMap.removeObject(forKey: type)
                return
            }
        }
    }
}

public class AntBusObject<Object:AnyObject>{
    public static var shared:AntBusObjectC<Object>{
        return AntBusObjectC<Object>.init()
    }
}
