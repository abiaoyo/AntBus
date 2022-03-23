import Foundation

public typealias AntBusResult = (success:Bool,data:Any?)
public typealias AntBusResultBlock = (_ data:Any?) -> Void
public typealias AntBusDataHandler = () -> Any?

//MARK: - AntBusData 共享 - 用于数据共享 - 临时存储
public class AntBusData{
    
    private var keyOwnerMap = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    private var ownerHandlerMap = AntBusWKMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.init()
    
    private func clearOldOwner(_ key:String){
        if let oldOwner = self.keyOwnerMap.object(forKey: key as NSString) {
            if let keyHandlerMap = self.ownerHandlerMap.value(forKey: oldOwner) {
                keyHandlerMap.removeObject(forKey: key as NSString?)
            }
        }
    }
    
    private func getHandler(_ key: String) -> AntBusDataHandler?{
        if let owner = self.keyOwnerMap.object(forKey: key as NSString) {
            if let keyHandlerMap = self.ownerHandlerMap.value(forKey: owner) {
                if let handler:AntBusDataHandler = keyHandlerMap.object(forKey: key as NSString?) as? AntBusDataHandler {
                    return handler
                }
            }
        }
        return nil
    }
    
    public func register(_ key:String,owner:AnyObject,handler:AntBusDataHandler!){
        self.clearOldOwner(key)
        self.keyOwnerMap.setObject(owner, forKey: key as NSString)
        var keyHandlerMap = self.ownerHandlerMap.value(forKey: owner)
        if keyHandlerMap == nil {
            keyHandlerMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            self.ownerHandlerMap.setValue(keyHandlerMap, forKey: owner) { [weak self] in
                self?.keyOwnerMap.removeObject(forKey: key as NSString?)
            }
        }
        keyHandlerMap?.setObject(handler as AnyObject, forKey: key as NSString?)
    }

    public func canCall(_ key:String) -> Bool {
        if let _:AntBusDataHandler = self.getHandler(key) {
            return true
        }
        return false
    }
    
    public func call(_ key:String) -> AntBusResult{
        if let handler:AntBusDataHandler = self.getHandler(key) {
            let data:Any? = handler()
            return (success:true, data:data)
        }
        return (success:false, data:nil)
    }
    
    public func remove(_ key:String){
        self.clearOldOwner(key)
    }
    
    public func removeAll(){
        self.keyOwnerMap.removeAllObjects()
        self.ownerHandlerMap.removeAll()
    }
}

//MARK: - AntBusNotification 通知 - 自定义的一个通知功能
public class AntBusNotification{
    
    private var keyOwnersMap = Dictionary<String,NSHashTable<AnyObject>>.init()
    private var ownerKeyHandlerMap = AntBusWKMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.init()

    public func register(_ key:String,owner:AnyObject,handler:AntBusResultBlock!){
        var ownersTable = self.keyOwnersMap[key]
        if(ownersTable == nil){
            ownersTable = NSHashTable<AnyObject>.weakObjects();
            self.keyOwnersMap[key] = ownersTable
        }
        ownersTable!.add(owner)
        var keyHandlerMap = self.ownerKeyHandlerMap.value(forKey:owner)
        if(keyHandlerMap == nil){
            keyHandlerMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            self.ownerKeyHandlerMap.setValue(keyHandlerMap,forKey:owner) {
                //...
            }
        }
        keyHandlerMap!.setObject(handler as AnyObject,forKey:key as NSString)
    }

    public func post(_ key:String,data:Any?){
        if let ownersTable = self.keyOwnersMap[key] {
            for owner in ownersTable.allObjects {
                if let keyHandlerMap:NSMapTable<NSString,AnyObject> = self.ownerKeyHandlerMap.value(forKey:owner) {
                    if let handler:AntBusResultBlock = keyHandlerMap.object(forKey:key as NSString) as? AntBusResultBlock {
                        handler(data)
                    }
                }
            }
        }
    }
    
    public func post(_ key:String){
        self.post(key, data: nil)
    }

