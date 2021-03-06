//
//  AntBusContainer.swift
//  AntBus
//  Created by abiaoyo
//

import Foundation

//MARK:AntBusSingleContainer
public class AntBusSingleContainer<T:NSObjectProtocol> {

    var container = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    
    public func register(_ responser:T) -> Void{
        let module:String = "\(T.self)"
        if AntBusContainer.showLog {
            print("🍄AntBusContainer single register: .module:\(module)  \t  .responser:\(responser)")
        }
        self.container.setObject(responser, forKey: module as NSString)
    }
    
    public func responser() -> T? {
        let module:String = "\(T.self)"
        if AntBusContainer.showLog {
            print("🍄AntBusContainer single responser: .module:\(module)")
        }
        return self.container.object(forKey: module as NSString) as? T
    }
    
    public func remove() -> Void{
        let module:String = "\(T.self)"
        if AntBusContainer.showLog {
            print("🍄AntBusContainer single remove: .module:\(module)")
        }
        self.container.removeObject(forKey: module as NSString)
        
    }
    
    public func removeAll() {
        self.container.removeAllObjects()
        
        let module:String = "\(T.self)"
        if AntBusContainer.showLog {
            print("🍄AntBusContainer single removeAll: .module:\(module)")
        }
    }
    
    
}

//MARK:AntBusMultiContainer
public class AntBusMultiContainer<T:NSObjectProtocol> {
    
    //<Key,[AnyObject]>
    var container = NSMapTable<NSString,NSHashTable<T>>.strongToStrongObjects()
    
    private func getResponserSet(key:String) -> NSHashTable<T> {
        var responsers = self.container.object(forKey: key as NSString)
        if responsers == nil {
            responsers = NSHashTable<T>.weakObjects()
            self.container.setObject(responsers, forKey: key as NSString)
        }
        return responsers!
    }
    
    
    public func register(_ keys:[String], _ responser:T) -> Void{
        for key in keys {
            self.getResponserSet(key: key).add(responser)
        }
        if AntBusContainer.showLog {
            let module:String = "\(T.self)"
            print("🍄AntBusContainer multi register: .module:\(module)  \t  keys:\(keys)  \t  .responser:\(responser)")
        }
    }
    
    public func register(_ key:String, _ responsers:[T]) -> Void{
        let responserSet = self.getResponserSet(key: key)
        for responser in responsers {
            responserSet.add(responser)
        }
        if AntBusContainer.showLog {
            let module:String = "\(T.self)"
            print("🍄AntBusContainer multi register: .module:\(module)  \t  key:\(key)  \t  .responsers:\(responsers)")
        }
    }

    @discardableResult
    public func responsers(_ key:String) -> [T]? {
        var results:[T]? = nil
        if let responsers = self.container.object(forKey: key as NSString) {
            results = responsers.allObjects
        }
        if AntBusContainer.showLog {
            let module:String = "\(T.self)"
            print("🍄AntBusContainer multi responsers: .module:\(module)  \t  key:\(key)  \t  .responsers:\(String(describing: results))")
        }
        return results
    }

    @discardableResult
    public func allResponsers() -> [T]? {
        var results:[T]? = nil
        
        if let responsers:[AnyObject] = self.container.objectEnumerator()?.allObjects.flatMap({ ($0 as! NSHashTable<AnyObject>).objectEnumerator().map{ $0 }}) as [AnyObject]? {
            let resultSet = NSHashTable<T>.init()
            for resp in responsers {
                resultSet.add(resp as? T)
            }
            results = resultSet.allObjects
        }
        if AntBusContainer.showLog {
            let module:String = "\(T.self)"
            print("🍄AntBusContainer multi allResponsers: .module:\(module)  \t  .responsers:\(String(describing: results))")
        }
        return results
    }
    
    public func remove(_ keys:[String],_ responser:T) -> Void {
        for key in keys {
            if let responsers = self.container.object(forKey: key as NSString) {
                responsers.remove(responser)
            }
        }
        
        let module:String = "\(T.self)"
        if AntBusContainer.showLog {
            print("🍄AntBusContainer multi remove: .module:\(module)  \t  keys:\(keys)  \t  .responser:\(responser)")
        }
    }
    
    public func remove(_ keys:[String]) -> Void {
        for key in keys {
            self.container.removeObject(forKey: key as NSString)
        }
        
        if AntBusContainer.showLog {
            let module:String = "\(T.self)"
            print("🍄AntBusContainer multi remove: .module:\(module)  \t  keys:\(keys)")
        }
    }
    
    public func remove(_ key:String,_ responser:T) -> Void{
        if let responsers = self.container.object(forKey: key as NSString) {
            responsers.remove(responser)
        }
        
        let module:String = "\(T.self)"
        if AntBusContainer.showLog {
            print("🍄AntBusContainer multi remove: .module:\(module)  \t  key:\(key)  \t  .responser:\(responser)")
        }
    }
    
    public func remove(_ key:String) -> Void{
        self.container.removeObject(forKey: key as NSString)
        
        let module:String = "\(T.self)"
        if AntBusContainer.showLog {
            print("🍄AntBusContainer multi remove: .module:\(module)  \t  key:\(key)")
        }
    }
    
    public func removeAll() -> Void {
        self.container.removeAllObjects()
        
        if AntBusContainer.showLog {
            print("🍄AntBusContainer multi removeAll: all responsers")
        }
    }
}

//MARK:AntBusContainerStore
class AntBusContainerStore{
    static var multiContainer = Dictionary<String,AnyObject>.init()
    static var singleContainer = Dictionary<String,AnyObject>.init()
}


//MARK:AntBusContainer
public class AntBusContainer<T> {
    
}

extension AntBusContainer where T == Any {
    public static var showLog:Bool = true
}

extension AntBusContainer where T:NSObjectProtocol {
    public static var multi:AntBusMultiContainer<T> {
        get {
            let module:String = "\(T.self)"
            var moduleMulti = AntBusContainerStore.multiContainer[module]
            
            if moduleMulti == nil {
                moduleMulti = AntBusMultiContainer<T>.init()
                AntBusContainerStore.multiContainer[module] = moduleMulti
            }
            return moduleMulti as! AntBusMultiContainer<T>
        }
    }
    public static var single:AntBusSingleContainer<T> {
        get {
            let module:String = "\(T.self)"
            var moduleSingle = AntBusContainerStore.singleContainer[module]
            
            if moduleSingle == nil {
                moduleSingle = AntBusSingleContainer<T>.init()
                AntBusContainerStore.singleContainer[module] = moduleSingle
            }
            return moduleSingle as! AntBusSingleContainer<T>
        }
    }
}
