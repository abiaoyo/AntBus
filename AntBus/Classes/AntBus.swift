//
//  AntBus.swift
//  ABLibDemo
//
//  Created by liyebiao on 2021/2/14.
//

import UIKit

public typealias AntBusNotiFilterBlock = (_ owner:AnyObject?) -> Bool
public typealias AntBusResponseBlock = (_ data:Any?) -> Void
public typealias AntBusDataHandlerBlock = (_ params:Any?) -> Any?
public typealias AntBusMethodHandlerBlock = (_ params:Array<Any?>?,_ responseBlock:AntBusResponseBlock?) -> Void
public typealias AntBusRouterHandlerBlock = (_ params:Any?,_ responseBlock:AntBusResponseBlock?) -> Void


//MARK:AntBusUtil
class AntBusUtil{
    class func createKey(proto:Protocol!,selector:Selector!) -> String! {
        let protoKey:String = NSStringFromProtocol(proto)
        let selKey:String = NSStringFromSelector(selector)
        let key:String = protoKey+"_"+selKey
        return key
    }
}

//MARK:AntBusNotiProtocol
public protocol AntBusNotiProtocol {
    func register(_ key:String!,owner:AnyObject!,handler:AntBusResponseBlock!)
    func post(_ key:String!,data:Any?)
    func post(_ key:String!,data:Any?,filter:AntBusNotiFilterBlock?)
    func remove(_ key:String!,owner:AnyObject!)
    func remove(_ key:String!)
    func remove(owner:AnyObject!)
    func removeAll()
}
//MARK:AntBusDataProtocol
public protocol AntBusDataProtocol {
    func register(_ key:String!,owner:AnyObject!,handler:AntBusDataHandlerBlock!)
    func register(_ key:String!,handler:AntBusDataHandlerBlock!)
    @discardableResult
    func call(_ key:String!,params:Any?) -> Any?
    func remove(_ key:String!)
    func removeAll()
}
//MARK:AntBusRouterProtocol
public protocol AntBusRouterProtocol {
    func register(_ url:String!,owner:AnyObject!,handler:AntBusRouterHandlerBlock!)
    func register(_ url:String!,handler:AntBusRouterHandlerBlock!)
    @discardableResult
    func open(_ url:String!,params:Any?,response:AntBusResponseBlock?) -> Bool
    func remove(_ url:String!)
    func removeAll()
}
//MARK:AntBusMethodProtocol
public protocol AntBusMethodProtocol {
    func register(_ proto:Protocol!,selector:Selector!,owner:AnyObject!,handler:AntBusMethodHandlerBlock!)
    func register(_ proto:Protocol!,selector:Selector!,handler:AntBusMethodHandlerBlock!)
    @discardableResult
    func call(_ proto:Protocol!,selector:Selector!,params:Array<Any?>?,response:AntBusResponseBlock?) -> Bool
    func remove(_ proto:Protocol!,selector:Selector!)
    func removeAll()
}




//MARK:AntBusNotiChannel
class AntBusNotiChannel: AntBusNotiProtocol {
    private var koMap = Dictionary<String,NSHashTable<AnyObject>>()
    private var ohMap = NSMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.weakToStrongObjects()
    private let _map_lock = DispatchSemaphore(value: 1)

    func register(_ key:String!,owner:AnyObject!,handler:AntBusResponseBlock!){
        _map_lock.wait()
        var oTable:NSHashTable<AnyObject>? = self.koMap[key]
        if(oTable == nil){
            oTable = NSHashTable<AnyObject>.weakObjects();
            self.koMap[key] = oTable
        }
        if(oTable!.contains(owner) == false){
            oTable!.add(owner)
        }
        var hMap:NSMapTable<NSString,AnyObject>? = self.ohMap.object(forKey:owner)
        if(hMap == nil){
            hMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            self.ohMap.setObject(hMap,forKey:owner)
        }
        hMap!.setObject(handler as AnyObject,forKey:key as NSString?)
        _map_lock.signal()
    }

    func post(_ key:String!,data:Any?){
        self.post(key, data: data, filter: nil)
    }
    func post(_ key:String!,data:Any?,filter:AntBusNotiFilterBlock?){
        if let oTable:NSHashTable<AnyObject> = self.koMap[key] {
            for owner:AnyObject in oTable.allObjects {

                if(filter != nil){
                    let call:Bool = filter!(owner)
                    if(!call){
                        continue
                    }
                }
                if let hMap:NSMapTable<NSString,AnyObject> = self.ohMap.object(forKey:owner) {
                    if let handler:AntBusResponseBlock = hMap.object(forKey:key as NSString?) as? AntBusResponseBlock {
                        handler(data)
                    }
                }
            }
        }
    }

