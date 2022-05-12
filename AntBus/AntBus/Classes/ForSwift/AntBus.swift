import Foundation

public enum AntBus {
    public static let data = AntBusData.shared
    public static let notification = AntBusNotification.shared
    public static let callback = AntBusCallback.shared
    public static let deallocHook = AntBusDeallocHook.shared
    public static let listener = AntBusListener.shared

    public enum channel<T> {
        public static var single: ABC_Single<T> { ABC_Single<T>.init() }
        public static var multi: ABC_Multi<T> { ABC_Multi<T>.init() }
    }

    public enum service<T> {
        public static var single: ABS_Single<T> { ABS_Single<T>.init() }
        public static var multi: ABS_Multi<T> { ABS_Multi<T>.init() }
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
