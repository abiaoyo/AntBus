import Foundation

@objcMembers
public class AntBusServiceSingleConfig: NSObject {
    var serviceName: String = ""     //服务名
    var serviceObj: Any?             //服务对象
    
    public override var description: String {
        return "[\(serviceName) | \(serviceObj ?? "nil")]"
    }
    
    public static func createForSwift<T: Any>(_ service: T.Type, serviceObj: T) -> AntBusServiceSingleConfig {
        let config = AntBusServiceSingleConfig()
        config.serviceName = AliasUtil.aliasForAny(service)
        config.serviceObj = serviceObj
        return config
    }
    
    public static func createForObjc(service: Protocol, serviceObj: AnyObject) -> AntBusServiceSingleConfig {
        let config = AntBusServiceSingleConfig()
        config.serviceName = AliasUtil.aliasForInterface(service)
        config.serviceObj = serviceObj
        return config
    }
}

@objcMembers
public class AntBusServiceMultipleConfig: NSObject {
    var serviceName: String = ""     //服务名
    var keys: Set<String> = []       //keys
    var serviceObj: Any?             //服务对象
    
    public override var description: String {
        return "[\(serviceName) | keys:\(keys) | \(serviceObj ?? "nil")]"
    }
    
    public static func createForSwift<T: Any>(_ service: T.Type, keys: [String], serviceObj: T) -> AntBusServiceMultipleConfig {
        let config = AntBusServiceMultipleConfig()
        config.serviceName = AliasUtil.aliasForAny(service)
        config.serviceObj = serviceObj
        config.keys = Set(keys)
        return config
    }

    public static func createForObjc(service: Protocol, keys: [String], serviceObj: AnyObject) -> AntBusServiceMultipleConfig {
        let config = AntBusServiceMultipleConfig()
        config.serviceName = AliasUtil.aliasForInterface(service)
        config.serviceObj = serviceObj
        config.keys = Set(keys)
        return config
    }
}

@objc public protocol AntBusServiceSingle {
    static func atbsSingleInitConfig() -> AntBusServiceSingleConfig
}

@objc public protocol AntBusServiceMultiple {
    static func atbsMultipleInitConfigs() -> [AntBusServiceMultipleConfig]
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
            AntBus.log.handler?(.service, "AntBus.service.single.responder:  \(serviceName) \t config: nil")
            return nil
        }
        
        guard let serviceObj = config.serviceObj else {
            AntBus.log.handler?(.service, "AntBus.service.single.responder:  \(serviceName) \t serviceObj: nil")
            return nil
        }
        
        AntBus.log.handler?(.service, "AntBus.service.single.responder:  \(serviceName) \t serviceObj: \(serviceObj)")

        return serviceObj
    }
}

enum ATBMultipleC {
    fileprivate static var multipleConfigs = [String: [String: NSMutableSet]]()
    
    fileprivate static var rwLock = ReadWriteLock()
    
    static func allService() -> [String: [String: NSMutableSet]] {
        return multipleConfigs
    }
    
    static func register() {
        var multipleConfigs = [String: [String: NSMutableSet]]()
        
        ClassLoadUtil.createClassListsForProtocols([AntBusServiceSingle.self,AntBusServiceMultiple.self])
        
        let multipleClassess = ClassLoadUtil.objcGetClassListForConformsToProtocol(AntBusServiceMultiple.self)
        
        for mClass in multipleClassess {
            // 创建初始配置对象
            let configs = mClass.atbsMultipleInitConfigs()
            
            for config in configs {
                
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
        
        let resps = configs?.compactMap { $0.serviceObj }
        AntBus.log.handler?(.service, "AntBus.service.multiple.responders:  \(serviceName) \t key:\(key) \t resps:\(resps ?? [])")
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
        let resps = configs?.compactMap { $0.serviceObj }
        AntBus.log.handler?(.service, "AntBus.service.multiple.responders:  \(serviceName) \t resps:\(resps ?? [])")
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
