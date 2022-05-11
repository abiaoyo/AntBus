import Foundation

public enum AntBus {
    public static let data = AntBusData.shared
    public static let notification = AntBusNotification.shared
    public static let deallocHook = AntBusDeallocHook.shared
    public static let listener = AntBusListener.shared

    public struct service<T: Any> {
        public static var single: AntBusSS<T> { AntBusServiceI<T>.single }
        public static var multi: AntBusSM<T> { AntBusSM<T>.init() }
    }

    public struct channel<T: AnyObject> {
        public static var single: AntBusCS<T> { AntBusCS<T>.init() }
        public static var multi: AntBusCM<T> { AntBusCM<T>.init() }
    }
}

public extension AntBus {
    static var deallocLog: ((_ log: String) -> Void)?
    static var channelLog: ((_ log: String) -> Void)?
    static var serviceLog: ((_ log: String) -> Void)?

    static func printLog(_ str: String) {
        print("###🍄 \(str)")
    }
}
