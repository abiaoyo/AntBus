import Foundation

@objcMembers
public class OCAntBusKVO: NSObject {
    
    public static let shared = OCAntBusKVO()
    
    public func add(keyPath: String, forObject obj: AnyObject, handler: AntBusKVOHandler!) {
        AntBusKVO.shared.add(keyPath: keyPath, for: obj, handler: handler)
    }
    
    public func remove(keyPath: String, forObject obj: AnyObject) {
        AntBusKVO.shared.remove(keyPath: keyPath, for: obj)
    }
}
