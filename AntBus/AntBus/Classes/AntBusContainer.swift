//
//  AntBusContainer.swift
//  AntBus
//
//  Created by liyebiao on 2021/6/11.
//

import Foundation

//MARK:AntBusSingleContainer
public class AntBusSingleContainer<T:NSObjectProtocol> {

    var container = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    
    public func register(_ responser:T) -> Void{
        let module:String = "\(T.self)"
        if AntBusContainer.showLog {
            print("AntBusSingleContainer register: .module:\(module)  \t  .responser:\(responser)")
        }
        self.container.setObject(responser, forKey: module as NSString)
    }
    public func remove() -> Void{
        let module:String = "\(T.self)"
        if AntBusContainer.showLog {
            print("AntBusSingleContainer remove: .module:\(module)")
        }
        self.container.removeObject(forKey: module as NSString)
    }
    
    public func responser() -> T? {
        let module:String = "\(T.self)"
        if AntBusContainer.showLog {
            print("AntBusSingleContainer responser: .module:\(module)")
        }
        return self.container.object(forKey: module as NSString) as? T
    }
}

//MARK:AntBusMultiContainer
public class AntBusMultiContainer<T:NSObjectProtocol> {
    
    //<Key,[AnyObject]>
    var container = NSMapTable<NSString,NSHashTable<T>>.strongToStrongObjects()
    
    public func register(_ keys:[String], _ responser:T) -> Void{
        
        if AntBusContainer.showLog {
            let module:String = "\(T.self)"
            print("AntBusMultiContainer register: .module:\(module)  \t  keys:\(keys)  \t  .responser:\(responser)")
        }

        for key in keys {
            var responsers = self.container.object(forKey: key as NSString)
            if responsers == nil {
                responsers = NSHashTable<T>.weakObjects()
                self.container.setObject(responsers, forKey: key as NSString)
            }
            responsers!.add(responser)
        }
    }

    @discardableResult
    public func responsers(_ key:String) -> [T]? {
        let module:String = "\(T.self)"
        
        if let responsers = self.container.object(forKey: key as NSString) {
            if AntBusContainer.showLog {
                print("AntBusMultiContainer responsers: .module:\(module)  \t  key:\(key)  \t  .responsers:\(responsers.allObjects)")
            }
            return responsers.allObjects
        }
        if AntBusContainer.showLog {
            print("AntBusMultiContainer responsers: .module:\(module)  \t  key:\(key)")
        }
        return nil
    }

    @discardableResult
    public func responsers() -> [T]? {
        let module:String = "\(T.self)"
        
        if let responsers:[AnyObject] = self.container.objectEnumerator()?.allObjects.flatMap({ ($0 as! NSHashTable<AnyObject>).objectEnumerator().map{ $0 }}) as [AnyObject]? {
            let results = NSHashTable<T>.init()
            for resp in responsers {
                results.add(resp as? T)
            }
            if AntBusContainer.showLog {
                print("AntBusMultiContainer responsers: .module:\(module)  \t  .responsers:\(results.allObjects)")
            }
            return results.allObjects
        }
        if AntBusContainer.showLog {
            print("AntBusMultiContainer responsers: .module:\(module)")
        }
        return nil
    }

    public func remove(_ key:String,_ responser:T) -> Void{
        let module:String = "\(T.self)"
        if AntBusContainer.showLog {
            print("AntBusMultiContainer remove: .module:\(module)  \t  key:\(key)  \t  .responser:\(responser)")
        }
        if let responsers = self.container.object(forKey: key as NSString) {
            responsers.remove(responser)
        }
    }
    
    public func remove(_ key:String) -> Void{
        let module:String = "\(T.self)"
        if AntBusContainer.showLog {
            print("AntBusMultiContainer remove: .module:\(module)  \t  key:\(key)")
        }
        if let responsers = self.container.object(forKey: key as NSString) {
            responsers.removeAllObjects()
        }
    }
    public func remove() -> Void {
        if AntBusContainer.showLog {
            print("AntBusMultiContainer remove: all responsers")
        }
        self.container.removeAllObjects()
    }
}

//MARK:AntBusContainerHelper
class AntBusContainerHelper{
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
            let key = "multi_"+"\(T.self)"
            var moduleMulti = AntBusContainerHelper.multiContainer[key]
            
            if moduleMulti == nil {
                moduleMulti = AntBusMultiContainer<T>.init()
                AntBusContainerHelper.multiContainer[key] = moduleMulti
            }
            return moduleMulti as! AntBusMultiContainer<T>
        }
    }
    public static var single:AntBusSingleContainer<T> {
        get {
            let key = "single_"+"\(T.self)"
            var moduleSingle = AntBusContainerHelper.singleContainer[key]
            
            if moduleSingle == nil {
                moduleSingle = AntBusSingleContainer<T>.init()
                AntBusContainerHelper.singleContainer[key] = moduleSingle
            }
            return moduleSingle as! AntBusSingleContainer<T>
        }
    }
}
