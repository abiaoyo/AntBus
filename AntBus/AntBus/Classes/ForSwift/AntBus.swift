import Foundation

public typealias AntBusResult = (success:Bool, value:Any?)
public typealias AntBusResultBlock = (_ data:Any?) -> Void
public typealias AntBusDataHandler = () -> Any?

//MARK: - AntBusData 共享 - 用于数据共享 - 临时存储
final public class AntBusData{
    
    //<key,owner>
    static private var keyOwnerMap = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    //<owner,[<key,handler>]>
    static private var ownerHandlersMap = AntBusWKMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.init()
    
    private var keyOwnerMap:NSMapTable<NSString,AnyObject> { get { return AntBusData.keyOwnerMap }}
    private var ownerHandlersMap:AntBusWKMapTable<AnyObject,NSMapTable<NSString,AnyObject>> { get { AntBusData.ownerHandlersMap }}
    
    private func clearOwner(_ key:String){
        if let owner = keyOwnerMap.object(forKey: key as NSString) {
            ownerHandlersMap.value(forKey: owner)?.removeObject(forKey: key as NSString?)
        }
    }
    
    private func handler(forKey key: String) -> AntBusDataHandler?{
        if let owner = AntBusData.keyOwnerMap.object(forKey: key as NSString) {
            return AntBusData.ownerHandlersMap.value(forKey: owner)?.object(forKey: key as NSString) as? AntBusDataHandler
        }
        return nil
    }
    
    // ==================================================================
    public func register(_ key:String, owner:AnyObject, handler:@escaping AntBusDataHandler){
        clearOwner(key)
        keyOwnerMap.setObject(owner, forKey: key as NSString)
        
        var khMap = ownerHandlersMap.value(forKey: owner)
        if khMap == nil {
            khMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
        }
        khMap?.setObject(handler as AnyObject, forKey: key as NSString)
        
        ownerHandlersMap.setValue(khMap,forKey:owner)
        AntBusDeallocHook.shared.installDeallocHook(for: owner, propertyKey: "AntBusData", handlerKey: key) { hkeys in
            AntBusData.keyOwnerMap.removeObject(forKey: key as NSString)
        }
    }
    
    public func canCall(_ key:String) -> Bool {
        return handler(forKey: key) != nil
    }
    
    public func call(_ key:String) -> AntBusResult{
        if let handler = handler(forKey: key) {
            return (success:true, value:handler())
        }
        return (success:false, value:nil)
    }
    
    public func remove(_ key:String){
        clearOwner(key)
    }
    
    public func removeAll(){
        keyOwnerMap.removeAllObjects()
        ownerHandlersMap.removeAll()
    }
}

//MARK: - AntBusNotification 通知 - 自定义的一个通知功能
final public class AntBusNotification{
    //<key,owners>
    private static var ownerContainer = Dictionary<String,NSHashTable<AnyObject>>.init()
    //<owner,[<key,handler>]>
    private static var handlerContainer = AntBusWKMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.init()
    
    // ==================================================================
    public func register(_ key:String,owner:AnyObject,handler:@escaping AntBusResultBlock){
        var oTable = AntBusNotification.ownerContainer[key]
        if(oTable == nil){
            oTable = NSHashTable<AnyObject>.weakObjects();
            AntBusNotification.ownerContainer[key] = oTable
        }
        oTable!.add(owner)
        
        var khMap = AntBusNotification.handlerContainer.value(forKey:owner)
        if(khMap == nil){
            khMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            AntBusNotification.handlerContainer.setValue(khMap,forKey:owner)
        }
        khMap!.setObject(handler as AnyObject,forKey:key as NSString)
        
        AntBusDeallocHook.shared.installDeallocHook(for: owner, propertyKey: "AntBusNotification", handlerKey: key) { hkeys in
            for hkey in hkeys {
                if AntBusNotification.ownerContainer[hkey]?.allObjects.count == 0 {
                    AntBusNotification.ownerContainer.removeValue(forKey: hkey)
                }
            }
        }
    }
    
    public func post(_ key:String,data:Any?){
        if let oTable = AntBusNotification.ownerContainer[key] {
            for owner in oTable.allObjects {
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
        if let oTable = AntBusNotification.ownerContainer[key] {
            oTable.allObjects.forEach { owner in
                AntBusNotification.handlerContainer.value(forKey:owner)?.removeObject(forKey: key as NSString?)
            }
            oTable.removeAllObjects()
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
    public static var printAliasName = false
    public static var printDealloc = false
}
