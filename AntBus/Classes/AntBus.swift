//
//  AntBus.swift
//  ABLibDemo
//
//  Created by liyebiao on 2021/2/14.
//

import UIKit

public typealias AntBusResult = (success:Bool,data:Any?)
public typealias AntBusResultBlock = (_ data:Any?) -> Void
public typealias AntBusTaskBlock = (_ data:Any?) -> Void
public typealias AntBusDataHandler = (_ params:Any?) -> Any?
public typealias AntBusRouterHandler = (_ params:Any?,_ resultBlock:AntBusResultBlock,_ taskBlock:AntBusTaskBlock?) -> Void
public typealias AntBusNotificaitonFilterBlock = (_ owner:AnyObject?) -> Bool

//MARK:AntBusUtil
class AntBusUtil{
    class func createKey(service:Protocol!,method:Selector!) -> String! {
        let serviceKey:String = NSStringFromProtocol(service)
        let methodKey:String = NSStringFromSelector(method)
        let key:String = serviceKey+"."+methodKey
        return key
    }
}

//MARK:AntBusNotiProtocol
public protocol AntBusNotificationProtocol {
    func register(_ key:String!,owner:AnyObject!,handler:AntBusResultBlock!)
    func post(_ key:String!,data:Any?,filter:AntBusNotificaitonFilterBlock?)
    func post(_ key:String!,data:Any?)
    func post(_ key:String!)
    func remove(_ key:String!,owner:AnyObject!)
    func remove(_ key:String!)
    func remove(owner:AnyObject!)
    func removeAll()
}

//MARK:AntBusDataProtocol
public protocol AntBusDataProtocol {
    func register(_ key:String!,owner:AnyObject!,handler:AntBusDataHandler!)
    func register(_ key:String!,handler:AntBusDataHandler!)
    @discardableResult
    func canCall(_ key:String!) -> Bool
    @discardableResult
    func call(_ key:String!,params:Any?) -> AntBusResult
    @discardableResult
    func call(_ key:String!) -> AntBusResult
    func remove(_ key:String!)
    func removeAll()
}

//MARK:AntBusRouterProtocol
public protocol AntBusRouterProtocol {
    func register(_ key:String!,owner:AnyObject!,handler:AntBusRouterHandler!)
    func register(_ key:String!,handler:AntBusRouterHandler!)
    @discardableResult
    func canCall(_ key:String!) -> Bool
    @discardableResult
    func call(_ key:String!,params:Any?,taskBlock:AntBusTaskBlock?) -> AntBusResult
    @discardableResult
    func call(_ key:String!,params:Any?) -> AntBusResult
    @discardableResult
    func call(_ key:String!) -> AntBusResult
    func remove(_ key:String!)
    func removeAll()
}

//MARK:AntBusServiceProtocol
public protocol AntBusServiceProtocol {
    func register(_ service:Protocol!,method:Selector!,owner:AnyObject!,handler:AntBusRouterHandler!)
    func register(_ service:Protocol!,method:Selector!,handler:AntBusRouterHandler!)
    @discardableResult
    func canCall(_ service:Protocol!,method:Selector!) -> Bool
    @discardableResult
    func call(_ service:Protocol!,method:Selector!,params:Any?,taskBlock:AntBusTaskBlock?) -> AntBusResult
    @discardableResult
    func call(_ service:Protocol!,method:Selector!,params:Any?) -> AntBusResult
    @discardableResult
    func call(_ service:Protocol!,method:Selector!) -> AntBusResult
    func remove(_ service:Protocol!,method:Selector!)
    func removeAll()
}




//MARK:AntBusNotiChannel
class AntBusNotificationChannel: AntBusNotificationProtocol {
    private var koMap = Dictionary<String,NSHashTable<AnyObject>>()
    private var ohMap = NSMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.weakToStrongObjects()

