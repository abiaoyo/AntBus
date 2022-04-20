import Foundation

public typealias AntBusResult = (success:Bool, value:Any?)
public typealias AntBusResultBlock = (_ data:Any?) -> Void
public typealias AntBusDataHandler = () -> Any?

//MARK: - AntBusData 共享 - 用于数据共享 - 临时存储
final public class AntBusData{
    
    static private var keyOwnerMap = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    static private var ownerHandlersMap = AntBusWKMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.init()
    
    private func clearOldOwner(_ key:String){
        if let oldOwner = AntBusData.keyOwnerMap.object(forKey: key as NSString) {
            AntBusData.ownerHandlersMap.value(forKey: oldOwner)?.removeObject(forKey: key as NSString?)
        }
    }
    
    private func getHandler(_ key: String) -> AntBusDataHandler?{
        if let owner = AntBusData.keyOwnerMap.object(forKey: key as NSString) {
            return AntBusData.ownerHandlersMap.value(forKey: owner)?.object(forKey: key as NSString) as? AntBusDataHandler
        }
        return nil
    }
    
    public func register(_ key:String,owner:AnyObject,handler:@escaping AntBusDataHandler){
        clearOldOwner(key)
        AntBusData.keyOwnerMap.setObject(owner, forKey: key as NSString)
        var keyHandlerMap = AntBusData.ownerHandlersMap.value(forKey: owner)
        if keyHandlerMap == nil {
            keyHandlerMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
        }
        keyHandlerMap?.setObject(handler as AnyObject, forKey: key as NSString)
        
        AntBusData.ownerHandlersMap.setValue(keyHandlerMap,forKey:owner)
        AntBusDeallocHook.shared.installDeallocHook(for: owner, propertyKey: "AntBusData", handlerKey: key) { hkeys in
            AntBusData.keyOwnerMap.removeObject(forKey: key as NSString)
        }
    }

    public func canCall(_ key:String) -> Bool {
        return getHandler(key) != nil
    }
    
    public func call(_ key:String) -> AntBusResult{
        if let handler = getHandler(key) {
            return (success:true, value:handler())
        }
        return (success:false, value:nil)
    }
    
    public func remove(_ key:String){
        clearOldOwner(key)
    }
    
    public func removeAll(){
        AntBusData.keyOwnerMap.removeAllObjects()
        AntBusData.ownerHandlersMap.removeAll()
    }
}

//MARK: - AntBusNotification 通知 - 自定义的一个通知功能
final public class AntBusNotification{
    
    private static var ownerContainer = Dictionary<String,NSHashTable<AnyObject>>.init()
    private static var handlerContainer = AntBusWKMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.init()

    public func register(_ key:String,owner:AnyObject,handler:@escaping AntBusResultBlock){
        var ownersTable = AntBusNotification.ownerContainer[key]
        if(ownersTable == nil){
            ownersTable = NSHashTable<AnyObject>.weakObjects();
            AntBusNotification.ownerContainer[key] = ownersTable
        }
        ownersTable!.add(owner)
        
        var keyHandlerMap = AntBusNotification.handlerContainer.value(forKey:owner)
        if(keyHandlerMap == nil){
            keyHandlerMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            AntBusNotification.handlerContainer.setValue(keyHandlerMap,forKey:owner)
        }
        keyHandlerMap!.setObject(handler as AnyObject,forKey:key as NSString)
        
        AntBusDeallocHook.shared.installDeallocHook(for: owner, propertyKey: "AntBusNotification", handlerKey: key) { hkeys in
            for hkey in hkeys {
                if AntBusNotification.ownerContainer[hkey]?.allObjects.count == 0 {
                    AntBusNotification.ownerContainer.removeValue(forKey: hkey)
                }
            }
        }
    }

    public func post(_ key:String,data:Any?){
        if let ownersTable = AntBusNotification.ownerContainer[key] {
            for owner in ownersTable.allObjects {
                (AntBusNotification.handlerContainer.value(forKey:owner)?.object(forKey:key as NSString) as? AntBusResultBlock)?(data)
            }
        }
    }
    
    public func post(_ key:String){
        post(key, data: nil)
    }

    public func remove(_ key:String,owner:AnyObject){
        AntBusNotification.ownerContainer[key]?.remove(owner)
        AntBusNotification.handlerContainer.value(forKey:owner)?.removeObject(forKey: key as NSString?)
    }
    
    public func remove(_ key:String){
        if let ownersTable = AntBusNotification.ownerContainer[key] {
            ownersTable.allObjects.forEach { owner in
                AntBusNotification.handlerContainer.value(forKey:owner)?.removeObject(forKey: key as NSString?)
            }
            ownersTable.removeAllObjects()
        }
    }

    public func remove(owner:AnyObject){
        AntBusNotification.handlerContainer.remove(forKey: owner)
    }

    public func removeAll(){
        AntBusNotification.ownerContainer.removeAll()
        AntBusNotification.handlerContainer.removeAll()
    }
}

final public class AntBus {
    public static let data = AntBusData()
    public static let notification = AntBusNotification()
    public static let deallocHook = AntBusDeallocHook.shared
    public static let listener = AntBusListener.shared
}
