import Foundation

final public class AntBus {
    public static let data = AntBusData()
    public static let notification = AntBusNotification()
    public static let deallocHook = AntBusDeallocHook.shared
    public static let listener = AntBusListener.shared
    public static var printDealloc = false
    public static var printChannel = false
    public static var printService = false
}