    public func remove(_ key:String,owner:AnyObject){
        if let ownersTable = self.keyOwnersMap[key] {
            ownersTable.remove(owner)
        }
        if let keyHandlerMap = self.ownerKeyHandlerMap.value(forKey:owner) {
            keyHandlerMap.removeObject(forKey:key as NSString?)
        }
    }
    
    public func remove(_ key:String){
        if let ownersTable = self.keyOwnersMap[key] {
            for owner in ownersTable.allObjects {
                if let keyHandlerMap = self.ownerKeyHandlerMap.value(forKey:owner) {
                    keyHandlerMap.removeObject(forKey:key as NSString?)
                }
            }
            ownersTable.removeAllObjects()
        }
    }

    public func remove(owner:AnyObject){
        self.ownerKeyHandlerMap.remove(forKey: owner)
    }

    public func removeAll(){
        self.keyOwnersMap.removeAll()
        self.ownerKeyHandlerMap.removeAll()
    }
}

final public class AntBusObj{
    
    private var koMap = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    private var ooMap = AntBusWKMapTable<AnyObject,NSMutableDictionary>()
    
    public func register(_ key:String, object:AnyObject, owner:AnyObject){
        self.koMap.setObject(owner, forKey: key as NSString)
        var objs = self.ooMap.value(forKey: owner)
        if objs == nil {
            objs = NSMutableDictionary.init()
            self.ooMap.setValue(objs, forKey: owner) { [weak self] in
                self?.koMap.removeObject(forKey: key as NSString)
            }
        }
        objs?.setValue(object, forKey: key)
    }
    
    public func call(_ key:String) -> AnyObject?{
        
        if let owner = self.koMap.object(forKey: key as NSString) {
            if let objs = self.ooMap.value(forKey: owner) {
                return objs.value(forKey: key) as AnyObject
            }
        }
        return nil
    }
    
    public func remove(_ key:String) {
        if let owner = self.koMap.object(forKey: key as NSString) {
            let objs = self.ooMap.value(forKey: owner)
            objs?.removeObject(forKey: key)
        }
    }
    
    public func removeAll() {
        self.koMap.removeAllObjects()
        self.ooMap.removeAll()
    }
}

final public class AntBusSharedObj{
    private var koMap = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    private var ooMap = AntBusWKMapTable<AnyObject,NSMutableDictionary>()
    
    public func register<T:AnyObject>(_ object:T,type:T.Type, owner:AnyObject){
        let key = DynamicAliasUtil.getAliasName(T.self)
        self.koMap.setObject(owner, forKey: key as NSString)
        var objs = self.ooMap.value(forKey: owner)
        if objs == nil {
            objs = NSMutableDictionary.init()
            self.ooMap.setValue(objs, forKey: owner) { [weak self] in
                self?.koMap.removeObject(forKey: key as NSString)
            }
        }
        objs?.setValue(object, forKey: key)
    }
    
    public func object<T:AnyObject>(_ type:T.Type) -> T?{
        let key = DynamicAliasUtil.getAliasName(T.self)
        if let owner = self.koMap.object(forKey: key as NSString) {
            let objs = self.ooMap.value(forKey: owner)
            return objs?.value(forKey: key) as? T
        }
        return nil
    }
    
    public func remove<T:AnyObject>(_ type:T.Type) {
        let key = DynamicAliasUtil.getAliasName(T.self)
        if let owner = self.koMap.object(forKey: key as NSString) {
            let objs = self.ooMap.value(forKey: owner)
            objs?.removeObject(forKey: key)
        }
    }
}


/// MARK: - AntBus - 基于数据共享的远程调用，回调绑定到owner的生命周期
/// data用于获取数据，跨界面/模块的数据调用
/// notification用于通知，带回调的自定义通知
public class AntBus {
    public static var data = AntBusData()
    public static var notification = AntBusNotification()
    public static var object = AntBusObj()
    public static var sharedObject = AntBusSharedObj()
}
