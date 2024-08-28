import Foundation

class SafeMutableDictionary {
    
    init() {
        
    }
    
    fileprivate let queue = DispatchQueue(label: "antbus.safe.mutable.dictionary.rwQueue", attributes: .concurrent)
    fileprivate var dictionary = NSMutableDictionary()
    
    subscript(key: String) -> AnyObject? {
        set(newValue) {
            queue.async(flags: .barrier) {[weak self] in
                self?.dictionary[key] = newValue
            }
        }
        get {
            queue.sync {
                return self.dictionary[key] as AnyObject?
            }
        }
    }
    
    func object(forKey key:String) -> AnyObject? {
        queue.sync {
            dictionary.object(forKey:key) as? AnyObject
        }
    }
    
    func setObject(_ object:AnyObject, forKey key:String) {
        queue.async(flags: .barrier) {[weak self] in
            self?.dictionary.setObject(object, forKey: key as NSString)
        }
    }
    
    func removeObject(forKey key:String) {
        queue.async(flags: .barrier) {[weak self] in
            self?.dictionary.removeObject(forKey: key)
        }
    }
    
    func removeAllObjects() {
        queue.async(flags: .barrier) {[weak self] in
            self?.dictionary.removeAllObjects()
        }
    }
    
    func toDictionary() -> NSDictionary {
        queue.sync {
            self.dictionary.copy() as! NSDictionary
        }
    }
    
    var allKeys: [String] {
        queue.sync {
            self.dictionary.allKeys.compactMap({ $0 as? String })
        }
    }
    
    var allValues: [Any] {
        queue.sync {
            self.dictionary.allValues
        }
    }
    
}