    func remove(_ key:String!,owner:AnyObject!){
        _map_lock.wait()
        if let oTable:NSHashTable<AnyObject> = self.koMap[key] {
            if(oTable.contains(owner)){
                oTable.remove(owner)
            }
        }
        if let hMap:NSMapTable<NSString,AnyObject> = self.ohMap.object(forKey:owner) {
            hMap.removeObject(forKey:key as NSString?)
        }
        _map_lock.signal()
    }

    func remove(_ key:String!){
        _map_lock.wait()
        if let oTable:NSHashTable<AnyObject> = self.koMap[key] {
            for owner in oTable.allObjects {
                if let hMap:NSMapTable<NSString,AnyObject> = self.ohMap.object(forKey:owner) {
                    hMap.removeObject(forKey:key as NSString?)
                }
            }
            oTable.removeAllObjects()
        }
        _map_lock.signal()
    }

    func remove(owner:AnyObject!){
        _map_lock.wait()
        self.ohMap.removeObject(forKey: owner)
        _map_lock.signal()
    }

    func removeAll(){
        _map_lock.wait()
        self.koMap.removeAll()
        self.ohMap.removeAllObjects()
        _map_lock.signal()
    }
}



//MARK:AntBusDataChannel
class AntBusDataChannel: AntBusDataProtocol{
    private var koMap = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    private var ohMap = NSMapTable<AnyObject,AnyObject>.weakToStrongObjects()
    private var khMap = Dictionary<String,Any?>()
    private let _map_lock = DispatchSemaphore(value: 1)
    
    func register(_ key:String!,owner:AnyObject!,handler:AntBusDataHandlerBlock!){
        _map_lock.wait()
        self.khMap[key] = nil
        if let oldOwner = self.koMap.object(forKey: key as NSString) {
            self.ohMap.removeObject(forKey: oldOwner)
        }
        self.koMap.setObject(owner, forKey: key as NSString)
        self.ohMap.setObject(handler as AnyObject, forKey: owner)
        _map_lock.signal()
    }
    func register(_ key:String!,handler:AntBusDataHandlerBlock!){
        _map_lock.wait()
        self.khMap[key] = handler
        if let oldOwner = self.koMap.object(forKey: key as NSString) {
            self.ohMap.removeObject(forKey: oldOwner)
        }
        self.koMap.removeObject(forKey: key as NSString)
        _map_lock.signal()
    }
    @discardableResult
    func call(_ key:String!,params:Any?) -> Any?{
        if let handler:AntBusDataHandlerBlock = self.khMap[key] as? AntBusDataHandlerBlock {
            return handler(params)
        }
        if let owner = self.koMap.object(forKey: key as NSString) {
            if let handler:AntBusDataHandlerBlock = self.ohMap.object(forKey:owner) as? AntBusDataHandlerBlock {
                return handler(params);
            }
        }
        return nil
    }
    func remove(_ key:String!){
        _map_lock.wait()
        self.khMap[key] = nil
        if let target = self.koMap.object(forKey: key as NSString) {
            self.ohMap.removeObject(forKey: target)
        }
        self.koMap.removeObject(forKey: key as NSString)
        _map_lock.signal()
    }
    
    func removeAll(){
        _map_lock.wait()
        self.khMap.removeAll()
        self.koMap.removeAllObjects()
        self.ohMap.removeAllObjects()
        _map_lock.signal()
    }
}




//MARK:AntBusRouterChannel
class AntBusRouterChannel: AntBusRouterProtocol {
    private var koMap = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    private var ohMap = NSMapTable<AnyObject,AnyObject>.weakToStrongObjects()
    private var khMap = Dictionary<String,Any?>()
    private let _map_lock = DispatchSemaphore(value: 1)
    
    func register(_ url:String!,owner:AnyObject!,handler:AntBusRouterHandlerBlock!){
        _map_lock.wait()
        self.khMap[url] = nil
        if let oldOwner = self.koMap.object(forKey: url as NSString) {
            self.ohMap.removeObject(forKey: oldOwner)
        }
        self.koMap.setObject(owner, forKey: url as NSString)
        self.ohMap.setObject(handler as AnyObject, forKey: owner)
        _map_lock.signal()
    }
    
    func register(_ url:String!,handler:AntBusRouterHandlerBlock!){
        _map_lock.wait()
        self.khMap[url] = handler
        if let oldOwner = self.koMap.object(forKey: url as NSString) {
            self.ohMap.removeObject(forKey: oldOwner)
        }
        self.koMap.removeObject(forKey: url as NSString)
        _map_lock.signal()
    }
    
