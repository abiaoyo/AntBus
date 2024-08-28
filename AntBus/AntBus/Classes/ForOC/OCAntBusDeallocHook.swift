import Foundation

@objcMembers
public class OCAntBusDeallocHook: NSObject {
    public static let shared = OCAntBusDeallocHook()
    
    public func install(for object: AnyObject, propertyKey: String, handlerKey: String, handler: AntBusDeallocHandler?) {
        AntBusDeallocHook.shared.install(for: object, propertyKey: propertyKey, handlerKey: handlerKey, handler: handler)
    }
    
    public func uninstall(for object: AnyObject, propertyKey: String, handlerKey: String) {
        AntBusDeallocHook.shared.uninstall(for: object, propertyKey: propertyKey, handlerKey: handlerKey)
    }
    
    public func uninstall(for object: AnyObject, propertyKey: String) {
        AntBusDeallocHook.shared.uninstall(for: object, propertyKey: propertyKey)
    }
}
