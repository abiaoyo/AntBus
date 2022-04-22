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
        if AntBus.printDealloc {
            print("\n--- deinit _AntBusDeallocHook --- \n.type:\(type ?? "") \t \n.propertyKey:\(propertyKey) \t \n.handlerKeys:\(handlerKeys) \n")
        }
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
            hook!.add(handlerKey)
            return
        }
        hook = _AntBusDeallocHook()
        hook?.propertyKey = propertyKey
        hook?.add(handlerKey)
        hook?.handler = handler
        hook?.type = "\(type(of: object))"
        objc_setAssociatedObject(object, keyPointer, hook, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public func uninstallDeallocHook(for object: AnyObject, propertyKey:String, handlerKey:String) {
        let keyPointer:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: propertyKey.hashValue)
        let hook:_AntBusDeallocHook? = objc_getAssociatedObject(object, keyPointer) as? _AntBusDeallocHook
        hook?.remove(handlerKey)
    }
    
    public func uninstallDeallocHook(for object: AnyObject, propertyKey:String) {
        let keyPointer:UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: propertyKey.hashValue)
        objc_setAssociatedObject(object, keyPointer, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
}
