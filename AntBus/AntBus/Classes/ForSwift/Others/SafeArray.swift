import Foundation

class SafeArray<V> {
    
    fileprivate let queue = DispatchQueue(label: "antbus.safe.array.rwQueue", attributes: .concurrent)
    private var array = [V]()
    
    public init() {}
}