    func register(_ key:String!,owner:AnyObject!,handler:AntBusResultBlock!){
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

    func post(_ key:String!,data:Any?,filter:AntBusNotificaitonFilterBlock?){
        if let oTable:NSHashTable<AnyObject> = self.koMap[key] {
            for owner:AnyObject in oTable.allObjects {

                if(filter != nil){
                    let call:Bool = filter!(owner)
                    if(!call){
                        continue
                    }
                }
                if let hMap:NSMapTable<NSString,AnyObject> = self.ohMap.object(forKey:owner) {
                    if let handler:AntBusResultBlock = hMap.object(forKey:key as NSString?) as? AntBusResultBlock {
                        handler(data)
                    }
                }
            }
        }
    }
    func post(_ key:String!,data:Any?){
        self.post(key, data: data, filter: nil)
    }
    
    func post(_ key:String!){
        self.post(key, data: nil, filter: nil)
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
    
    private func getHandler(_ key: String!) -> AntBusDataHandler?{
        if let handler:AntBusDataHandler = self.khMap[key] as? AntBusDataHandler {
            return handler
        }
        if let owner = self.koMap.object(forKey: key as NSString) {
            if let omhMap:NSMapTable<NSString,AnyObject> = self.ohMap.object(forKey: owner) {
                if let handler:AntBusDataHandler = omhMap.object(forKey: key as NSString?) as? AntBusDataHandler {
                    return handler
                }
            }
        }
        return nil
    }
    
    func register(_ key:String!,owner:AnyObject!,handler:AntBusDataHandler!){
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
    func register(_ key:String!,handler:AntBusDataHandler!){
        self.clearOldOwner(key)
        self.khMap[key] = handler
    }
    
    @discardableResult
    func canCall(_ key:String!) -> Bool {
        if let _:AntBusDataHandler = self.getHandler(key) {
            return true
        }
        return false
    }
    
    @discardableResult
    func call(_ key:String!,params:Any?) -> AntBusResult{
        if let handler:AntBusDataHandler = self.getHandler(key) {
            let data:Any? = handler(params)
            return (success:true, data:data)
        }
        return (success:false, data:nil)
    }
    
    @discardableResult
    func call(_ key:String!) -> AntBusResult{
        return self.call(key, params: nil)
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
    private func getHandler(_ url: String!) -> AntBusRouterHandler?{
        if let handler:AntBusRouterHandler = self.khMap[url] as? AntBusRouterHandler {
            return handler
        }
        if let owner = self.koMap.object(forKey: url as NSString) {
            if let omhMap:NSMapTable<NSString,AnyObject> = self.ohMap.object(forKey: owner) {
                if let handler:AntBusRouterHandler = omhMap.object(forKey: url as NSString?) as? AntBusRouterHandler {
                    return handler
                }
            }
        }
        return nil
    }
    
    func register(_ key:String!,owner:AnyObject!,handler:AntBusRouterHandler!){
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
    
    func register(_ key:String!,handler:AntBusRouterHandler!){
        self.clearOldOwner(key)
        self.khMap[key] = handler
    }
    
    @discardableResult
    func canCall(_ key:String!) -> Bool{
        if let _:AntBusRouterHandler = self.getHandler(key) {
            return true
        }
        return false
    }
    
    @discardableResult
    func call(_ key:String!,params:Any?,taskBlock:AntBusTaskBlock?) -> AntBusResult{
        if let handler:AntBusRouterHandler = self.getHandler(key) {
            var data:Any? = nil
            handler(params,{ (resData) in
                data = resData
            },{ (resData) in
                if(taskBlock != nil){
                    taskBlock!(resData)
                }
            })
            return (success:true, data:data)
        }
        return (success:false, data:nil)
    }
    
    @discardableResult
    func call(_ key:String!,params:Any?) -> AntBusResult{
        self.call(key, params: params, taskBlock: nil)
    }
    
    @discardableResult
    func call(_ key:String!) -> AntBusResult{
        self.call(key, params: nil, taskBlock: nil)
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


//MARK:AntBusServiceChannel
class AntBusServiceChannel: AntBusServiceProtocol {
    
    func register(_ service:Protocol!,method:Selector!,owner:AnyObject!,handler:AntBusRouterHandler!){
        let key:String = AntBusUtil.createKey(service: service, method: method)
        AntBus.router.register(key, owner: owner, handler: handler)
    }
    func register(_ service:Protocol!,method:Selector!,handler:AntBusRouterHandler!){
        let key:String = AntBusUtil.createKey(service: service, method: method)
        AntBus.router.register(key, handler: handler)
    }
    @discardableResult
    func canCall(_ service:Protocol!,method:Selector!) -> Bool{
        let key:String = AntBusUtil.createKey(service: service, method: method)
        return AntBus.router.canCall(key)
    }
    @discardableResult
    func call(_ service:Protocol!,method:Selector!,params:Any?,taskBlock:AntBusTaskBlock?) -> AntBusResult{
        let key:String = AntBusUtil.createKey(service: service, method: method)
        return AntBus.router.call(key, params: params, taskBlock: taskBlock)
    }
    @discardableResult
    func call(_ service:Protocol!,method:Selector!,params:Any?) -> AntBusResult{
        let key:String = AntBusUtil.createKey(service: service, method: method)
        return AntBus.router.call(key, params: params)
    }
    @discardableResult
    func call(_ service:Protocol!,method:Selector!) -> AntBusResult{
        let key:String = AntBusUtil.createKey(service: service, method: method)
        return AntBus.router.call(key)
    }
    func remove(_ service:Protocol!,method:Selector!){
        let key:String = AntBusUtil.createKey(service: service, method: method)
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
    public static let service:AntBusServiceProtocol = AntBusServiceChannel()
    
}
