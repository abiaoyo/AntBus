import Foundation

class SafeMutableArray {
    
    init() {
        
    }
    
    fileprivate let queue = DispatchQueue(label: "antbus.safe.mutable.array.rwQueue", attributes: .concurrent)
    fileprivate var array = NSMutableArray()
    
    func add(_ object:AnyObject) {
        queue.async(flags: .barrier) {
            self.array.add(object)
        }
    }
    
    var elements:[AnyObject] {
        queue.sync {
            self.array as [AnyObject]
        }
    }
    
    var count:Int {
        queue.sync {
            self.array.count
        }
    }
}
