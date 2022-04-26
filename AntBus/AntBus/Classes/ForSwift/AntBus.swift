import Foundation

final public class AntBus {
    public static let data = AntBusData()
    public static let notification = AntBusNotification()
    public static let deallocHook = AntBusDeallocHook.shared
    public static let listener = AntBusListener.shared
    public static var deallocLog:((_ log: String) -> Void)?
    public static var channelLog:((_ log: String) -> Void)?
    public static var serviceLog:((_ log: String) -> Void)?
}

extension AntBus {
    public static func printLog(_ str:String) {
        print("###🍄 \(str)")
    }
}
