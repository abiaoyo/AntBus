import Foundation

public typealias AntBusDeallocHandler = (_ handleKeys:Set<String>) -> Void

private final class _AntBusDeallocHook {
    private var handlerKeys = Set<String>.init()
    var handler:AntBusDeallocHandler?
    var type:String?
    var propertyKey:String = ""
    
    func add(_ handlerKey:String) {
        handlerKeys.insert(handlerKey)
    }
    
    func remove(_ handlerKey:String) {
        handlerKeys.remove(handlerKey)
    }
    
    deinit {
        let log = "AntBusDeallocHook deinit: .type:\(type ?? "") \t .pKey:\(propertyKey) \t .hKey:\(handlerKeys)"
        AntBus.deallocLog?(log)
        handler?(handlerKeys)
    }
}


final public class AntBusDeallocHook {
    
    public static let shared = AntBusDeallocHook.init()
    
    private init(){}
    
    private var AntBusDeallocHookKey: Void?
    
    public func installDeallocHook(for object: AnyObject, propertyKey:String, handlerKey:String, handler: AntBusDeallocHandler?) {
        
        let keyPointer:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: propertyKey.hashValue)
        var hook:_AntBusDeallocHook? = objc_getAssociatedObject(object, keyPointer) as? _AntBusDeallocHook
        if let _ = hook {
            let log = "AntBusDeallocHook install _add: .type:\(hook!.type ?? "") \t .pKey:\(hook!.propertyKey) \t .hKey:\(handlerKey)"
            AntBus.deallocLog?(log)
            
            hook!.add(handlerKey)
            return
        }
        hook = _AntBusDeallocHook()
        hook?.propertyKey = propertyKey
        hook?.handler = handler
        hook?.type = "\(type(of: object))"
        hook?.add(handlerKey)
        objc_setAssociatedObject(object, keyPointer, hook, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        let log = "AntBusDeallocHook install _new: .type:\(hook!.type ?? "") \t .pKey:\(hook!.propertyKey) \t .hKey:\(handlerKey)"
        AntBus.deallocLog?(log)
    }
    
    public func uninstallDeallocHook(for object: AnyObject, propertyKey:String, handlerKey:String) {
        let keyPointer:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: propertyKey.hashValue)
        let hook:_AntBusDeallocHook? = objc_getAssociatedObject(object, keyPointer) as? _AntBusDeallocHook
        hook?.remove(handlerKey)
        
        let log = "AntBusDeallocHook uninstall: .type:\(hook!.type ?? "") \t .pKey:\(hook!.propertyKey) \t .hKey:\(handlerKey)"
        AntBus.deallocLog?(log)
    }
    
    public func uninstallDeallocHook(for object: AnyObject, propertyKey:String) {
        let keyPointer:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: propertyKey.hashValue)
        objc_setAssociatedObject(object, keyPointer, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        let log = "AntBusDeallocHook uninstall: .type:\(type(of: object)) \t .pKey:\(propertyKey)"
        AntBus.deallocLog?(log)
    }
    
}
