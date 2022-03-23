import UIKit

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


class AntBusWeakMap<Key, Value> where Key: AnyObject {

    private var container: [_Weak<Key>: Value] = [:]
    private let lock = NSRecursiveLock()
    
    func value(forKey key: Key) -> Value?{
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        let weakKey = _Weak(key)
        return self.container[weakKey]
    }
    
    func setValue(_ value:Value, forKey key:Key, hKey:String, deallocHandler: AntBusDeallocHandler?) {
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        let weakKey = _Weak(key)
        self.container[weakKey] = value
        AntBusDealloc.installDeallocHookForWKMap(to: key, hkey: hKey) { [weak self] hKeys in
            self?.lock.lock()
            self?.container.removeValue(forKey: weakKey)
            self?.lock.unlock()
            deallocHandler?(hKeys)
        }
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
}


class AntBusWeakSet<Value:AnyObject> {
    
    private var container = NSHashTable<Value>.init()
    private let lock = NSRecursiveLock()
    
    func insert(_ value:Value, hKey:String, deallocHandler: AntBusDeallocHandler?) {
        self.lock.lock()
        self.container.add(value)
        AntBusDealloc.installDeallocHookForWKSet(to: value, hkey: hKey, deallocHandler: deallocHandler)
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
}
