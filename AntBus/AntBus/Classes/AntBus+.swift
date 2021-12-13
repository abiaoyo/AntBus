//
//  AntBus+.swift
//  AntBus
//
//  Created by abiaoyo
//

import Foundation

struct DynamicAlias {
    var name:String!
    var interface:Any!
    static func createDynamicAlias(_ group:String,interface:Any) -> DynamicAlias{
        let name = "\(group)_\(arc4random()%1000)_\(arc4random()%1000)"
        return DynamicAlias.init(name: name, interface: interface)
    }
}

typealias AntBusLogHandler = (_ logOptions:AntBusLogOptions, _ log:String) -> Void

protocol IAntBusCacheUtil{
    //<group,[alias]>
    //group:LoginModule  [{name:LoginModule_123_981,interface:LoginModule}]
    static var aliasGroups:Dictionary<String,Array<DynamicAlias>>{get set}
    static func logEnabled() -> Bool
}

extension IAntBusCacheUtil{
    static func getIKey<I:Any>(_ interface:I.Type, logHandler:AntBusLogHandler) -> String {
        return self.getAliasName(interface, logHandler: logHandler)
    }
    static func getAliasName<I:Any>(_ interface:I.Type, logHandler:AntBusLogHandler) -> String {
        let group = "\(interface)"
        
        if let aliasArray = aliasGroups[group] {
            for alias in aliasArray {
                if interface == alias.interface as? Any.Type{
                    if self.logEnabled() {
                        let log = "==> Alias cache: aliasGroup=\(group) \t aliasName:\(alias.name!) \t I:\(interface)"
                        logHandler(.alias,log)
                    }
                    return alias.name
                }
            }
            let alias = DynamicAlias.createDynamicAlias(group, interface: interface)
            aliasGroups[group]?.append(alias)
            
            if self.logEnabled() {
                let log = "==> Alias create: aliasGroup=\(group) \t aliasName:\(alias.name!) \t I:\(interface)"
                logHandler(.alias,log)
            }
            
            return alias.name
        }else{
            let alias = DynamicAlias.createDynamicAlias(group, interface: interface)
            aliasGroups[group] = [alias]
            
            if self.logEnabled() {
                let log = "==> Alias create: aliasGroup=\(group) \t aliasName:\(alias.name!) \t I:\(interface)"
                logHandler(.alias,log)
            }
            return alias.name
        }
    }
}

//MARK: - AntServiceUtil
struct AntServiceCacheUtil:IAntBusCacheUtil{

    static var aliasGroups = Dictionary<String, Array<DynamicAlias>>.init()
    static var singleCs = Dictionary<String,AnyObject>.init()
    static var multiCs = Dictionary<String,AnyObject>.init()
    static func logEnabled() -> Bool {
        return AntServiceLog.shared.enabled
    }
    static func createSingleC<Interface:Any>(_ aliasName:String) -> AntServiceSingleC<Interface>{
        var container = AntServiceCacheUtil.singleCs[aliasName]
        if container == nil {
            container = AntServiceSingleC<Interface>.init()
            AntServiceCacheUtil.singleCs[aliasName] = container
    
            if AntServiceLog.shared.enabled {
                let log = "==> SingleUtil create: aliasName=\(aliasName) \t I:\(Interface.self)"
                AntServiceLog.handlerLog(.container, log)
            }
        }else{
            if AntServiceLog.shared.enabled {
                let log = "==> SingleUtil cache: aliasName=\(aliasName) \t I:\(Interface.self)"
                AntServiceLog.handlerLog(.container, log)
            }
        }
        
        return container as! AntServiceSingleC<Interface>
    }
    
    static func createMultiC<Interface:Any>(_ aliasName:String) -> AntServiceMultiC<Interface>{
        var container = AntServiceCacheUtil.multiCs[aliasName]
        if container == nil {
            container = AntServiceMultiC<Interface>.init()
            AntServiceCacheUtil.multiCs[aliasName] = container
    
            if AntServiceLog.shared.enabled {
                let log = "==> MultiUtil create: aliasName=\(aliasName) \t I:\(Interface.self)"
                AntServiceLog.handlerLog(.container, log)
            }
        }else{
            if AntServiceLog.shared.enabled {
                let log = "==> MultiUtil cache: aliasName=\(aliasName) \t I:\(Interface.self)"
                AntServiceLog.handlerLog(.container, log)
            }
        }
        
        return container as! AntServiceMultiC<Interface>
    }

}

