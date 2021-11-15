//
//  AntBus.swift
//  AntBus
//  Created by abiaoyo
//

import Foundation

public typealias AntBusResult = (success:Bool,data:Any?)
public typealias AntBusResultBlock = (_ data:Any?) -> Void
public typealias AntBusDataHandler = () -> Any?
public typealias AntBusNotificaitonFilterBlock = (_ owner:AnyObject,_ data:Any?) -> Bool
public typealias AntBusTaskBlock = (_ data:Any?) -> Void

//dataBlock是数据回调，taskBlock是任务回调 - 如：异步任务
public typealias AntBusMethodHandler = (_ data:Any?,_ resultBlock:AntBusResultBlock,_ taskBlock:AntBusTaskBlock?) -> Void

//MARK: AntBusMethod  - 用于远程方法的访问
public class AntBusMethod{
    private var keyMap = NSMapTable<NSString,NSMapTable<NSString,AnyObject>>.strongToStrongObjects()
    
    private func clearOldHandler(key:String, method:String){
        self.keyMap.object(forKey: key as NSString)?.removeObject(forKey: method as NSString)
    }
    
    private func getHandler(key:String, method:String) -> AntBusMethodHandler?{
        if let methodHandlerMap = self.keyMap.object(forKey: key as NSString) {
            return methodHandlerMap.object(forKey: method as NSString) as? AntBusMethodHandler
        }
        return nil
    }
    
    public func register(_ key:String, method:String, handler:AntBusMethodHandler!){
        self.clearOldHandler(key: key, method: key)
        var methodHandlerMap = self.keyMap.object(forKey: key as NSString)
        if(methodHandlerMap == nil){
            methodHandlerMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            self.keyMap.setObject(methodHandlerMap, forKey: key as NSString)
        }
        methodHandlerMap!.setObject(handler as AnyObject, forKey: method as NSString)
    }
    
    public func canCall(_ key:String, method:String) -> Bool {
        if let _:AntBusMethodHandler = self.getHandler(key: key, method: method) {
            return true
        }
        return false
    }
    
