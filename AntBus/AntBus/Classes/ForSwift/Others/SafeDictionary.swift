import Foundation

class SafeDictionary<K: Hashable, V> {
    
    fileprivate let queue = DispatchQueue(label: "antbus.safe.dictionary.rwQueue", attributes: .concurrent)
    private var dictionary = [K: V]()
    
    public init() {}

    subscript(key: K) -> V? {
        set(newValue) {
            queue.async(flags: .barrier) {[weak self] in
                self?.dictionary[key] = newValue
            }
        }
        get {
            queue.sync {
                return self.dictionary[key]
            }
        }
    }
    
    func toDictionary() -> [K:V] {
        return dictionary
    }
    
    func removeValue(forKey key: K) {
        queue.async(flags: .barrier) {[weak self] in
            self?.dictionary.removeValue(forKey: key)
        }
    }

    func removeAll() {
        queue.async(flags: .barrier) {[weak self] in
            self?.dictionary.removeAll()
        }
    }
    
    func updateValue(_ value: V, forKey key: K) {
        queue.async(flags: .barrier) {[weak self] in
            self?.dictionary.updateValue(value, forKey: key)
        }
    }
}