//MARK: - AntChannelUtil
struct AntChannelCacheUtil:IAntBusCacheUtil{
    static var aliasGroups = Dictionary<String, Array<DynamicAlias>>.init()
    static var singleCs = Dictionary<String,AnyObject>.init()
    static var multiCs = Dictionary<String,AnyObject>.init()
    static func logEnabled() -> Bool {
        return AntChannelLog.shared.enabled
    }
    static func createSingleC<Interface:Any>(_ aliasName:String) -> AntChannelSingleC<Interface>{
        var container = AntChannelCacheUtil.singleCs[aliasName]
        if container == nil {
            container = AntChannelSingleC<Interface>.init()
            AntChannelCacheUtil.singleCs[aliasName] = container
            
            if AntChannelLog.shared.enabled {
                let log = "==> SingleUtil create: aliasName=\(aliasName) \t I:\(Interface.self)"
                AntChannelLog.handlerLog(.container, log)
            }
        }else{
            if AntChannelLog.shared.enabled {
                let log = "==> SingleUtil cache: aliasName=\(aliasName) \t I:\(Interface.self)"
                AntChannelLog.handlerLog(.container, log)
            }
        }
        
        return container as! AntChannelSingleC<Interface>
    }
    
    static func createMultipleC<Interface:Any>(_ aliasName:String) -> AntChannelMultiC<Interface>{
        var container = AntChannelCacheUtil.multiCs[aliasName]
        if container == nil {
            container = AntChannelMultiC<Interface>.init()
            AntChannelCacheUtil.multiCs[aliasName] = container
            
            if AntChannelLog.shared.enabled {
                let log = "==> MultiUtil create: aliasName=\(aliasName) \t I:\(Interface.self)"
                AntChannelLog.handlerLog(.container, log)
            }
        }else{
            if AntChannelLog.shared.enabled {
                let log = "==> MultiUtil cache: aliasName=\(aliasName) \t I:\(Interface.self)"
                AntChannelLog.handlerLog(.container, log)
            }
        }
        
        return container as! AntChannelMultiC<Interface>
    }
}

public struct AntBusLogOptions: OptionSet{
    public var rawValue:Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public static let none = AntBusLogOptions(rawValue: 1 << 0)
    public static let alias = AntBusLogOptions(rawValue: 1 << 1)
    public static let container = AntBusLogOptions(rawValue: 1 << 2)
    public static let responder = AntBusLogOptions(rawValue: 1 << 3)
}

public class AntChannelLog {
    public static var logOptions:AntBusLogOptions = .none
    public static let shared = AntChannelLog.init()
    public var enabled:Bool = false
    public var logHandler:((_ logOptions:AntBusLogOptions, _ log:String) -> Void)?
    
    private init() {}
    
    static func handlerLog(_ logOptions:AntBusLogOptions, _ log:String){
        if AntChannelLog.shared.enabled && AntChannelLog.logOptions.contains(logOptions) {
            if let handler = AntChannelLog.shared.logHandler {
                handler(logOptions,log)
            }else{
                if logOptions == .alias {
                    print("\nAntChannel log: \(log)")
                }else{
                    print("AntChannel log: \(log)")
                }
            }
        }
    }
}

public class AntServiceLog {
    public static var logOptions:AntBusLogOptions = .none
    public static let shared = AntServiceLog.init()
    public var enabled:Bool = false
    public var logHandler:((_ logOptions:AntBusLogOptions, _ log:String) -> Void)?
    
    private init() {}
    
    static func handlerLog(_ logOptions:AntBusLogOptions, _ log:String){
        if AntServiceLog.shared.enabled && AntServiceLog.logOptions.contains(logOptions) {
            if let handler = AntServiceLog.shared.logHandler {
                handler(logOptions,log)
            }else{
                if logOptions == .alias {
                    print("\nAntService log: \(log)")
                }else{
                    print("AntService log: \(log)")
                }
            }
        }
    }
}
