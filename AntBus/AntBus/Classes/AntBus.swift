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

//MARK: - AntBusData 共享 - 用于数据共享 - 临时存储
public class AntBusData{
    
    private var keyOwnerMap = NSMapTable<NSString,AnyObject>.strongToWeakObjects()
//    private var ownerHandlerMap = NSMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.weakToStrongObjects()
    private var ownerHandlerMap = AntBus_WKMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.init()
    
    private func clearOldOwner(_ key:String){
        if let oldOwner = self.keyOwnerMap.object(forKey: key as NSString) {
            if let keyHandlerMap = self.ownerHandlerMap.value(forKey: oldOwner) {
                keyHandlerMap.removeObject(forKey: key as NSString?)
            }
        }
    }
    
    private func getHandler(_ key: String) -> AntBusDataHandler?{
        if let owner = self.keyOwnerMap.object(forKey: key as NSString) {
            if let keyHandlerMap = self.ownerHandlerMap.value(forKey: owner) {
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
        var keyHandlerMap = self.ownerHandlerMap.value(forKey: owner)
        if keyHandlerMap == nil {
            keyHandlerMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            self.ownerHandlerMap.setValue(keyHandlerMap, forKey: owner)
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
        self.ownerHandlerMap.removeAll()
    }
}

//MARK: - AntBusNotification 通知 - 自定义的一个通知功能
public class AntBusNotification{
    
    private var keyOwnersMap = Dictionary<String,NSHashTable<AnyObject>>.init()
//    private var ownerKeyHandlerMap = NSMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.weakToStrongObjects()
    private var ownerKeyHandlerMap = AntBus_WKMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.init()

    public func register(_ key:String,owner:AnyObject,handler:AntBusResultBlock!){
        var ownersTable = self.keyOwnersMap[key]
        if(ownersTable == nil){
            ownersTable = NSHashTable<AnyObject>.weakObjects();
            self.keyOwnersMap[key] = ownersTable
        }
        ownersTable!.add(owner)
        var keyHandlerMap = self.ownerKeyHandlerMap.value(forKey:owner)
        if(keyHandlerMap == nil){
            keyHandlerMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            self.ownerKeyHandlerMap.setValue(keyHandlerMap,forKey:owner)
        }
        keyHandlerMap!.setObject(handler as AnyObject,forKey:key as NSString)
    }

    public func post(_ key:String,data:Any?){
        if let ownersTable = self.keyOwnersMap[key] {
            for owner in ownersTable.allObjects {
                if let keyHandlerMap:NSMapTable<NSString,AnyObject> = self.ownerKeyHandlerMap.value(forKey:owner) {
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
        if let keyHandlerMap = self.ownerKeyHandlerMap.value(forKey:owner) {
            keyHandlerMap.removeObject(forKey:key as NSString?)
        }
    }
    
    public func remove(_ key:String){
        if let ownersTable = self.keyOwnersMap[key] {
            for owner in ownersTable.allObjects {
                if let keyHandlerMap = self.ownerKeyHandlerMap.value(forKey:owner) {
                    keyHandlerMap.removeObject(forKey:key as NSString?)
                }
            }
            ownersTable.removeAllObjects()
        }
    }

    public func remove(owner:AnyObject){
//        self.ownerKeyHandlerMap.removeObject(forKey: owner)
        self.ownerKeyHandlerMap.remove(forKey: owner)
    }

    public func removeAll(){
        self.keyOwnersMap.removeAll()
        self.ownerKeyHandlerMap.removeAll()
    }
}

public typealias AntBusGroupNotiResultBlock = (_ index:Int, _ count:Int, _ data:Any?) -> Void

//MARK: - AntBusGroupNotification - 通知组
public class AntBusGroupNotification{
    
    private var keyGroupOwnersMap = Dictionary<String,NSMapTable<NSString, NSHashTable<AnyObject>>>.init()
    private var ownerKeyHandlerMap = AntBus_WKMapTable<AnyObject,NSMapTable<NSString,AnyObject>>.init()
    
    private func getGroupOwnersMap(name:String) -> NSMapTable<NSString, NSHashTable<AnyObject>>{
        var groupOwnersMap = keyGroupOwnersMap[name]
        if groupOwnersMap == nil {
            groupOwnersMap = NSMapTable<NSString, NSHashTable<AnyObject>>.strongToStrongObjects()
            keyGroupOwnersMap[name] = groupOwnersMap
        }
        return groupOwnersMap!
    }
    
    private func getOwnersTable(name:String, group:String) -> NSHashTable<AnyObject>{
        let groupOwnersMap = self.getGroupOwnersMap(name: name)
        var ownersTable = groupOwnersMap.object(forKey: group as NSString?)
        if ownersTable == nil {
            ownersTable = NSHashTable<AnyObject>.weakObjects()
            groupOwnersMap.setObject(ownersTable, forKey: group as NSString?)
        }
        return ownersTable!
    }
    
    
    private func getKeyHandlerMap(owner:AnyObject) -> NSMapTable<NSString,AnyObject>{
        var keyHandlerMap = self.ownerKeyHandlerMap.value(forKey:owner)
        if(keyHandlerMap == nil){
            keyHandlerMap = NSMapTable<NSString,AnyObject>.strongToStrongObjects()
            self.ownerKeyHandlerMap.setValue(keyHandlerMap,forKey:owner)
        }
        return keyHandlerMap!
    }
    
    private func handlePost(name:String,group:NSString,groupOwnersMap:NSMapTable<NSString, NSHashTable<AnyObject>>, data:Any?) {
        if let ownersTable = groupOwnersMap.object(forKey: group) {
            var index = 0
            let count = ownersTable.count
            for owner:AnyObject in ownersTable.allObjects {
                if let keyHandlerMap:NSMapTable<NSString,AnyObject> = self.ownerKeyHandlerMap.value(forKey:owner) {
                    if let handler:AntBusGroupNotiResultBlock = keyHandlerMap.object(forKey:name as NSString) as? AntBusGroupNotiResultBlock {
                        handler(index,count,data)
                    }
                }
                index += 1
            }
        }
    }
    
    public func register(_  name:String, group:String, owner:AnyObject,handler:AntBusGroupNotiResultBlock!){
        let ownersTable = self.getOwnersTable(name: name, group: group)
        ownersTable.add(owner)
        
        let keyHandlerMap = self.getKeyHandlerMap(owner: owner)
        keyHandlerMap.setObject(handler as AnyObject,forKey:name as NSString)
    }
    
    public func post(_ name:String, group:String, data:Any?){
        if let groupOwnersMap = keyGroupOwnersMap[name] {
            self.handlePost(name: name, group: group as NSString, groupOwnersMap: groupOwnersMap, data: data)
        }
    }
    
    public func post(_ name:String, data:Any?){
        if let groupOwnersMap = keyGroupOwnersMap[name] {
            let allGroup = groupOwnersMap.keyEnumerator().allObjects
            for group in allGroup {
                self.handlePost(name: name, group: group as! NSString, groupOwnersMap: groupOwnersMap, data: data)
            }
        }
    }
    public func remove(_ name:String, key:String, owner:AnyObject){
        if let groupOwnersMap = keyGroupOwnersMap[name] {
            if let ownersTable = groupOwnersMap.object(forKey: key as NSString?) {
                ownersTable.remove(owner)
            }
        }
    }
    public func remove(_ name:String, key:String){
        if let groupOwnersMap = keyGroupOwnersMap[name] {
            groupOwnersMap.removeObject(forKey: key as NSString)
        }
    }
    public func remove(_ name:String){
        keyGroupOwnersMap.removeValue(forKey: name)
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
    public static var notification = AntBusNotification()
    public static var groupNotification = AntBusGroupNotification()
}
