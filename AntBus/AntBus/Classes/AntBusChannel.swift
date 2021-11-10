//
//  AntBus+Channel.swift
//  AntBus
//  Created by abiaoyo
//

import Foundation

public typealias AntBusResult = (success:Bool,data:Any?)
public typealias AntBusResultBlock = (_ data:Any?) -> Void
public typealias AntBusTaskBlock = (_ data:Any?) -> Void
public typealias AntBusRouterHandler = (_ params:Dictionary<String,Any?>?,_ resultBlock:AntBusResultBlock,_ taskBlock:AntBusTaskBlock?) -> Void
public typealias AntBusDataHandler = () -> Any?
public typealias AntBusNotificaitonFilterBlock = (_ owner:AnyObject,_ data:Any?) -> Bool


//MARK:IAntBusData
public protocol IAntBusData {
    func register(_ key:String!,owner:AnyObject!,handler:AntBusDataHandler!)
    @discardableResult
    func canCall(_ key:String!) -> Bool
    @discardableResult
    func call(_ key:String!) -> AntBusResult
    func remove(_ key:String!)
    func removeAll()
}


//MARK:AntBusData 共享 - 用于数据共享 - 临时存储
fileprivate class AntBusData : IAntBusData{
        
    private var keyOwnerMap = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    private var ownerHandlerMap = NSMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.weakToStrongObjects()
    
    private func clearOldOwner(_ key:String!){
        if let oldOwner = self.keyOwnerMap.object(forKey: key as NSString) {
            if let keyHandlerMap:NSMapTable<NSString,AnyObject> = self.ownerHandlerMap.object(forKey: oldOwner) {
                keyHandlerMap.removeObject(forKey: key as NSString?)
            }
        }
    }
    
    private func getHandler(_ key: String!) -> AntBusDataHandler?{
        if let owner = self.keyOwnerMap.object(forKey: key as NSString) {
            if let keyHandlerMap:NSMapTable<NSString,AnyObject> = self.ownerHandlerMap.object(forKey: owner) {
                if let handler:AntBusDataHandler = keyHandlerMap.object(forKey: key as NSString?) as? AntBusDataHandler {
                    return handler
                }
            }
        }
        return nil
    }
    
    func register(_ key:String!,owner:AnyObject!,handler:AntBusDataHandler!){
        self.clearOldOwner(key)
        self.keyOwnerMap.setObject(owner, forKey: key as NSString)
        var keyHandlerMap:NSMapTable<NSString,AnyObject>? = self.ownerHandlerMap.object(forKey: owner)
        if keyHandlerMap == nil {
            keyHandlerMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            self.ownerHandlerMap.setObject(keyHandlerMap, forKey: owner)
        }
        keyHandlerMap?.setObject(handler as AnyObject, forKey: key as NSString?)
    }

    @discardableResult
    func canCall(_ key:String!) -> Bool {
        if let _:AntBusDataHandler = self.getHandler(key) {
            return true
        }
        return false
    }
    
    @discardableResult
    func call(_ key:String!) -> AntBusResult{
        if let handler:AntBusDataHandler = self.getHandler(key) {
            let data:Any? = handler()
            return (success:true, data:data)
        }
        return (success:false, data:nil)
    }
    
    func remove(_ key:String!){
        self.clearOldOwner(key)
    }
    
    func removeAll(){
        self.keyOwnerMap.removeAllObjects()
        self.ownerHandlerMap.removeAllObjects()
    }
}




//MARK:AntBusRouter
public protocol IAntBusRouter {
    func register(_ module:String!,key:String!,handler:AntBusRouterHandler!)
    @discardableResult
    func canCall(_ module:String!,key:String!) -> Bool
    @discardableResult
    func call(_ module:String!,key:String!,params:Dictionary<String,Any?>?,taskBlock:AntBusTaskBlock?) -> AntBusResult
    func remove(_ module:String!,key:String!)
    func remove(_ module:String!)
    func removeAll()
}

