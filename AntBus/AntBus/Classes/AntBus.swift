import Foundation

public typealias AntBusResult = (success:Bool,data:Any?)
public typealias AntBusResultBlock = (_ data:Any?) -> Void

//MARK: - AntBusNotification 通知 - 自定义的一个通知功能
final public class AntBusNotification{
    
    private static var ownerContainer = Dictionary<String,NSHashTable<AnyObject>>.init()
    private static var handlerContainer = AntBusWKMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.init()

    public func register(_ key:String,owner:AnyObject,handler:AntBusResultBlock!){
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
        
        AntBusDealloc.installDeallocHook(to: owner, proKey: "AntBusNotification", hkey: key) { hkeys in
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
                if let keyHandlerMap:NSMapTable<NSString,AnyObject> = AntBusNotification.handlerContainer.value(forKey:owner) {
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
        if let ownersTable = AntBusNotification.ownerContainer[key] {
            ownersTable.remove(owner)
        }
        if let keyHandlerMap = AntBusNotification.handlerContainer.value(forKey:owner) {
            keyHandlerMap.removeObject(forKey:key as NSString?)
        }
    }
    
    public func remove(_ key:String){
        if let ownersTable = AntBusNotification.ownerContainer[key] {
            for owner in ownersTable.allObjects {
                if let keyHandlerMap = AntBusNotification.handlerContainer.value(forKey:owner) {
                    keyHandlerMap.removeObject(forKey:key as NSString?)
                }
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
    public static var notification = AntBusNotification()
}
