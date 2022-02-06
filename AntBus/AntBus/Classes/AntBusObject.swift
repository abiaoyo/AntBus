//
//  AntBusObject.swift
//  AntBus
//
//  Created by abiaoyo
//

import Foundation

fileprivate class AntBusObjectCache{
    static var toMap = NSMapTable<NSString,AnyObject>.weakToWeakObjects()
    static var ooMap = AntBus_WKMapTable<AnyObject,NSMutableDictionary>()
}

final public class AntBusObject<Object:AnyObject>{
    
    final public class Container<Object:AnyObject>{
        
        public func register(_ object:Object,_ owner:AnyObject){
            let key = DynamicAliasUtil.getAliasName(Object.self)
            AntBusObjectCache.toMap.setObject(owner, forKey: key as NSString)
            var objs = AntBusObjectCache.ooMap.value(forKey: owner)
            if objs == nil {
                objs = NSMutableDictionary.init()
                AntBusObjectCache.ooMap.setValue(objs, forKey: owner)
            }
            objs?.setValue(object, forKey: key)
        }
        
        public func object() -> Object?{
            let key = DynamicAliasUtil.getAliasName(Object.self)
            if let owner = AntBusObjectCache.toMap.object(forKey: key as NSString) {
                let objs = AntBusObjectCache.ooMap.value(forKey: owner)
                return objs?.value(forKey: key) as? Object
            }
            return nil
        }
        
        public func remove() {
            let key = DynamicAliasUtil.getAliasName(Object.self)
            if let owner = AntBusObjectCache.toMap.object(forKey: key as NSString) {
                let objs = AntBusObjectCache.ooMap.value(forKey: owner)
                objs?.removeObject(forKey: key)
            }
        }
    }
    
    public static var shared:Container<Object>{
        return Container<Object>.init()
    }
}


/*
 AntBusObject<Object>.shared.register(obj,owner)
 AntBusObject<Object>.shared.object()
 AntBusObject<Object>.shared.remove()
 
 */
