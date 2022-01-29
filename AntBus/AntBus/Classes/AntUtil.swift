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
