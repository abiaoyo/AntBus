import Foundation

public typealias AntBusKVOHandler = (_ oldVal: Any?, _ newVal: Any?) -> Void

public final class AntBusKVO{
    
    public static let shared = AntBusKVO()
    
    private var AntBusKVO_container_key: Void?
    
    public func add(keyPath: String, for object: AnyObject, handler: AntBusKVOHandler!){

        AntBus.log.handler?(.kvo, "AntBus.plus.kvo.add: keyPath:\(keyPath) \t object:\(object) \t handler:\(String(describing: handler))")
        
        var container = objc_getAssociatedObject(object, &AntBusKVO_container_key) as? AntBusKVOContainer
        
        if container == nil {
            container = AntBusKVOContainer(target: object)
            objc_setAssociatedObject(object, &AntBusKVO_container_key, container, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            AntBusDeallocHook.shared.install(for: object, propertyKey: "AntBusKVO", handlerKey: "AntBusKVOHandler") { _ in
                container?.removeKVO()
            }
        }
        container?.addKVO(keyPath: keyPath, handler: handler)
    }
    
    public func remove(keyPath: String, for object: AnyObject){

        AntBus.log.handler?(.kvo, "AntBus.plus.kvo.remove: keyPath:\(keyPath) \t object:\(object)")
        
        let container = objc_getAssociatedObject(object, &AntBusKVO_container_key) as? AntBusKVOContainer
        container?.removeKVO(keyPath: keyPath)
    }
}

private class AntBusKVOContainer: NSObject{
    weak var target: AnyObject?
    var container = SafeMutableDictionary()
    
    init(target: AnyObject){
        self.target = target
    }
    
    func removeKVO(){
        self.target?.removeObserver(self)
    }
    
    func addKVO(keyPath: String, handler: AntBusKVOHandler!){
        var handlerContainers = container.object(forKey: keyPath) as? SafeMutableArray
        if handlerContainers == nil {
            handlerContainers = SafeMutableArray()
            container.setObject(handlerContainers!, forKey: keyPath)
            self.target?.addObserver(self, forKeyPath: keyPath, options: [.new, .old], context: nil)
        }
        handlerContainers?.add(handler as AnyObject)
    }
    
    func removeKVO(keyPath: String){
        if let handlerContainers = container.object(forKey: keyPath) as? SafeMutableArray {
            if handlerContainers.count > 0 {
                self.target?.removeObserver(self, forKeyPath: keyPath, context: nil)
            }
        }
        container.removeObject(forKey: keyPath)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?){
        if let _ = keyPath {
            let oldVal: Any? = change?[NSKeyValueChangeKey.oldKey]
            let newVal: Any? = change?[NSKeyValueChangeKey.newKey]
            
            if let handlerContainers = container.object(forKey: keyPath!) as? SafeMutableArray {
                for handler in handlerContainers.elements {
                    (handler as? AntBusKVOHandler)?(oldVal, newVal)
                }
            }
        }
    }
}
