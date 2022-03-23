import UIKit

public typealias AntBusWKMap_KeyDeallocHandler = (_ kdKeys:Set<String>) -> Void

public class AntBusWeakMap<Key, Value> where Key: AnyObject {

    private var container: [_Weak<Key>: Value] = [:]
    private let lock = NSRecursiveLock()
    
    func valueForKey(_ key: Key) -> Value?{
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        let weakKey = _Weak(key)
        return self.container[weakKey]
    }
    
    func setValue(_ value:Value, forKey key:Key, kdKey:String, keyDeallocHandler: AntBusWKMap_KeyDeallocHandler?) {
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        let weakKey = _Weak(key)
        self.container[weakKey] = value
        self.installDeallocHook(to: key, kdKey: kdKey, keyDeallocHandler: keyDeallocHandler)
    }
    
    func removeValue(_ key: Key) {
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        let weakKey = _Weak(key)
        self.container.removeValue(forKey: weakKey)
    }
    
    func removeAll() {
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        self.container.removeAll()
    }
    
    private var WKMapDeallocHookKey: Void?
    
    private func installDeallocHook(to key: Key, kdKey:String, keyDeallocHandler: AntBusWKMap_KeyDeallocHandler?) {
        var hook:_DeallocHook? = objc_getAssociatedObject(key, &WKMapDeallocHookKey) as? _DeallocHook
        if let _hook = hook {
            _hook.insert(kdKey)
            return
        }
        let weakKey = _Weak(key)
        hook = _DeallocHook(handler: { [weak self] in
            self?.lock.lock()
            self?.container.removeValue(forKey: weakKey)
            self?.lock.unlock()
        })
        hook?.typeName = weakKey.typeName
        hook?.insert(kdKey)
        hook?.keyDeallocHandler = keyDeallocHandler
        objc_setAssociatedObject(key, &WKMapDeallocHookKey, hook, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}


public class AntBusWeakSet<Value:AnyObject> {
    
    private var container = NSHashTable<Value>.init()
    private let lock = NSRecursiveLock()
    
    func insert(_ value:Value, kdKey:String, keyDeallocHandler: AntBusWKMap_KeyDeallocHandler?) {
        self.lock.lock()
        self.container.add(value)
        self.installDeallocHook(to: value, kdKey: kdKey, keyDeallocHandler: keyDeallocHandler)
        self.lock.unlock()
    }
    
    func remove(_ value:Value) {
        self.lock.lock()
        self.container.remove(value)
        self.lock.unlock()
    }
    
    func removeAll(){
        self.lock.lock()
        self.container.removeAllObjects()
        self.lock.unlock()
    }
    
    func allValues() -> [Value]?{
        return self.container.allObjects
    }
    
    func count() -> Int{
        return self.container.allObjects.count
    }
    
    private var WKSetDeallocHookKey: Void?
    
    private func installDeallocHook(to value: Value, kdKey:String, keyDeallocHandler: AntBusWKMap_KeyDeallocHandler?) {
        var hook:_DeallocHook? = objc_getAssociatedObject(value, &WKSetDeallocHookKey) as? _DeallocHook
        if let _hook = hook {
            _hook.insert(kdKey)
            return
        }
        let weakKey = _Weak(value)
        hook = _DeallocHook(handler: {
            
        })
        hook?.insert(kdKey)
        hook?.typeName = weakKey.typeName
        hook?.keyDeallocHandler = keyDeallocHandler
        objc_setAssociatedObject(value, &WKSetDeallocHookKey, hook, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}




private final class _Weak<T>: Hashable where T: AnyObject {
    private let objectHashValue: Int
    weak var object: T?
    var typeName:String?
    
    init(_ object: T) {
        self.object = object
        self.objectHashValue = ObjectIdentifier(object).hashValue
        self.typeName = "\(type(of: object))"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.objectHashValue)
    }
    
    static func == (lhs: _Weak<T>, rhs: _Weak<T>) -> Bool {
        return lhs.objectHashValue == rhs.objectHashValue
    }
}

private final class _DeallocHook {
    private let handler: () -> Void
    private var kdKeys = Set<String>.init()
    var typeName:String?
    var keyDeallocHandler:AntBusWKMap_KeyDeallocHandler?
    
    init(handler: @escaping () -> Void) {
        self.handler = handler
    }
    
    func insert(_ kdKey:String) {
        self.kdKeys.insert(kdKey)
    }
    
    deinit {
        self.handler()
        self.keyDeallocHandler?(kdKeys)
    }
}
