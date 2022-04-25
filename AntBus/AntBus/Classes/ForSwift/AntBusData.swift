import Foundation

public typealias AntBusDataHandler = () -> Any?

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
    
    public func call(_ key:String) -> (success:Bool, value:Any?){
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
