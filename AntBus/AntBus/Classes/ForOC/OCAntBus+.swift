import Foundation

@objcMembers
public class OCAntBusPlus: NSObject {
    public let data = OCAntBusData.shared
    public let notification = OCAntBusNotification.shared
    public let callback = OCAntBusCallback.shared
    public let deallocHook = OCAntBusDeallocHook.shared
    public let kvo = OCAntBusKVO.shared
    public let container = OCAntBusContainer.shared
}

@objcMembers
public class OCAntBusLog: NSObject {
    
    public func printLog(_ str: String) {
        AntBus.log.printLog(str)
    }
    
    public func setHandler(_ hdl:((_ type:AntBusLogType, _ log: String) -> Void)?) {
        AntBus.log.setHandler(hdl)
    }
}

public extension OCAntBus {
    static let plus = OCAntBusPlus()
    static let log = OCAntBusLog()
}
