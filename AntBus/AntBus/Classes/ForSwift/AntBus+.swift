import Foundation

public extension AntBus {
    enum plus {
        public static let data = AntBusData.shared
        public static let notification = AntBusNotification.shared
        public static let callback = AntBusCallback.shared
        public static let deallocHook = AntBusDeallocHook.shared
        public static let kvo = AntBusKVO.shared
        
        // weak -> object
        public struct container {
            public enum single {
                public static func all() -> NSDictionary {
                    return AntBusContainerSC.all()
                }
                
                // ------------------
                public static func register<T: AnyObject>(_ type: T.Type, object:T) {
                    let typeStr = AliasUtil.aliasForAny(T.self)
                    AntBusContainerSC.register(typeStr, object as AnyObject)
                }
                
                public static func object<T: AnyObject>(_ type: T.Type) -> T? {
                    let typeStr = AliasUtil.aliasForAny(T.self)
                    return AntBusContainerSC.object(typeStr) as? T
                }
                
                public static func remove<T: AnyObject>(_ type: T.Type) {
                    let typeStr = AliasUtil.aliasForAny(T.self)
                    AntBusContainerSC.remove(typeStr)
                }
            }
            
            public enum multiple {
                public static func all() -> NSDictionary {
                    return AntBusContainerMC.all()
                }
                
                public static func register<T: AnyObject>(_ type: T.Type, object: T, forKey key: String) {
                    let typeStr = AliasUtil.aliasForAny(T.self)
                    AntBusContainerMC.register(typeStr, key, object)
                }
                
                public static func register<T: AnyObject>(_ type: T.Type, objects: [T], forKey key: String) {
                    objects.forEach { object in
                        register(type, object: object, forKey: key)
                    }
                }
                
                public static func register<T: AnyObject>(_ type: T.Type, object: T, forKeys keys: [String]) {
                    keys.forEach { key in
                        register(type, object: object, forKey: key)
                    }
                }
                public static func objects<T: AnyObject>(_ type: T.Type, forKey key: String) -> [T]? {
                    let typeStr = AliasUtil.aliasForAny(T.self)
                    return AntBusContainerMC.objects(typeStr, key)?.compactMap{ $0 as? T}
                }
                
                public static func objects<T: AnyObject>(_ type: T.Type) -> [T]? {
                    let typeStr = AliasUtil.aliasForAny(T.self)
                    return AntBusContainerMC.objects(typeStr)?.compactMap{ $0 as? T}
                }
                
                public static func remove<T: AnyObject>(_ type: T.Type, object: T, forKey key: String) {
                    let typeStr = AliasUtil.aliasForAny(T.self)
                    AntBusContainerMC.remove(typeStr, key, object)
                }
                
                public static func remove<T: AnyObject>(_ type: T.Type, object: T, forKeys keys: [String]) {
                    keys.forEach { key in
                        remove(type, object: object, forKey: key)
                    }
                }
                
                public static func remove<T: AnyObject>(_ type: T.Type, objects: [T], forKey key: String) {
                    objects.forEach { object in
                        remove(type, object: object, forKey: key)
                    }
                }
                
                public static func remove<T: AnyObject>(_ type: T.Type, forKey key: String) {
                    let typeStr = AliasUtil.aliasForAny(T.self)
                    AntBusContainerMC.remove(typeStr, key)
                }
                
                public static func remove<T: AnyObject>(_ type: T.Type, forKeys keys: [String]) {
                    keys.forEach { key in
                        remove(type, forKey: key)
                    }
                }
                
                public static func remove<T: AnyObject>(_ type: T.Type) {
                    let typeStr = AliasUtil.aliasForAny(T.self)
                    AntBusContainerMC.remove(typeStr)
                }
            }
        }
    }
}

@objc public enum AntBusLogType: Int {
    case data,notification,kvo,callback,dealloc,container,service
}

public extension AntBus {
    
    enum log {

        public static func printLog(_ str: String) {
            print("✳️[AntBus] \(str)")
        }
        public static func setHandler(_ hdl:((_ type:AntBusLogType, _ log: String) -> Void)?) {
            handler = hdl
        }
        static var handler:((_ type:AntBusLogType, _ log: String) -> Void)?
    }
}
