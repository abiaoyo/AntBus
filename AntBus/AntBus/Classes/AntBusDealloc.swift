//
//  AntBusDealloc.swift
//  AntBus
//
//  Created by 李叶彪 on 2022/3/23.
//

import UIKit

typealias AntBusDeallocHandler = (Set<String>) -> Void

private final class _AntBusDeallocHook {
    private var hkeys = Set<String>.init()
    var deallocHandler:AntBusDeallocHandler?
    var objectType:String?
    
    func add(_ hkey:String) {
        self.hkeys.insert(hkey)
    }
    
    deinit {
        print("\n_AntBusDeallocHook: \n.objectType:\(objectType ?? "") \t \n.hkeys:\(hkeys) \n")
        self.deallocHandler?(self.hkeys)
    }
}


final class AntBusDealloc {
    
    private init() {}
    
    static var WKMapDeallocHookKey: Void?
    static var WKSetDeallocHookKey: Void?
    static var SginleChannelDeallocHookKey: Void?
    
    static func installDeallocHookForWKMap(to object: AnyObject, hkey:String, deallocHandler: AntBusDeallocHandler?) {
        var hook:_AntBusDeallocHook? = objc_getAssociatedObject(object, &WKMapDeallocHookKey) as? _AntBusDeallocHook
        if let _hook = hook {
            _hook.add(hkey)
            return
        }
        
        hook = _AntBusDeallocHook()
        hook?.add(hkey)
        hook?.deallocHandler = deallocHandler
        hook?.objectType = NSStringFromClass(object.classForCoder)
        objc_setAssociatedObject(object, &WKMapDeallocHookKey, hook, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    static func installDeallocHookForWKSet(to object: AnyObject, hkey:String, deallocHandler: AntBusDeallocHandler?) {
        var hook:_AntBusDeallocHook? = objc_getAssociatedObject(object, &WKSetDeallocHookKey) as? _AntBusDeallocHook
        if let _hook = hook {
            _hook.add(hkey)
            return
        }
        
        hook = _AntBusDeallocHook()
        hook?.add(hkey)
        hook?.deallocHandler = deallocHandler
        hook?.objectType = NSStringFromClass(object.classForCoder)
        objc_setAssociatedObject(object, &WKSetDeallocHookKey, hook, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    static func installDeallocHookForSingleChannel(to object: AnyObject, hkey:String, deallocHandler: AntBusDeallocHandler?) {
        var hook:_AntBusDeallocHook? = objc_getAssociatedObject(object, &SginleChannelDeallocHookKey) as? _AntBusDeallocHook
        if let _hook = hook {
            _hook.add(hkey)
            return
        }
        
        hook = _AntBusDeallocHook()
        hook?.add(hkey)
        hook?.deallocHandler = deallocHandler
        hook?.objectType = NSStringFromClass(object.classForCoder)
        objc_setAssociatedObject(object, &SginleChannelDeallocHookKey, hook, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
}
