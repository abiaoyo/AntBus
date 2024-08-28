import Foundation

@objcMembers
public class OCAntBusData: NSObject {
    public static let shared = OCAntBusData()
    
    public func register(key: String, owner: AnyObject, handler: @escaping AntBusData.DataHandler) {
        AntBus.plus.data.register(key, owner: owner, handler: handler)
    }
    
    public func canCall(key: String) -> Bool {
        return AntBus.plus.data.canCall(key)
    }
    
    public func call(key: String) -> Any? {
        return AntBus.plus.data.call(key)
    }
    
    public func remove(key: String) {
        AntBus.plus.data.remove(key)
    }
    
    public func removeAll() {
        AntBus.plus.data.removeAll()
    }
}
