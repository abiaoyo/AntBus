import Foundation

typealias AntBusDeallocHandler = (Set<String>) -> Void

private final class _AntBusDeallocHook {
    private var hkeys = Set<String>.init()
    var deallocHandler:AntBusDeallocHandler?
    var type:String?
    
    func add(_ hkey:String) {
        self.hkeys.insert(hkey)
    }
    
    func remove(_ hkey:String) {
        self.hkeys.remove(hkey)
    }
    
    deinit {
        print("\n--- deinit _AntBusDeallocHook: \n.type:\(type ?? "") \t \n.hkeys:\(hkeys) \n")
        self.deallocHandler?(self.hkeys)
    }
}


final class AntBusDealloc {
    
    private init() {}
    
    static func installDeallocHook(to object: AnyObject, proKey:String, hkey:String, deallocHandler: AntBusDeallocHandler?) {
        var hook:_AntBusDeallocHook? = objc_getAssociatedObject(object, proKey) as? _AntBusDeallocHook
        if let _hook = hook {
            _hook.add(hkey)
            return
        }
        hook = _AntBusDeallocHook()
        hook?.add(hkey)
        hook?.deallocHandler = deallocHandler
        hook?.type = "\(type(of: object))"
        objc_setAssociatedObject(object, proKey, hook, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    
}