//MARK: AntBusRouter 路由 - 用于模块对外方法
fileprivate class AntBusRouter:IAntBusRouter{
    private var moduleMap = NSMapTable<NSString,NSMapTable<NSString,AnyObject>>.strongToStrongObjects()
    
    func clearOldHandler(module:String!,key:String!){
        self.moduleMap.object(forKey: module as NSString)?.removeObject(forKey: key as NSString)
    }
    
    private func getHandler(module:String!,key:String!) -> AntBusRouterHandler?{
        if let keyHandlerMap = self.moduleMap.object(forKey: module as NSString) {
            return keyHandlerMap.object(forKey: key as NSString) as? AntBusRouterHandler
        }
        return nil
    }
    
    func register(_ module:String!,key:String!,handler:AntBusRouterHandler!){
        self.clearOldHandler(module: module, key: key)
        var keyHandlerMap:NSMapTable<NSString,AnyObject>? = self.moduleMap.object(forKey: module as NSString)
        if(keyHandlerMap == nil){
            keyHandlerMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            self.moduleMap.setObject(keyHandlerMap, forKey: module as NSString)
        }
        keyHandlerMap?.setObject(handler as AnyObject, forKey: key as NSString)
    }
    
    @discardableResult
    func canCall(_ module:String!,key:String!) -> Bool {
        if let _:AntBusRouterHandler = self.getHandler(module: module, key: key) {
            return true
        }
        return false
    }
    @discardableResult
    func call(_ module:String!,key:String!,params:Dictionary<String,Any?>?,taskBlock:AntBusTaskBlock?) -> AntBusResult{
        if let handler:AntBusRouterHandler = self.getHandler(module: module, key: key) {
            var data:Any? = nil
            handler(params,{ (respData) in
                data = respData
            },{ (respData) in
                if(taskBlock != nil){
                    taskBlock!(respData)
                }
            })
            return (success:true, data:data)
        }
        return (success:false, data:nil)
    }
    
    func remove(_ module:String!,key:String!){
        self.clearOldHandler(module: module, key: key)
    }
    func remove(_ module:String!){
        self.moduleMap.removeObject(forKey: module as NSString)
    }
    func removeAll(){
        self.moduleMap.removeAllObjects()
    }
}

//MARK:IAntBusService
public protocol IAntBusService {
    func register(_ module:Protocol,method:Selector,handler:AntBusRouterHandler!)
    @discardableResult
    func canCall(_ module:Protocol,method:Selector) -> Bool
    @discardableResult
    func call(_ module:Protocol,method:Selector,params:Dictionary<String,Any?>?,taskBlock:AntBusTaskBlock?) -> AntBusResult
    func remove(_ module:Protocol,method:Selector)
    func remove(_ module:Protocol)
    func removeAll()
}

//MARK:AntBusService 服务 - 功能和路由一样，用协议名调用，方便查看参数
fileprivate class AntBusService: IAntBusService{
    lazy var router = {
        return AntBusRouter()
    }()
    
    func register(_ module:Protocol,method:Selector,handler:AntBusRouterHandler!){
        let module:String = NSStringFromProtocol(module)
        let key:String = NSStringFromSelector(method)
        self.router.register(module, key: key, handler: handler)
    }
    @discardableResult
    func canCall(_ module:Protocol,method:Selector) -> Bool{
        let module:String = NSStringFromProtocol(module)
        let key:String = NSStringFromSelector(method)
        return self.router.canCall(module, key: key)
    }
    @discardableResult
    func call(_ module:Protocol,method:Selector,params:Dictionary<String,Any?>?,taskBlock:AntBusTaskBlock?) -> AntBusResult{
        let module:String = NSStringFromProtocol(module)
        let key:String = NSStringFromSelector(method)
        return self.router.call(module, key: key, params: params, taskBlock: taskBlock)
    }
    func remove(_ module:Protocol,method:Selector){
        let module:String = NSStringFromProtocol(module)
        let key:String = NSStringFromSelector(method)
        self.router.remove(module, key: key)
    }
    func remove(_ module:Protocol){
        let module:String = NSStringFromProtocol(module)
        self.router.remove(module)
    }
    func removeAll(){
        self.router.removeAll()
    }
}


