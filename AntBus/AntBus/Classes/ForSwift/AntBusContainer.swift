import Foundation

// Single
struct AntBusContainerSC {
    static let objContainer = SafeMapTable<NSString, AnyObject>.strongToWeak()
    
    public static func all() -> NSDictionary {
        return objContainer.dictionaryRepresentation()
    }
    
    static func register(_ type: String, _ object: AnyObject) {
        
        AntBus.log.handler?(.container, "AntBus.plus.container.single.register:  \(type) \t \(object)")
        
        objContainer.setObject(object, forKey: type as NSString)
        AntBusDeallocHook.shared.install(for: object, propertyKey: "AntBusContainerSC", handlerKey: type) { hkeys in
            for hkey in hkeys {
                guard let _ = objContainer.object(forKey: hkey as NSString) else {
                    objContainer.removeObject(forKey: hkey as NSString)
                    break
                }
            }
        }
    }
    
    static func object(_ type: String) -> AnyObject? {
        let rs = objContainer.object(forKey: type as NSString)

        AntBus.log.handler?(.container, "AntBus.plus.container.single.object:  \(type) \t \(String(describing: rs))")
        
        return rs
    }
    
    static func remove(_ type: String) {
        
        AntBus.log.handler?(.container, "AntBus.plus.container.single.remove:  \(type)")
        
        objContainer.removeObject(forKey: type as NSString)
    }
    
    static func removeAll() {
        
        AntBus.log.handler?(.container, "AntBus.plus.container.single.removeAll")
        
        objContainer.removeAllObjects()
    }
}

// Multi
enum AntBusContainerMC {
    
    static let objContainer = SafeMutableDictionary()
    
    public static func all() -> NSDictionary {
        return objContainer.toDictionary()
    }
    
    static func register(_ type: String, _ key: String, _ object: AnyObject) {
        
        AntBus.log.handler?(.container, "AntBus.plus.container.multiple.register:  \(type) \t \(key) \t \(object)")
        
        let typeContainer = (objContainer[type] as? SafeMutableDictionary) ?? SafeMutableDictionary()
        objContainer[type] = typeContainer
        
        let keyContainer = (typeContainer[key] as? SafeHashTable<AnyObject>) ?? SafeHashTable<AnyObject>.weakObjects()
        keyContainer.add(object)
        
        typeContainer[key] = keyContainer
        
        AntBusDeallocHook.shared.install(for: object, propertyKey: "AntBusContainerMC", handlerKey: key) { hkeys in
            if let typeContainer = objContainer[type] as? SafeMutableDictionary {
                for hkey in hkeys {
                    if let keyContainer = typeContainer[hkey] as? SafeHashTable<AnyObject> {
                        if keyContainer.count == 0 {
                            typeContainer.removeObject(forKey: hkey)
                        }
                    } else {
                        typeContainer.removeObject(forKey: hkey)
                    }
                }
                if typeContainer.allValues.count == 0 {
                    objContainer.removeObject(forKey: type)
                }
            }
        }
    }
    
    static func objects(_ type: String, _ key: String) -> [AnyObject]? {
        let rs = ((objContainer[type] as? SafeMutableDictionary)?[key] as? SafeHashTable<AnyObject>)?.allObjects
        
        AntBus.log.handler?(.container, "AntBus.plus.container.multiple.objects:  \(type) \t \(key) \t \(String(describing: rs))")
        
        return rs
    }
    
    static func objects(_ type: String) -> [AnyObject]? {
        var rs: [AnyObject]?
        
        if let typeContainer = objContainer[type] as? SafeMutableDictionary {
            let mset = NSMutableSet()
            typeContainer.allKeys.forEach { key in
                if let keyContainer = typeContainer[key] as? SafeHashTable<AnyObject> {
                    mset.addObjects(from: keyContainer.allObjects)
                }
            }
            rs = mset.allObjects.compactMap { $0 as AnyObject }
        }
        
        AntBus.log.handler?(.container, "AntBus.plus.container.multiple.objects:  \(type) \t \(String(describing: rs))")
        
        return rs
    }
    
    static func remove(_ type: String, _ key: String, _ object: AnyObject) {
        
        AntBus.log.handler?(.container, "AntBus.plus.container.multiple.remove:  \(type) \t \(key) \t \(object)")
        
        ((objContainer[type] as? SafeMutableDictionary)?[key] as? SafeHashTable<AnyObject>)?.remove(object)
    }
    
    static func remove(_ type: String, _ keys: [String], _ object: AnyObject) {
        keys.forEach { key in
            remove(type, key, object)
        }
    }
    
    static func remove(_ type: String, _ key: String, _ objects: [AnyObject]) {
        objects.forEach { object in
            remove(type, key, object)
        }
    }
    
    static func remove(_ type: String, _ key: String) {
        
        AntBus.log.handler?(.container, "AntBus.plus.container.multiple.remove:  \(type) \t \(key)")
        
        (objContainer[type] as? SafeMutableDictionary)?.removeObject(forKey: key)
    }
    
    static func remove(_ type: String, _ keys: [String]) {
        keys.forEach { key in
            remove(type, key)
        }
    }
    
    static func remove(_ type: String) {
        
        AntBus.log.handler?(.container, "AntBus.plus.container.multiple.remove:  \(type)")
        
        objContainer.removeObject(forKey: type)
    }
}
