import Foundation

@objcMembers
public class OCATBSingle: NSObject {
    
    public func allService() -> [String: AntBusServiceSingleConfig] {
        return AntBus.service.single.allService()
    }

    public func registerService() {
        AntBus.service.single.register()
    }

    public func responder(_ service: Protocol) -> AnyObject? {
        let serviceName = AliasUtil.aliasForInterface(service)
        if let resp = ATBSingleC.responder(serviceName) as? AnyObject, resp.conforms(to: service) {
            return resp
        }
        return nil
    }
}

@objcMembers
public class OCATBMultiple: NSObject {
    
    public func allService() -> [String: [String: NSSet]] {
        return AntBus.service.multiple.allService()
    }
    
    public func registerService() {
        AntBus.service.multiple.register()
    }

    public func responder(_ service: Protocol, key: String) -> [AnyObject]? {
        let serviceName = AliasUtil.aliasForInterface(service)
        return ATBMultipleC.responders(serviceName, key) as? [AnyObject]
    }
    
    public func responder(_ service: Protocol, key: String, where unique: @escaping (AnyObject) -> Bool) -> AnyObject? {
        let serviceName = AliasUtil.aliasForInterface(service)
        
        if let results = ATBMultipleC.responders(serviceName, key)?.compactMap({ $0 as AnyObject }) {
            for result in results {
                if result.conforms(to: service) && unique(result) {
                    AntBus.log.handler?(.service, "OCAntBus.service.multiple.responder:  \(serviceName) \t \(key) \t unique \t resp:\(result)")
                    return result
                }
            }
        }
        return nil
    }

    public func responder(_ service: Protocol) -> [AnyObject]? {
        let serviceName = AliasUtil.aliasForInterface(service)
        return ATBMultipleC.responders(serviceName) as? [AnyObject]
    }
    
    public func responder(_ service: Protocol, where unique: @escaping (AnyObject) -> Bool) -> AnyObject? {
        let serviceName = AliasUtil.aliasForInterface(service)
        
        if let results = ATBMultipleC.responders(serviceName)?.compactMap({ $0 as AnyObject }) {
            for result in results {
                if result.conforms(to: service) && unique(result) {
                    AntBus.log.handler?(.service, "OCAntBus.service.multiple.responder:  \(serviceName) \t unique \t resp:\(result)")
                    return result
                }
            }
        }
        return nil
    }
}

@objcMembers
public class OCATBService: NSObject {
    public var single = OCATBSingle()
    public var multiple = OCATBMultiple()
}

@objcMembers
public class OCAntBus: NSObject {
    public static var service = OCATBService()
}
