//
//  AntBus+.swift
//  AntBus
//
//  Created by abiaoyo
//

import Foundation

struct iKey {
    var key:String!
    var interface:Any!

    static func createIKey(_ groupKey:String,interface:Any) -> iKey{
        let key = "\(groupKey)_\(arc4random()%1000)_\(arc4random()%1000)"
        return iKey.init(key: key, interface: interface)
    }
}

typealias AntBusLogHandler = (_ logOptions:AntBusLogOptions, _ log:String) -> Void

protocol IAntBusCacheUtil{
    static var ikGroupContainer:Dictionary<String,Array<iKey>>{get set}
}

extension IAntBusCacheUtil{
    static func getIKey<I:Any>(_ interface:I.Type, logHandler:AntBusLogHandler) -> String {
        let iGroupKey = "\(interface)"
        if let array = ikGroupContainer[iGroupKey] {
            for ik in array {
                if interface == ik.interface as? Any.Type{
                    let log = "==> IKey_cache: iGroup=\(iGroupKey) \t iKey:\(ik.key!) \t I:\(interface)"
                    logHandler(.iKey,log)
                    return ik.key
                }
            }
            let ik = iKey.createIKey(iGroupKey, interface: interface)
            ikGroupContainer[iGroupKey]?.append(ik)
            
            let log = "==> IKey_create1: iGroup=\(iGroupKey) \t iKey:\(ik.key!) \t I:\(interface)"
            logHandler(.iKey,log)
            return ik.key
        }else{
            let ik = iKey.createIKey(iGroupKey, interface: interface)
            ikGroupContainer[iGroupKey] = [ik]
            
            let log = "==> IKey_create2: iGroup=\(iGroupKey) \t iKey:\(ik.key!) \t I:\(interface)"
            logHandler(.iKey,log)
            return ik.key
        }
    }
}

//MARK: - AntServiceUtil
struct AntServiceUtil:IAntBusCacheUtil{
    static var ikGroupContainer = Dictionary<String,Array<iKey>>.init()
    
    static var singleCs = Dictionary<String,AnyObject>.init()
    static var multiCs = Dictionary<String,AnyObject>.init()
    
    static func createSingleC<Interface:Any>(key:String) -> AntServiceSingleC<Interface>{
        var container = AntServiceUtil.singleCs[key]
        if container == nil {
            container = AntServiceSingleC<Interface>.init()
            AntServiceUtil.singleCs[key] = container
            
            let log = "==> createSingleC: iKey=\(key) \t I:\(Interface.self)"
            AntServiceLog.handlerLog(.Container, log)
        }else{
            let log = "==> cacheSingleC: iKey=\(key) \t I:\(Interface.self)"
            AntServiceLog.handlerLog(.Container, log)
        }
        
        return container as! AntServiceSingleC<Interface>
    }
    
    static func createMultiC<Interface:Any>(key:String) -> AntServiceMultiC<Interface>{
        var container = AntServiceUtil.multiCs[key]
        if container == nil {
            container = AntServiceMultiC<Interface>.init()
            AntServiceUtil.multiCs[key] = container
            
            let log = "==> createMultiC: iKey=\(key) \t I:\(Interface.self)"
            AntServiceLog.handlerLog(.Container, log)
        }else{
            let log = "==> cacheMultiC: iKey=\(key) \t I:\(Interface.self)"
            AntServiceLog.handlerLog(.Container, log)
        }
        
        return container as! AntServiceMultiC<Interface>
    }

}

//MARK: - AnChannelUtil
struct AnChannelUtil:IAntBusCacheUtil{
    static var ikGroupContainer = Dictionary<String,Array<iKey>>.init()
    
    static var singleContainer = Dictionary<String,AnyObject>.init()
    static var multiContainer = Dictionary<String,AnyObject>.init()
    
    static func createSingleC<Interface:Any>(key:String) -> AntChannelSingleC<Interface>{
        var container = AnChannelUtil.singleContainer[key]
        if container == nil {
            container = AntChannelSingleC<Interface>.init()
            AnChannelUtil.singleContainer[key] = container
            
            let log = "==> createSingleC: iKey=\(key) \t I:\(Interface.self)"
            AntChannelLog.handlerLog(.Container, log)
        }else{
            let log = "==> cacheSingleC: iKey=\(key) \t I:\(Interface.self)"
            AntChannelLog.handlerLog(.Container, log)
        }
        
        return container as! AntChannelSingleC<Interface>
    }
    
    static func createMultipleC<Interface:Any>(key:String) -> AntChannelMultiC<Interface>{
        var container = AnChannelUtil.multiContainer[key]
        if container == nil {
            container = AntChannelMultiC<Interface>.init()
            AnChannelUtil.multiContainer[key] = container
            
            let log = "==> createMultiC: iKey=\(key) \t I:\(Interface.self)"
            AntChannelLog.handlerLog(.Container, log)
        }else{
            let log = "==> cacheMultiC: iKey=\(key) \t I:\(Interface.self)"
            AntChannelLog.handlerLog(.Container, log)
        }
        
        return container as! AntChannelMultiC<Interface>
    }
}

public struct AntBusLogOptions: OptionSet{
    public var rawValue:Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public static let None = AntBusLogOptions(rawValue: 1 << 0)
    public static let iKey = AntBusLogOptions(rawValue: 1 << 1)
    public static let Container = AntBusLogOptions(rawValue: 1 << 2)
    public static let Responder = AntBusLogOptions(rawValue: 1 << 3)
}

public class AntChannelLog {
    public static var logOptions:AntBusLogOptions = .None
    public static let shared = AntChannelLog.init()
    public var logHandler:((_ logOptions:AntBusLogOptions, _ log:String) -> Void)?
    
    private init() {}
    
    static func handlerLog(_ logOptions:AntBusLogOptions, _ log:String){
        if AntChannelLog.logOptions.contains(logOptions) {
            if let handler = AntChannelLog.shared.logHandler {
                handler(logOptions,log)
            }else{
                if logOptions == .iKey {
                    print("\nAntChannel log: \(log)")
                }else{
                    print("AntChannel log: \(log)")
                }
            }
        }
    }
}

public class AntServiceLog {
    public static var logOptions:AntBusLogOptions = .None
    public static let shared = AntServiceLog.init()
    public var logHandler:((_ logOptions:AntBusLogOptions, _ log:String) -> Void)?
    
    private init() {}
    
    static func handlerLog(_ logOptions:AntBusLogOptions, _ log:String){
        if AntServiceLog.logOptions.contains(logOptions) {
            if let handler = AntServiceLog.shared.logHandler {
                handler(logOptions,log)
            }else{
                if logOptions == .iKey {
                    print("\nAntService log: \(log)")
                }else{
                    print("AntService log: \(log)")
                }
                
            }
        }
    }
}
