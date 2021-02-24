//
//  AntBus.swift
//  ABLibDemo
//
//  Created by liyebiao on 2021/2/14.
//

import UIKit

public typealias AntBusResult = (success:Bool,object:Any?)
public typealias AntBusNotiFilterBlock = (_ owner:AnyObject?) -> Bool
public typealias AntBusResponseBlock = (_ data:Any?) -> Void
public typealias AntBusDataHandlerBlock = (_ params:Any?) -> Any?
public typealias AntBusRouterHandlerBlock = (_ params:Any?,_ responseBlock:AntBusResponseBlock?) -> Any?

//MARK:AntBusUtil
class AntBusUtil{
    class func createKey(proto:Protocol!,selector:Selector!) -> String! {
        let protoKey:String = NSStringFromProtocol(proto)
        let selKey:String = NSStringFromSelector(selector)
        let key:String = protoKey+"."+selKey
        return key
    }
}

//MARK:AntBusNotiProtocol
public protocol AntBusNotificationProtocol {
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
    func call(_ key:String!,params:Any?) -> AntBusResult
    func remove(_ key:String!)
    func removeAll()
}
//MARK:AntBusRouterProtocol
public protocol AntBusRouterProtocol {
    func register(_ url:String!,owner:AnyObject!,handler:AntBusRouterHandlerBlock!)
    func register(_ url:String!,handler:AntBusRouterHandlerBlock!)
    @discardableResult
    func canOpen(_ url:String!) -> Bool
    @discardableResult
    func open(_ url:String!,params:Any?,response:AntBusResponseBlock?) -> AntBusResult
    func remove(_ url:String!)
    func removeAll()
}
//MARK:AntBusRouterProtocolV2
public protocol AntBusRouterProtocolV2 {
    func register(_ proto:Protocol!,selector:Selector!,owner:AnyObject!,handler:AntBusRouterHandlerBlock!)
    func register(_ proto:Protocol!,selector:Selector!,handler:AntBusRouterHandlerBlock!)
    @discardableResult
    func canCall(_ proto:Protocol!,selector:Selector!) -> Bool
    @discardableResult
    func call(_ proto:Protocol!,selector:Selector!,params:Any?,response:AntBusResponseBlock?) -> AntBusResult
    func remove(_ proto:Protocol!,selector:Selector!)
    func removeAll()
}




//MARK:AntBusNotiChannel
class AntBusNotificationChannel: AntBusNotificationProtocol {
    private var koMap = Dictionary<String,NSHashTable<AnyObject>>()
    private var ohMap = NSMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.weakToStrongObjects()

    func register(_ key:String!,owner:AnyObject!,handler:AntBusResponseBlock!){
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
        if let oTable:NSHashTable<AnyObject> = self.koMap[key] {
            if(oTable.contains(owner)){
                oTable.remove(owner)
            }
        }
        if let hMap:NSMapTable<NSString,AnyObject> = self.ohMap.object(forKey:owner) {
            hMap.removeObject(forKey:key as NSString?)
        }
    }

    func remove(_ key:String!){
        if let oTable:NSHashTable<AnyObject> = self.koMap[key] {
            for owner in oTable.allObjects {
                if let hMap:NSMapTable<NSString,AnyObject> = self.ohMap.object(forKey:owner) {
                    hMap.removeObject(forKey:key as NSString?)
                }
            }
            oTable.removeAllObjects()
        }
    }

    func remove(owner:AnyObject!){
        self.ohMap.removeObject(forKey: owner)
    }

    func removeAll(){
        self.koMap.removeAll()
        self.ohMap.removeAllObjects()
    }
}



//MARK:AntBusDataChannel
class AntBusDataChannel: AntBusDataProtocol{
    private var koMap = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    private var ohMap = NSMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.weakToStrongObjects()
    private var khMap = Dictionary<String,Any?>()
    
    private func clearOldOwner(_ key:String!){
        if let oldOwner = self.koMap.object(forKey: key as NSString) {
            if let omhMap:NSMapTable<NSString,AnyObject> = self.ohMap.object(forKey: oldOwner) {
                omhMap.removeObject(forKey: key as NSString?)
            }
        }
    }
    
    func register(_ key:String!,owner:AnyObject!,handler:AntBusDataHandlerBlock!){
        self.clearOldOwner(key)
        self.khMap[key] = nil
        self.koMap.setObject(owner, forKey: key as NSString)
        var omhMap:NSMapTable<NSString,AnyObject>? = self.ohMap.object(forKey: owner)
        if omhMap == nil {
            omhMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            self.ohMap.setObject(omhMap, forKey: owner)
        }
        omhMap?.setObject(handler as AnyObject, forKey: key as NSString?)
    }
    func register(_ key:String!,handler:AntBusDataHandlerBlock!){
        self.clearOldOwner(key)
        self.khMap[key] = handler
    }
    
    private func getHandler(_ key: String!) -> AntBusDataHandlerBlock?{
        if let handler:AntBusDataHandlerBlock = self.khMap[key] as? AntBusDataHandlerBlock {
            return handler
        }
        if let owner = self.koMap.object(forKey: key as NSString) {
            if let omhMap:NSMapTable<NSString,AnyObject> = self.ohMap.object(forKey: owner) {
                if let handler:AntBusDataHandlerBlock = omhMap.object(forKey: key as NSString?) as? AntBusDataHandlerBlock {
                    return handler
                }
            }
        }
        return nil
    }
    
