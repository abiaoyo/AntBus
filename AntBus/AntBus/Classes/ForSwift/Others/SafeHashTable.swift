import Foundation

class SafeHashTable<V:AnyObject> {
    
    static func weakObjects() -> SafeHashTable<V> {
        let v = SafeHashTable<V>()
        let table = NSHashTable<V>.weakObjects()
        v.table = table
        return v
    }
    
    init() {
        
    }
    
    fileprivate var table:NSHashTable<V>!
    fileprivate let queue = DispatchQueue(label: "antbus.safe.hashtable.rwQueue", attributes: .concurrent)
    
    func add(_ object:V) {
        queue.async(flags: .barrier) {[weak self] in
            self?.table.add(object)
        }
    }
    func removeAllObjects() {
        queue.async(flags: .barrier) {[weak self] in
            self?.table.removeAllObjects()
        }
    }
    
    func remove(_ object:V) {
        queue.async(flags: .barrier) {[weak self] in
            self?.table.remove(object)
        }
    }
    
    var allObjects:[V] {
        queue.sync {
            return self.table.allObjects
        }
    }
    
    var count:Int {
        queue.sync {
            return self.table.count
        }
    }
    
}