    public func call(_ key:String, method:String,data:Any?, taskBlock:AntBusTaskBlock?) -> AntBusResult{
        if let handler:AntBusMethodHandler = self.getHandler(key: key, method: method) {
            var data:Any? = nil
            handler(data,{ (respData) in
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
    
    public func remove(_ key:String, method:String){
        self.clearOldHandler(key: key, method: method)
    }
    
    public func remove(_ key:String){
        self.keyMap.removeObject(forKey: key as NSString)
    }
    
    public func removeAll(){
        self.keyMap.removeAllObjects()
    }
    
}

//MARK: - AntBusData 共享 - 用于数据共享 - 临时存储
public class AntBusData{
    
    private var keyOwnerMap = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
    private var ownerHandlerMap = NSMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.weakToStrongObjects()
    
    private func clearOldOwner(_ key:String){
        if let oldOwner = self.keyOwnerMap.object(forKey: key as NSString) {
            if let keyHandlerMap = self.ownerHandlerMap.object(forKey: oldOwner) {
                keyHandlerMap.removeObject(forKey: key as NSString?)
            }
        }
    }
    
    private func getHandler(_ key: String) -> AntBusDataHandler?{
        if let owner = self.keyOwnerMap.object(forKey: key as NSString) {
            if let keyHandlerMap = self.ownerHandlerMap.object(forKey: owner) {
                if let handler:AntBusDataHandler = keyHandlerMap.object(forKey: key as NSString?) as? AntBusDataHandler {
                    return handler
                }
            }
        }
        return nil
    }
    
    public func register(_ key:String,owner:AnyObject,handler:AntBusDataHandler!){
        self.clearOldOwner(key)
        self.keyOwnerMap.setObject(owner, forKey: key as NSString)
        var keyHandlerMap = self.ownerHandlerMap.object(forKey: owner)
        if keyHandlerMap == nil {
            keyHandlerMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            self.ownerHandlerMap.setObject(keyHandlerMap, forKey: owner)
        }
        keyHandlerMap?.setObject(handler as AnyObject, forKey: key as NSString?)
    }

    public func canCall(_ key:String) -> Bool {
        if let _:AntBusDataHandler = self.getHandler(key) {
            return true
        }
        return false
    }
    
    public func call(_ key:String) -> AntBusResult{
        if let handler:AntBusDataHandler = self.getHandler(key) {
            let data:Any? = handler()
            return (success:true, data:data)
        }
        return (success:false, data:nil)
    }
    
    public func remove(_ key:String){
        self.clearOldOwner(key)
    }
    
    public func removeAll(){
        self.keyOwnerMap.removeAllObjects()
        self.ownerHandlerMap.removeAllObjects()
    }
}

//MARK: - AntBusNotification 通知 - 自定义的一个通知功能
public class AntBusNotification{
    
    private var keyOwnersMap = Dictionary<String,NSHashTable<AnyObject>>.init()
    private var ownerKeyHandlerMap = NSMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.weakToStrongObjects()

    public func register(_ key:String,owner:AnyObject,handler:AntBusResultBlock!){
        var ownersTable = self.keyOwnersMap[key]
        if(ownersTable == nil){
            ownersTable = NSHashTable<AnyObject>.weakObjects();
            self.keyOwnersMap[key] = ownersTable
        }
        ownersTable!.add(owner)
        var keyHandlerMap = self.ownerKeyHandlerMap.object(forKey:owner)
        if(keyHandlerMap == nil){
            keyHandlerMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            self.ownerKeyHandlerMap.setObject(keyHandlerMap,forKey:owner)
        }
        keyHandlerMap!.setObject(handler as AnyObject,forKey:key as NSString)
    }

    public func post(_ key:String,data:Any?){
        if let ownersTable = self.keyOwnersMap[key] {
            for owner in ownersTable.allObjects {
                if let keyHandlerMap:NSMapTable<NSString,AnyObject> = self.ownerKeyHandlerMap.object(forKey:owner) {
                    if let handler:AntBusResultBlock = keyHandlerMap.object(forKey:key as NSString) as? AntBusResultBlock {
                        handler(data)
                    }
                }
            }
        }
    }
    
    public func post(_ key:String){
        self.post(key, data: nil)
    }

    public func remove(_ key:String,owner:AnyObject){
        if let ownersTable = self.keyOwnersMap[key] {
            ownersTable.remove(owner)
        }
        if let keyHandlerMap = self.ownerKeyHandlerMap.object(forKey:owner) {
            keyHandlerMap.removeObject(forKey:key as NSString?)
        }
    }
    
    public func remove(_ key:String){
        if let ownersTable = self.keyOwnersMap[key] {
            for owner in ownersTable.allObjects {
                if let keyHandlerMap = self.ownerKeyHandlerMap.object(forKey:owner) {
                    keyHandlerMap.removeObject(forKey:key as NSString?)
                }
            }
            ownersTable.removeAllObjects()
        }
    }

    public func remove(owner:AnyObject){
        self.ownerKeyHandlerMap.removeObject(forKey: owner)
    }

    public func removeAll(){
        self.keyOwnersMap.removeAll()
        self.ownerKeyHandlerMap.removeAllObjects()
    }
}

public typealias AntBusGroupNotiResultBlock = (_ group:String, _ groupIndex:Int, _ data:Any?) -> Void

//MARK: - AntBusGroupNotification - 通知组
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

/// MARK: - AntBus - 基于数据共享的远程调用，回调绑定到owner的生命周期
/// data用于获取数据，跨界面/模块的数据调用
/// method用于方法调用，获取调用结果或异常任务结果
/// notification用于通知，带回调的自定义通知
/// groupNotification用于通知组，给通知注册者分组，发送的时候可发送一部分
public class AntBus {
    public static var data = AntBusData()
    public static var method = AntBusMethod()
    public static var notification = AntBusNotification()
    public static var groupNotification = AntBusGroupNotification()
}
