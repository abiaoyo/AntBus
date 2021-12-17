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

struct DynamicAliasUtil {
    
    private static var aliasGroups = Dictionary<String,Array<DynamicAlias>>.init()
    
    static func getAliasName<I:Any>(_ interface:I.Type) -> String {
        let groupKey = "\(interface)"
        
        if let aliasArray = aliasGroups[groupKey] {
            for alias in aliasArray {
                if interface == alias.interface as? Any.Type{
                    return alias.name
                }
            }
            let alias = DynamicAlias.createDynamicAlias(groupKey, interface: interface)
            aliasGroups[groupKey]?.append(alias)
            return alias.name
        }else{
            let alias = DynamicAlias.createDynamicAlias(groupKey, interface: interface)
            aliasGroups[groupKey] = [alias]
            return alias.name
        }
    }
}

public struct AntBusLogOptions: OptionSet{
    public var rawValue:Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public static let none = AntBusLogOptions(rawValue: 1 << 0)
    public static let container = AntBusLogOptions(rawValue: 1 << 2)
    public static let responder = AntBusLogOptions(rawValue: 1 << 3)
}

public class AntChannelLog {
    public static var logOptions:AntBusLogOptions = .none
    public static var enabled:Bool = false
    public static var logHandler:((_ logOptions:AntBusLogOptions, _ log:String) -> Void)?
    
    static func handlerLog(_ logOptions:AntBusLogOptions, _ log:String){
        if AntChannelLog.enabled && AntChannelLog.logOptions.contains(logOptions) {
            if let handler = AntChannelLog.logHandler {
                handler(logOptions,log)
            }else{
                if logOptions == .container {
                    print("")
                }
                print("AntChannel log: \(log)")
            }
        }
    }
}

public class AntServiceLog {
    public static var logOptions:AntBusLogOptions = .none
    public static var enabled:Bool = false
    public static var logHandler:((_ logOptions:AntBusLogOptions, _ log:String) -> Void)?
    
    static func handlerLog(_ logOptions:AntBusLogOptions, _ log:String){
        if AntServiceLog.enabled && AntServiceLog.logOptions.contains(logOptions) {
            if let handler = AntServiceLog.logHandler {
                handler(logOptions,log)
            }else{
                if logOptions == .container {
                    print("")
                }
                print("AntService log: \(log)")
            }
        }
    }
}
