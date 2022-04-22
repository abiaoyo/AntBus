import Foundation

private struct DynamicAlias {
    var name:String!
    var type:Any!
    static func createDynamicAlias(_ group:String,type:Any) -> DynamicAlias{
        let name = "\(group)_\(Int(Date().timeIntervalSince1970)%10000)_\(arc4random()%1000)"
        return DynamicAlias.init(name: name, type: type)
    }
}

struct DynamicAliasUtil {
    
    private static var aliasGroups = Dictionary<String,Array<DynamicAlias>>.init()
    
    private static func _getAliasName(aliasArray:[DynamicAlias], interface:AnyObject) -> String? {
        for alias in aliasArray {
            if interface === alias.type as AnyObject{
                return alias.name
            }
            if let aType = alias.type as AnyObject? {
                if interface === aType {
                    return alias.name
                }
            }
        }
        return nil
    }
    
    private static func _getAliasName(aliasArray:[DynamicAlias], itype:Any.Type) -> String? {
        for alias in aliasArray {
            if itype == alias.type as? Any.Type {
                return alias.name
            }
            if let iType = itype as AnyObject? {
                if let aType = alias.type as AnyObject? {
                    if iType === aType {
                        return alias.name
                    }
                }
            }
        }
        return nil
    }
    
    private static func _getAliasName(groupKey:String, interface:AnyObject) -> String {
        if let aliasArray = aliasGroups[groupKey] {
            if let name = _getAliasName(aliasArray: aliasArray, interface: interface) {
                return name
            }
            let alias = DynamicAlias.createDynamicAlias(groupKey, type: interface)
            aliasGroups[groupKey]?.append(alias)
            return alias.name
        }else{
            let alias = DynamicAlias.createDynamicAlias(groupKey, type: interface)
            aliasGroups[groupKey] = [alias]
            return alias.name
        }
    }
    
    private static func _getAliasName(groupKey:String, itype:Any.Type) -> String {
        if let aliasArray = aliasGroups[groupKey] {
            if let name = _getAliasName(aliasArray: aliasArray, itype: itype){
                return name
            }
            let alias = DynamicAlias.createDynamicAlias(groupKey, type: itype)
            aliasGroups[groupKey]?.append(alias)
            return alias.name
        }else{
            let alias = DynamicAlias.createDynamicAlias(groupKey, type: itype)
            aliasGroups[groupKey] = [alias]
            return alias.name
        }
    }
    
    static func getAliasNameWithInterface(_ interface:Protocol) -> String {
        let typeName = NSStringFromProtocol(interface)
        let groupKey = typeName.components(separatedBy: ".").last!
        let aliasName = _getAliasName(groupKey: groupKey, interface: interface)
        if AntBus.printAliasName {
            print("aliasName: \(aliasName)")
        }
        return aliasName
    }
    
    static func getAliasNameWithType(_ type:AnyObject.Type) -> String {
        let groupKey = "\(type)"
        let aliasName = _getAliasName(groupKey: groupKey, itype: type)
        if AntBus.printAliasName {
            print("aliasName: \(aliasName)")
        }
        return aliasName
    }
    
    static func getAliasName<T:Any>(_ type:T.Type) -> String {
        let groupKey = "\(type)"
        let aliasName = _getAliasName(groupKey: groupKey, itype: type)
        if AntBus.printAliasName {
            print("aliasName: \(aliasName)")
        }
        return aliasName
    }
}
