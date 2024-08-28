import Foundation

@objcMembers
public class AntBusServiceSingleConfig: NSObject {
    var serviceName: String = ""     //服务名
    var serviceObj: Any?             //服务对象
    var createService: (() -> Any)!  //创建服务
    var cache: Bool = false  //是否缓存
    var clazz:Any?  //服务对象类
    
    public override var description: String {
        return "[\(serviceName) | \(clazz ?? "") | cache:\(cache)]"
    }
    
    public static func createForSwift<T: Any>(_ service: T.Type, cache: Bool, createService: @escaping () -> T) -> AntBusServiceSingleConfig {
        let config = AntBusServiceSingleConfig()
        config.serviceName = AliasUtil.aliasForAny(service)
        config.createService = createService
        config.cache = cache
        return config
    }
    
//    public static func createForObjc(clazz: AnyObject.Type, cache: Bool, createService: @escaping () -> AnyObject) -> AntBusServiceSingleConfig {
//        let config = AntBusServiceSingleConfig()
//        config.serviceName = AliasUtil.aliasForAnyObject(clazz)
//        config.createService = createService
//        config.cache = cache
//        return config
//    }
    
    public static func createForObjc(service: Protocol, cache: Bool, createService: @escaping () -> AnyObject) -> AntBusServiceSingleConfig {
        let config = AntBusServiceSingleConfig()
        config.serviceName = AliasUtil.aliasForInterface(service)
        config.createService = createService
        config.cache = cache
        return config
    }
}

@objcMembers
public class AntBusServiceMultipleConfig: NSObject {
    var serviceName: String = ""     //服务名
    var keys: Set<String> = []       //keys
    var createService: (() -> Any)!  //创建服务
    var clazz:Any?  //服务对象类
    
    public override var description: String {
        return "[\(serviceName) | \(clazz ?? "") | keys:\(keys)]"
    }
    
    public static func createForSwift<T: Any>(_ service: T.Type, keys: Set<String>, createService: @escaping () -> T) -> AntBusServiceMultipleConfig {
        let config = AntBusServiceMultipleConfig()
        config.serviceName = AliasUtil.aliasForAny(service)
        config.createService = createService
        config.keys = keys
        return config
    }
    
//    public static func createForObjc(clazz: AnyObject.Type, keys: [String], createService: @escaping () -> AnyObject) -> AntBusServiceMultipleConfig {
//        let keySet = Set(keys)
//        let config = AntBusServiceMultipleConfig()
//        config.serviceName = AliasUtil.aliasForAnyObject(clazz)
//        config.createService = createService
//        config.keys = keySet
//        return config
//    }

    public static func createForObjc(service: Protocol, keys: [String], createService: @escaping () -> AnyObject) -> AntBusServiceMultipleConfig {
        let keySet = Set(keys)
        let config = AntBusServiceMultipleConfig()
        config.serviceName = AliasUtil.aliasForInterface(service)
        config.createService = createService
        config.keys = keySet
        return config
    }
}

@objcMembers
public class AntBusServiceMultipleUpdateConfig: NSObject {
    var serviceName: String = ""
    var addKeys: Set<String> = []
    var deleteKeys: Set<String> = []
    
    public static func createForSwift<T: Any>(_ service: T.Type, addKeys: Set<String>, deleteKeys: Set<String>) -> AntBusServiceMultipleUpdateConfig {
        let config = AntBusServiceMultipleUpdateConfig()
        config.serviceName = AliasUtil.aliasForAny(service)
        config.addKeys = addKeys
        config.deleteKeys = deleteKeys
        return config
    }
    
//    public static func createForObjc(clazz: AnyObject.Type, addKeys: [String], deleteKeys: [String]) -> AntBusServiceMultipleUpdateConfig {
//        let addKeySet = Set(addKeys)
//        let deleteKeySet = Set(deleteKeys)
//
//        let config = AntBusServiceMultipleUpdateConfig()
//        config.serviceName = AliasUtil.aliasForAnyObject(clazz)
//        config.addKeys = addKeySet
//        config.deleteKeys = deleteKeySet
//        return config
//    }

    public static func createForObjc(service: Protocol, addKeys: [String], deleteKeys: [String]) -> AntBusServiceMultipleUpdateConfig {
        let addKeySet = Set(addKeys)
        let deleteKeySet = Set(deleteKeys)

        let config = AntBusServiceMultipleUpdateConfig()
        config.serviceName = AliasUtil.aliasForInterface(service)
        config.addKeys = addKeySet
        config.deleteKeys = deleteKeySet
        return config
    }
}

@objc public protocol AntBusServiceSingle {
    static func atbsSingleInitConfig() -> AntBusServiceSingleConfig
}

@objc public protocol AntBusServiceMultiple {
    static func atbsMultipleInitConfigs() -> [AntBusServiceMultipleConfig]
    static func atbsMultipleUpdateConfigs(timestamp: Int) -> [AntBusServiceMultipleUpdateConfig]?
}

enum ATBSingleC {
    fileprivate static var singleConfigs = [String: AntBusServiceSingleConfig]()
    
