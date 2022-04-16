import Foundation

struct DynamicAlias {
    var name:String!
    var type:Any!
    static func createDynamicAlias(_ group:String,type:Any) -> DynamicAlias{
        let name = "\(group)_\(arc4random()%1000)_\(arc4random()%1000)"
        return DynamicAlias.init(name: name, type: type)
    }
}

struct DynamicAliasUtil {
    
    private static var aliasGroups = Dictionary<String,Array<DynamicAlias>>.init()
    
    static func getAliasName<T:Any>(_ type:T.Type) -> String {
        let groupKey = "\(type)"
        
        if let aliasArray = aliasGroups[groupKey] {
            for alias in aliasArray {
                if type == alias.type as? Any.Type{
                    return alias.name
                }
            }
            
            let alias = DynamicAlias.createDynamicAlias(groupKey, type: type)
            aliasGroups[groupKey]?.append(alias)
            return alias.name
        }else{
            let alias = DynamicAlias.createDynamicAlias(groupKey, type: type)
            aliasGroups[groupKey] = [alias]
            return alias.name
        }
    }
}