    @discardableResult
    func open(_ url:String!,params:Any?,response:AntBusResponseBlock?) -> Bool{
        if let handler:AntBusRouterHandlerBlock = self.khMap[url] as? AntBusRouterHandlerBlock {
            handler(params,{ (data) in
                if(response != nil){
                    response!(data)
                }
            })
            return true
        }
        if let owner = self.koMap.object(forKey: url as NSString) {
            if let handler:AntBusRouterHandlerBlock = self.ohMap.object(forKey:owner) as? AntBusRouterHandlerBlock {
                handler(params,{ (data) in
                    if(response != nil){
                        response!(data)
                    }
                })
                return true
            }
        }
        return false
    }
    
    func remove(_ url:String!){
        _map_lock.wait()
        self.khMap[url] = nil
        if let target = self.koMap.object(forKey: url as NSString) {
            self.ohMap.removeObject(forKey: target)
        }
        self.koMap.removeObject(forKey: url as NSString)
        _map_lock.signal()
    }
    
    func removeAll(){
        _map_lock.wait()
        self.khMap.removeAll()
        self.koMap.removeAllObjects()
        self.ohMap.removeAllObjects()
        _map_lock.signal()
    }
}


//MARK:AntBusMethodChannel
class AntBusMethodChannel: AntBusMethodProtocol {
    private var koMap = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    private var ohMap = NSMapTable<AnyObject,AnyObject>.weakToStrongObjects()
    private var khMap = Dictionary<String,Any?>()
    private let _map_lock = DispatchSemaphore(value: 1)
    
    func register(_ proto:Protocol!,selector:Selector!,owner:AnyObject!,handler:AntBusMethodHandlerBlock!){
        let key:String = AntBusUtil.createKey(proto: proto, selector: selector)
        _map_lock.wait()
        self.khMap[key] = nil
        if let oldOwner = self.koMap.object(forKey: key as NSString) {
            self.ohMap.removeObject(forKey: oldOwner)
        }
        self.koMap.setObject(owner, forKey: key as NSString)
        self.ohMap.setObject(handler as AnyObject, forKey: owner)
        _map_lock.signal()
    }
    
    func register(_ proto:Protocol!,selector:Selector!,handler:AntBusMethodHandlerBlock!){
        let key:String = AntBusUtil.createKey(proto: proto, selector: selector)
        _map_lock.wait()
        self.khMap[key] = handler
        if let oldOwner = self.koMap.object(forKey: key as NSString) {
            self.ohMap.removeObject(forKey: oldOwner)
        }
        self.koMap.removeObject(forKey: key as NSString)
        _map_lock.signal()
    }
    
    @discardableResult
    func call(_ proto:Protocol!,selector:Selector!,params:Array<Any?>?,response:AntBusResponseBlock?) -> Bool{
        let key:String = AntBusUtil.createKey(proto: proto, selector: selector)
        if let handler:AntBusMethodHandlerBlock = self.khMap[key] as? AntBusMethodHandlerBlock {
            handler(params,{ (data) in
                if(response != nil){
                    response!(data)
                }
            })
            return true
        }
        if let owner = self.koMap.object(forKey: key as NSString) {
            if let handler:AntBusMethodHandlerBlock = self.ohMap.object(forKey:owner) as? AntBusMethodHandlerBlock {
                handler(params,{ (data) in
                    if(response != nil){
                        response!(data)
                    }
                })
                return true
            }
        }
        return false
    }
    
    func remove(_ proto:Protocol!,selector:Selector!){
        let key:String = AntBusUtil.createKey(proto: proto, selector: selector)
        _map_lock.wait()
        self.khMap[key] = nil
        if let target = self.koMap.object(forKey: key as NSString) {
            self.ohMap.removeObject(forKey: target)
        }
        self.koMap.removeObject(forKey: key as NSString)
        _map_lock.signal()
    }
    
    func removeAll(){
        _map_lock.wait()
        self.khMap.removeAll()
        self.koMap.removeAllObjects()
        self.ohMap.removeAllObjects()
        _map_lock.signal()
    }
}


public class AntBus{
    public static let notification:AntBusNotiProtocol = AntBusNotiChannel()
    public static let data:AntBusDataProtocol = AntBusDataChannel()
    public static let router:AntBusRouterProtocol = AntBusRouterChannel()
    public static let method:AntBusMethodProtocol = AntBusMethodChannel()
}