//MARK:IAntBusNotification
public protocol IAntBusNotification {
    func register(_ key:String!,owner:AnyObject!,handler:AntBusResultBlock!)
    func post(_ key:String!,data:Any?,filter:AntBusNotificaitonFilterBlock?) //filter 返回 false 将会被跳过
    func post(_ key:String!,data:Any?)
    func post(_ key:String!)
    func remove(_ key:String!,owner:AnyObject!)
    func remove(_ key:String!)
    func remove(owner:AnyObject!)
    func removeAll()
}

//MARK:AntBusNotification 通知 - 自定义的一个通知功能
fileprivate class AntBusNotification:IAntBusNotification{
    
    private var keyOwnersMap = Dictionary<String,NSHashTable<AnyObject>>.init()
    private var ownerKeyHandlerMap = NSMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.weakToStrongObjects()

    func register(_ key:String!,owner:AnyObject!,handler:AntBusResultBlock!){
        var ownersTable:NSHashTable<AnyObject>? = self.keyOwnersMap[key]
        if(ownersTable == nil){
            ownersTable = NSHashTable<AnyObject>.weakObjects();
            self.keyOwnersMap[key] = ownersTable
        }
        ownersTable!.add(owner)
        var keyHandlerMap:NSMapTable<NSString,AnyObject>? = self.ownerKeyHandlerMap.object(forKey:owner)
        if(keyHandlerMap == nil){
            keyHandlerMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            self.ownerKeyHandlerMap.setObject(keyHandlerMap,forKey:owner)
        }
        keyHandlerMap!.setObject(handler as AnyObject,forKey:key as NSString)
    }

    func post(_ key:String!,data:Any?,filter:AntBusNotificaitonFilterBlock?){
        if let ownersTable:NSHashTable<AnyObject> = self.keyOwnersMap[key] {
            for owner:AnyObject in ownersTable.allObjects {

                if(filter != nil){
                    let call:Bool = filter!(owner,data)
                    if(!call){
                        continue
                    }
                }
                if let keyHandlerMap:NSMapTable<NSString,AnyObject> = self.ownerKeyHandlerMap.object(forKey:owner) {
                    if let handler:AntBusResultBlock = keyHandlerMap.object(forKey:key as NSString) as? AntBusResultBlock {
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
        if let ownersTable:NSHashTable<AnyObject> = self.keyOwnersMap[key] {
            ownersTable.remove(owner)
        }
        if let keyHandlerMap:NSMapTable<NSString,AnyObject> = self.ownerKeyHandlerMap.object(forKey:owner) {
            keyHandlerMap.removeObject(forKey:key as NSString?)
        }
    }

    func remove(_ key:String!){
        if let ownersTable:NSHashTable<AnyObject> = self.keyOwnersMap[key] {
            for owner in ownersTable.allObjects {
                if let keyHandlerMap:NSMapTable<NSString,AnyObject> = self.ownerKeyHandlerMap.object(forKey:owner) {
                    keyHandlerMap.removeObject(forKey:key as NSString?)
                }
            }
            ownersTable.removeAllObjects()
        }
    }

    func remove(owner:AnyObject!){
        self.ownerKeyHandlerMap.removeObject(forKey: owner)
    }

    func removeAll(){
        self.keyOwnersMap.removeAll()
        self.ownerKeyHandlerMap.removeAllObjects()
    }
}

public typealias AntBusGroupNotiResultBlock = (_ group:String, _ groupIndex:Int, _ data:Any?) -> Void

public class AntBusGroupNotification{
    
    private var keyGroupOwnersMap = Dictionary<String,NSMapTable<NSString, NSHashTable<AnyObject>>>.init()
    private var ownerKeyHandlerMap = NSMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.weakToStrongObjects()
    
    private func getGroupOwnersMap(key:String) -> NSMapTable<NSString, NSHashTable<AnyObject>>{
        var groupOwnersMap = keyGroupOwnersMap[key]
        if groupOwnersMap == nil {
            groupOwnersMap = NSMapTable<NSString, NSHashTable<AnyObject>>.strongToStrongObjects()
            keyGroupOwnersMap[key] = groupOwnersMap
        }
        return groupOwnersMap!
    }
    
    private func getOwnersTable(key:String, group:String) -> NSHashTable<AnyObject>{
        let groupOwnersMap = self.getGroupOwnersMap(key: key)
        var ownersTable = groupOwnersMap.object(forKey: group as NSString?)
        if ownersTable == nil {
            ownersTable = NSHashTable<AnyObject>.weakObjects()
            groupOwnersMap.setObject(ownersTable, forKey: group as NSString?)
        }
        return ownersTable!
    }
    
    
    private func getKeyHandlerMap(owner:AnyObject) -> NSMapTable<NSString,AnyObject>{
        var keyHandlerMap = self.ownerKeyHandlerMap.object(forKey:owner)
        if(keyHandlerMap == nil){
            keyHandlerMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            self.ownerKeyHandlerMap.setObject(keyHandlerMap,forKey:owner)
        }
        return keyHandlerMap!
    }
    
    private func handlePost(key:String,group:NSString,groupOwnersMap:NSMapTable<NSString, NSHashTable<AnyObject>>, data:Any?) {
        if let ownersTable = groupOwnersMap.object(forKey: group) {
            var groupIndex = 0
            for owner:AnyObject in ownersTable.allObjects {
                if let keyHandlerMap:NSMapTable<NSString,AnyObject> = self.ownerKeyHandlerMap.object(forKey:owner) {
                    if let handler:AntBusGroupNotiResultBlock = keyHandlerMap.object(forKey:key as NSString) as? AntBusGroupNotiResultBlock {
                        handler(group as String,groupIndex,data)
                    }
                }
                groupIndex += 1
            }
        }
    }
    
    public func register(_  key:String, group:String, owner:AnyObject,handler:AntBusGroupNotiResultBlock!){
        let ownersTable = self.getOwnersTable(key: key, group: group)
        ownersTable.add(owner)
        
        let keyHandlerMap = self.getKeyHandlerMap(owner: owner)
        keyHandlerMap.setObject(handler as AnyObject,forKey:key as NSString)
    }
    
    public func post(_ key:String, group:String, data:Any?){
        if let groupOwnersMap = keyGroupOwnersMap[key] {
            self.handlePost(key: key, group: group as NSString, groupOwnersMap: groupOwnersMap, data: data)
        }
    }
    
    public func post(_ key:String, data:Any?){
        if let groupOwnersMap = keyGroupOwnersMap[key] {
            let allGroups = groupOwnersMap.keyEnumerator().allObjects
            for group in allGroups {
                self.handlePost(key: key, group: group as! NSString, groupOwnersMap: groupOwnersMap, data: data)
            }
        }
    }
    public func remove(_ key:String, group:String, owner:AnyObject){
        if let groupOwnersMap = keyGroupOwnersMap[key] {
            if let ownersTable = groupOwnersMap.object(forKey: group as NSString?) {
                ownersTable.remove(owner)
            }
        }
    }
    public func remove(_ key:String, group:String){
        if let groupOwnersMap = keyGroupOwnersMap[key] {
            groupOwnersMap.removeObject(forKey: group as NSString)
        }
    }
    public func remove(_ key:String){
        keyGroupOwnersMap.removeValue(forKey: key)
    }
    public func removeAll(){
        keyGroupOwnersMap.removeAll()
    }
}


//MARK:AntBusChannel
public class AntBusChannel {
    public static var data:IAntBusData = AntBusData()
    public static var router:IAntBusRouter = AntBusRouter()
    public static var service:IAntBusService = AntBusService()
    public static var notification:IAntBusNotification = AntBusNotification()
    public static var groupNotification:AntBusGroupNotification = AntBusGroupNotification()
}