    fileprivate static var rwLock = ReadWriteLock()
    
    static func allService() -> [String: AntBusServiceSingleConfig] {
        return singleConfigs
    }
    
    static func register() {
        var singleConfigs = [String: AntBusServiceSingleConfig]()
        
        ClassLoadUtil.createClassListsForProtocols([AntBusServiceSingle.self,AntBusServiceMultiple.self])
        
        let singleClassess = ClassLoadUtil.objcGetClassListForConformsToProtocol(AntBusServiceSingle.self)
        for sClass in singleClassess {
            let config = sClass.atbsSingleInitConfig()
            config.clazz = sClass
            singleConfigs[config.serviceName] = config
            
            AntBus.log.handler?(.service, "\(config)")

        }
        rwLock.lock_write()
        defer {
            rwLock.unlock_write()
        }
        self.singleConfigs = singleConfigs
    }
    
    static func responder(_ serviceName: String) -> Any? {
        rwLock.lock_read()
        defer {
            rwLock.unlock_read()
        }
        guard let config = singleConfigs[serviceName] else {
            AntBus.log.handler?(.service, "AntBus.service.single.responder:  \(serviceName) \t config:nil")
            return nil
        }
        
        if let cacheServiceObj = config.serviceObj {
            AntBus.log.handler?(.service, "AntBus.service.single.responder:  \(serviceName) \t cache serviceObj:\(cacheServiceObj)")
            return cacheServiceObj
        }
                
        let createServiceObj = config.createService!()
        if config.cache {
            config.serviceObj = createServiceObj
        }

        AntBus.log.handler?(.service, "AntBus.service.single.responder:  \(serviceName) \t create serviceObj:\(createServiceObj)")

        return createServiceObj
    }
}

enum ATBMultipleC {
    fileprivate static var multipleConfigs = [String: [String: NSMutableSet]]()
    
    fileprivate static var mClassKeyMultipleConfigs = [Int: [String: AntBusServiceMultipleConfig]]()
    
    fileprivate static var rwLock = ReadWriteLock()
    
    static func allService() -> [String: [String: NSMutableSet]] {
        return multipleConfigs
    }
    
    static func register() {
        var multipleConfigs = [String: [String: NSMutableSet]]()
        var mClassKeyMultipleConfigs = [Int: [String: AntBusServiceMultipleConfig]]()
        
        ClassLoadUtil.createClassListsForProtocols([AntBusServiceSingle.self,AntBusServiceMultiple.self])
        
        let multipleClassess = ClassLoadUtil.objcGetClassListForConformsToProtocol(AntBusServiceMultiple.self)
        for mClass in multipleClassess {
            let mClassKey = ObjectIdentifier(mClass).hashValue
            
            // 创建初始配置对象
            let configs = mClass.atbsMultipleInitConfigs()
            
            for config in configs {
                config.clazz = mClass
                
                var mClassContainer = mClassKeyMultipleConfigs[mClassKey] ?? [:]
                mClassContainer[config.serviceName] = config
                mClassKeyMultipleConfigs[mClassKey] = mClassContainer
                
                var keyDict = multipleConfigs[config.serviceName] ?? [String: NSMutableSet]()
                
                AntBus.log.handler?(.service, "\(config)")
                
                for key in config.keys {
                    let mset = keyDict[key] ?? NSMutableSet()
                    mset.add(config)
                    keyDict[key] = mset
                }
                multipleConfigs[config.serviceName] = keyDict
            }
        }
        
        rwLock.lock_write()
        defer {
            rwLock.unlock_write()
        }
        self.multipleConfigs = multipleConfigs
        self.mClassKeyMultipleConfigs = mClassKeyMultipleConfigs
    }
    
    static func update() {
        var multipleConfigs = self.multipleConfigs
        let mClassKeyMultipleConfigs = self.mClassKeyMultipleConfigs
        
        
        let timestamp = Int(Date.init().timeIntervalSince1970)
        
        ClassLoadUtil.createClassListsForProtocols([AntBusServiceSingle.self,AntBusServiceMultiple.self])
        
        let multipleClassess = ClassLoadUtil.objcGetClassListForConformsToProtocol(AntBusServiceMultiple.self)
        for mClass in multipleClassess {
            let mClassKey = ObjectIdentifier(mClass).hashValue
            
            // 创建更新配置对象
            if let updateConfigs = mClass.atbsMultipleUpdateConfigs(timestamp: timestamp) {
                
                let mClassContainer = mClassKeyMultipleConfigs[mClassKey]
                
                for updateConfig in updateConfigs {
                    
                    guard let config = mClassContainer?[updateConfig.serviceName] else {
                        return
                    }
                    
                    var keyDict = multipleConfigs[updateConfig.serviceName] ?? [String: NSMutableSet]()
                    
                    AntBus.log.handler?(.service, "\(config) \t addKeys:\(updateConfig.addKeys) \t deleteKeys:\(updateConfig.deleteKeys) ")
                    
                    // 需要增加的
                    for key in updateConfig.addKeys {
                        let mset = keyDict[key] ?? NSMutableSet()
                        mset.add(config)
                        keyDict[key] = mset
                    }
                    
                    // 需要删除的
                    for key in updateConfig.deleteKeys {
                        if let mset = keyDict[key] {
                            mset.remove(config)
                            if mset.count == 0 {
                                keyDict.removeValue(forKey: key)
                            }else{
                                keyDict[key] = mset
                            }
                        }
                    }
                    multipleConfigs[updateConfig.serviceName] = keyDict
                }
            }
        }
        rwLock.lock_write()
        defer {
            rwLock.unlock_write()
        }
        self.multipleConfigs = multipleConfigs
//        self.mClassKeyMultipleConfigs = mClassKeyMultipleConfigs
    }
    
