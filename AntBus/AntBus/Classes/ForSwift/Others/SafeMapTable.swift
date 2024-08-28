import Foundation

class SafeMapTable<K:NSString, V:AnyObject> {
    
    static func strongToWeak() -> SafeMapTable<K,V> {
        let v = SafeMapTable<K,V>()
        let map = NSMapTable<K, V>.strongToWeakObjects()
        v.map = map
        return v
    }
    
    static func strongToStrong() -> SafeMapTable<K,V> {
        let v = SafeMapTable<K,V>()
        let map = NSMapTable<K, V>.strongToStrongObjects()
        v.map = map
        return v
    }
    
    static func weakToStrong() -> SafeMapTable<K,V> {
        let v = SafeMapTable<K,V>()
        let map = NSMapTable<K, V>.weakToStrongObjects()
        v.map = map
        return v
    }
    
    init() {
        
    }
    
    fileprivate let queue = DispatchQueue(label: "antbus.safe.maptable.rwQueue", attributes: .concurrent)
    fileprivate var map:NSMapTable<K,V>!
    
    func object(forKey key:K) -> V? {
        queue.sync {
            return map.object(forKey:key)
        }
    }
    
    func setObject(_ object:V, forKey key:K) {
        queue.async(flags: .barrier) {
            self.map.setObject(object, forKey: key)
        }
    }
    
    func removeObject(forKey key:K?) {
        queue.async(flags: .barrier) {
            self.map.removeObject(forKey: key)
        }
    }
    
    func removeAllObjects() {
        queue.async(flags: .barrier) {
            self.map.removeAllObjects()
        }
    }
    
    func dictionaryRepresentation() -> NSDictionary {
        queue.sync {
            return map.dictionaryRepresentation() as NSDictionary
        }
    }
    
}