    @discardableResult
    func call(_ key:String!,params:Any?) -> AntBusResult{
        if let handler:AntBusDataHandlerBlock = self.getHandler(key) {
            return (success:true, object:handler(params))
        }
        return (success:false, object:nil)
    }
    func remove(_ key:String!){
        self.khMap[key] = nil
        self.clearOldOwner(key)
    }
    
    func removeAll(){
        self.khMap.removeAll()
        self.koMap.removeAllObjects()
        self.ohMap.removeAllObjects()
    }
}




//MARK:AntBusRouterChannel
class AntBusRouterChannel: AntBusRouterProtocol {
    private var koMap = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    private var ohMap = NSMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.weakToStrongObjects()
    private var khMap = Dictionary<String,Any?>()
    
    private func clearOldOwner(_ key:String!){
        if let oldOwner = self.koMap.object(forKey: key as NSString) {
            if let omhMap:NSMapTable<NSString,AnyObject> = self.ohMap.object(forKey: oldOwner) {
                omhMap.removeObject(forKey: key as NSString?)
            }
        }
    }
    
    func register(_ url:String!,owner:AnyObject!,handler:AntBusRouterHandlerBlock!){
        self.clearOldOwner(url)
        self.khMap[url] = nil
        self.koMap.setObject(owner, forKey: url as NSString)
        var omhMap:NSMapTable<NSString,AnyObject>? = self.ohMap.object(forKey: owner)
        if omhMap == nil {
            omhMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            self.ohMap.setObject(omhMap, forKey: owner)
        }
        omhMap?.setObject(handler as AnyObject, forKey: url as NSString?)
    }
    
    func register(_ url:String!,handler:AntBusRouterHandlerBlock!){
        self.clearOldOwner(url)
        self.khMap[url] = handler
    }
    
    private func getHandler(_ url: String!) -> AntBusRouterHandlerBlock?{
        if let handler:AntBusRouterHandlerBlock = self.khMap[url] as? AntBusRouterHandlerBlock {
            return handler
        }
        if let owner = self.koMap.object(forKey: url as NSString) {
            if let omhMap:NSMapTable<NSString,AnyObject> = self.ohMap.object(forKey: owner) {
                if let handler:AntBusRouterHandlerBlock = omhMap.object(forKey: url as NSString?) as? AntBusRouterHandlerBlock {
                    return handler
                }
            }
        }
        return nil
    }
    
    @discardableResult
    func canOpen(_ url: String!) -> Bool {
        if let _:AntBusRouterHandlerBlock = self.getHandler(url) {
            return true
        }
        return false
    }
    
    @discardableResult
    func open(_ url:String!,params:Any?,response:AntBusResponseBlock?) -> AntBusResult{
        if let handler:AntBusRouterHandlerBlock = self.getHandler(url) {
            return (success:true, object:handler(params,{ (data) in
                if(response != nil){
                    response!(data)
                }
            }))
        }
        return (success:false, object:nil)
    }
    
    func remove(_ url:String!){
        self.khMap[url] = nil
        self.clearOldOwner(url)
    }
    
    func removeAll(){
        self.khMap.removeAll()
        self.koMap.removeAllObjects()
        self.ohMap.removeAllObjects()
    }
}


//MARK:AntBusRouterChannelV2
class AntBusRouterChannelV2: AntBusRouterProtocolV2 {
    
    func register(_ proto:Protocol!,selector:Selector!,owner:AnyObject!,handler:AntBusRouterHandlerBlock!){
        let key:String = AntBusUtil.createKey(proto: proto, selector: selector)
        AntBus.router.register(key, owner: owner, handler: handler)
    }
    
    func register(_ proto:Protocol!,selector:Selector!,handler:AntBusRouterHandlerBlock!){
        let key:String = AntBusUtil.createKey(proto: proto, selector: selector)
        AntBus.router.register(key, handler: handler)
    }
    
    @discardableResult
    func canCall(_ proto: Protocol!, selector: Selector!) -> Bool {
        let key:String = AntBusUtil.createKey(proto: proto, selector: selector)
        return AntBus.router.canOpen(key)
    }
    
    @discardableResult
    func call(_ proto:Protocol!,selector:Selector!,params:Any?,response:AntBusResponseBlock?) -> AntBusResult{
        let key:String = AntBusUtil.createKey(proto: proto, selector: selector)
        return AntBus.router.open(key, params: params, response: response)
    }
    
    func remove(_ proto:Protocol!,selector:Selector!){
        let key:String = AntBusUtil.createKey(proto: proto, selector: selector)
        AntBus.router.remove(key)
    }
    
    func removeAll(){
        AntBus.router.removeAll()
    }
}

public class AntBus{
    public static let notification:AntBusNotificationProtocol = AntBusNotificationChannel()
    public static let data:AntBusDataProtocol = AntBusDataChannel()
    public static let router:AntBusRouterProtocol = AntBusRouterChannel()
    public static let routerV2:AntBusRouterProtocolV2 = AntBusRouterChannelV2()
}
