import Foundation

struct AliasUtil {
    
    private struct Alias {
        var name: String!
        var type: Any!
        
        static func create(_ group: String, type: Any) -> Alias {
            let name = "\(group)_\(Int(Date().timeIntervalSince1970*1000)%100000)_\(arc4random()%100000)"
            return Alias(name: name, type: type)
        }
    }
    
    private static var aliasGroups = SafeDictionary<String, [Alias]>.init()
    
    private static func _aliasName(aliasArray: [Alias], interface: AnyObject) -> String? {
        for alias in aliasArray {
            if interface === alias.type as AnyObject {
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
    
    private static func _aliasName(aliasArray: [Alias], itype: Any.Type) -> String? {
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
    
    // -----------------------------------------------------------
    
    private static func _aliasName(groupKey: String, interface: AnyObject) -> String {
        guard let aliasArray = aliasGroups[groupKey] else {
            let alias = Alias.create(groupKey, type: interface)
            aliasGroups[groupKey] = [alias]
            return alias.name
        }
        
        if let name = _aliasName(aliasArray: aliasArray, interface: interface) {
            return name
        }
        let alias = Alias.create(groupKey, type: interface)
        aliasGroups[groupKey]?.append(alias)
        return alias.name
    }
    
    private static func _aliasName(groupKey: String, itype: Any.Type) -> String {
        guard let aliasArray = aliasGroups[groupKey] else {
            let alias = Alias.create(groupKey, type: itype)
            aliasGroups[groupKey] = [alias]
            return alias.name
        }
        if let name = _aliasName(aliasArray: aliasArray, itype: itype) {
            return name
        }
        let alias = Alias.create(groupKey, type: itype)
        aliasGroups[groupKey]?.append(alias)
        return alias.name
    }
}

extension AliasUtil {
    static func aliasForInterface(_ interface: Protocol) -> String {
        let typeName = NSStringFromProtocol(interface)
//        print("AliasUtil.aliasForInterface: typeName:\(typeName)")
        let groupKey = typeName.components(separatedBy: ".").last!
        return _aliasName(groupKey: groupKey, interface: interface)
    }
    
    static func aliasForAnyObject(_ type: AnyObject.Type) -> String {
//        print("AliasUtil.aliasForAnyObject: type:\(type)")
        return _aliasName(groupKey: "\(type)", itype: type)
    }
    
    static func aliasForAny<T: Any>(_ type: T.Type) -> String {
//        print("AliasUtil.aliasForAny: type:\(type)")
        return _aliasName(groupKey: "\(type)", itype: type)
    }
}


struct ClassLoadUtil{
    
    private static func objcGetAllClassList() -> [AnyClass] {
        let expectedClassCount = objc_getClassList(nil, 0)
        let allClasses = UnsafeMutablePointer<AnyClass>.allocate(capacity: Int(expectedClassCount))
        let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
        let actualClassCount:Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)
        
        var classes = [AnyClass]()
        for i in 0 ..< actualClassCount {
            let currentClass: AnyClass = allClasses[Int(i)]
            classes.append(currentClass)
        }
        return classes
    }
    
    private static var allClassList:[AnyClass]?
    private static var classListForPro:[String:[AnyClass]]?
    private static let semaphore = DispatchSemaphore(value: 1)
    
    static func createClassListsForProtocols(_ pros:[Protocol]) -> Void {
        semaphore.wait()
        defer { semaphore.signal() }
        if allClassList == nil {
            allClassList = objcGetAllClassList()
        }
        if classListForPro == nil {
            classListForPro = [:]
            for clazz in allClassList! {
                for pro in pros {
                    if class_conformsToProtocol(clazz, pro) {
                        let proName:String = NSStringFromProtocol(pro)
                        var classes = classListForPro?[proName] ?? [AnyClass]()
                        classes.append(clazz)
                        classListForPro?[proName] = classes
                    }
                }
            }
        }
    }
    
    static func objcGetClassListForConformsToProtocol(_ pro:Protocol) -> [AnyClass] {
        semaphore.wait()
        defer { semaphore.signal() }
        let proName:String = NSStringFromProtocol(pro)
        return classListForPro?[proName] ?? []
    }
}
