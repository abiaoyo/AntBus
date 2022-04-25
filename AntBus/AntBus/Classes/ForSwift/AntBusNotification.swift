import Foundation

public typealias AntBusResultBlock = (_ data:Any?) -> Void

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
