//
//  AntBusWeekContainer.swift
//  AntBus
//
//  Created by liyebiao on 2021/6/11.
//

import Foundation

//MARK:AntBusWeekContainer
public class AntBusWeekContainer<T:NSObjectProtocol>: NSObject{
    
    static func createContainer() -> AntBusWeekContainer<T>{
        return AntBusWeekContainer<T>.init()
    }
    
    private var container = NSHashTable<T>.weakObjects()
    
    public func allDelegates() -> [T] {
        return self.container.allObjects
    }
    
    public func addDelegate(_ delegate:T) -> Void {
        self.container.add(delegate)
    }
    
    public func removeDelegate(_ delegate:T) -> Void {
        self.container.remove(delegate)
    }
}