    static func responders(_ serviceName: String, _ key: String) -> [Any]? {
        rwLock.lock_read()
        defer {
            rwLock.unlock_read()
        }
        var configs: [AntBusServiceMultipleConfig]?
        if let configsSet = multipleConfigs[serviceName]?[key] {
            configs = configsSet.allObjects.compactMap { $0 as? AntBusServiceMultipleConfig }
        }
        let resps = configs?.compactMap { $0.createService!() }
        AntBus.log.handler?(.service, "AntBus.service.multiple.responder:  \(serviceName) \t key:\(key) \t resps:\(resps ?? [])")
        return resps
    }
    
    static func responders(_ serviceName: String) -> [Any]? {
        rwLock.lock_read()
        defer {
            rwLock.unlock_read()
        }
        var configs: [AntBusServiceMultipleConfig]?
        
        let result = NSMutableSet()
        
        if let dict = multipleConfigs[serviceName] {
            for (_, mset) in dict {
                result.addObjects(from: mset.allObjects)
            }
            configs = result.allObjects.compactMap { $0 as? AntBusServiceMultipleConfig }
        }
        let resps = configs?.compactMap { $0.createService!() }

        AntBus.log.handler?(.service, "AntBus.service.multiple.responder:  \(serviceName) \t resps:\(resps ?? [])")
        return resps
    }
}

public enum AntBus {
    public enum service {
        
        public enum multiple {
            public static func allService() -> [String: [String: NSSet]] {
                return ATBMultipleC.allService()
            }
            
            public static func register() {

                AntBus.log.handler?(.service, "AntBus.service.multiple.register")
                
                ATBMultipleC.register()

                AntBus.log.handler?(.service, "")
            }
            
            public static func update() {
                
                AntBus.log.handler?(.service, "AntBus.service.multiple.update")
                
                ATBMultipleC.update()
                
                AntBus.log.handler?(.service, "")
            }
            
            public static func responders<T: Any>(_ service: T.Type, key: String) -> [T]? {
                let serviceName = AliasUtil.aliasForAny(service)
                return ATBMultipleC.responders(serviceName, key)?.compactMap { $0 as? T }
            }
            
            public static func responder<T: Any>(_ service: T.Type, key: String, where unique: @escaping (T) -> Bool) -> T? {
                let serviceName = AliasUtil.aliasForAny(service)
                if let results = ATBMultipleC.responders(serviceName, key)?.compactMap({ $0 as? T }) {
                    for result in results {
                        if unique(result) {

                            AntBus.log.handler?(.service, "AntBus.service.multiple.responder:  \(serviceName) \t \(key) \t unique \t resp:\(result)")
                            return result
                        }
                    }
                }

                AntBus.log.handler?(.service, "AntBus.service.multiple.responder:  \(serviceName) \t unique \t nil")
                return nil
            }
            
            public static func responder<T: Any>(_ service: T.Type, where unique: @escaping (T) -> Bool) -> T? {
                let serviceName = AliasUtil.aliasForAny(service)
                if let results = ATBMultipleC.responders(serviceName)?.compactMap({ $0 as? T }) {
                    for result in results {
                        if unique(result) {
                            AntBus.log.handler?(.service, "AntBus.service.multiple.responder:  \(serviceName) \t unique \t resp:\(result)")
                            return result
                        }
                    }
                }

                AntBus.log.handler?(.service, "AntBus.service.multiple.responder:  \(serviceName) \t unique \t nil")
                return nil
            }
            
            public static func responders<T: Any>(_ service: T.Type) -> [T]? {
                let serviceName = AliasUtil.aliasForAny(service)
                return ATBMultipleC.responders(serviceName)?.compactMap { $0 as? T }
            }
        }
        
        public enum single {
            public static func allService() -> [String: AntBusServiceSingleConfig] {
                return ATBSingleC.allService()
            }
            
            public static func register() {

                AntBus.log.handler?(.service, "AntBus.service.single.register")
                
                ATBSingleC.register()
                
                AntBus.log.handler?(.service, "")
            }
            
            public static func responder<T: Any>(_ service: T.Type) -> T? {
                let serviceName = AliasUtil.aliasForAny(service)
                return ATBSingleC.responder(serviceName) as? T
            }
        }
    }
}
