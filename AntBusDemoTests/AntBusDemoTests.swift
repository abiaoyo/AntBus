//
//  AntBusDemoTests.swift
//  AntBusDemoTests
//
//

import XCTest
import AntBus

@objc protocol TP {
    func name() -> String
}

class TestA: TP{
    func name() -> String {
        print("TestA")
        return "TestA"
    }
    deinit {
        print("deinit TestA")
    }
}

class TestB: TP{
    func name() -> String {
        print("TestB")
        return "TestB"
    }
    deinit {
        print("deinit TestB")
    }
}


@objc protocol TLogin {
    func login(account:String)
}

class TestLogin : TLogin{
    func login(account: String) {
        print("login: .account=\(account)")
    }
}

protocol TService {
    func sName() -> String
}

struct TestServiceA: TService, Equatable, Hashable{
    var id: Int = 0
    func sName() -> String {
        return "TestServiceA"
    }
}

class TestServiceB: TService {
    var id: Int = 0
    func sName() -> String {
        return "TestServiceB"
    }
}

protocol TSLogin {
    func login()
}

class TestServiceLogin: TSLogin{
    func login() {
        print("TestServiceLogin.login()")
    }
}

protocol SkuModule {
    var skus:[String] {get}
}

class PLC12Module: SkuModule {
    var skus:[String] = ["H6143","H6144"]
}

class H6143Module: SkuModule {
    var skus:[String] = ["H6143"]
}

struct AAAAA{
    
}

class AntBusDemoTests: XCTestCase {
    
    func testNew() {
        //AntBusService<SkuModule>.single
        //AntBus.service<SkuModule>.single
        
        /*
         
         */
        
        
        
        let type = AAAAA()
        
        AntBus.channel<AAAAA>.single.register(type)
        
//        let rs = Mirror(reflecting:type).displayStyle == .class
//        
//        print("rs:\(rs)")
//        
//        if let _t = type as AnyObject? {
//            print("_t:\(_t)")
//        }
        
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    
    
//    func testInt() {
//        AntBusServiceI<Int>.single.register(10)
//        let n = AntBusServiceI<Int>.single.responder()
//        print("n=\(n)")
//    }
//
//    func testModify() {
//        let plc12 = PLC12Module.init()
//        let h6143 = H6143Module.init()
//
//        AntBusServiceI<SkuModule>.multi.register(plc12.skus, plc12)
//        AntBusServiceI<SkuModule>.multi.register(h6143.skus, h6143)
//
//        let resp0 = AntBusServiceI<SkuModule>.multi.responders("H611A")
//        print("")
//        print("resp0: \(resp0)")
//        print("")
//
//        let resp1 = AntBusServiceI<SkuModule>.multi.responders()
//        print("")
//        print("resp1: \(resp1)")
//        print("")
//
//        let oldSkus = Set<String>.init(plc12.skus)
//        plc12.skus.append("H611A")
//        let newSkus = Set<String>.init(plc12.skus)
//
//        let pj:Set<String> = newSkus.subtracting(oldSkus)
//        let pSkus:[String] = pj.compactMap({ $0 })
//        AntBusServiceI<SkuModule>.multi.register(pSkus, plc12)
//
//        let resp2 = AntBusServiceI<SkuModule>.multi.responders("H6143")
//        print("")
//        print("resp2: \(resp2)")
//        print("")
//
//        let resp3 = AntBusServiceI<SkuModule>.multi.responders("H6144")
//        print("")
//        print("resp3: \(resp3)")
//        print("")
//
//        let resp4 = AntBusServiceI<SkuModule>.multi.responders("H611A")
//        print("")
//        print("resp4: \(resp4)")
//        print("")
//
//        let resp5 = AntBusServiceI<SkuModule>.multi.responders()
//        print("")
//        print("resp5: \(resp5)")
//        print("")
//    }
//
//    func registerA() {
//        autoreleasepool {
//            let ta = TestA.init()
//            AntBusChannelI<TP>.multi.register("A", ta)
//            let rsp = AntBusChannelI<TP>.multi.responders("A")
//            print("registerA() rsp.ta: \(rsp)")
//        }
//    }
//
//    func registerB() {
//        let tb = TestB.init()
//        AntBusChannelI<TP>.multi.register("B", tb)
//        let rsp = AntBusChannelI<TP>.multi.responders("B")
//        print("registerB() rsp.tb: \(rsp)")
//    }
//
//
//    func testMultiChannel() {
//        print("\n")
//
//        self.registerA()
//        self.registerB()
//
//        let rspA = AntBusChannelI<TP>.multi.responders("A")
//        print("rspA: \(rspA)")
//
//        let rspB = AntBusChannelI<TP>.multi.responders("B")
//        print("rspB: \(rspB)")
//    }
//
//    func registerLogin() {
//        let lg = TestLogin.init()
//        AntBusChannelI<TLogin>.single.register(lg)
//
//        let respLg = AntBusChannelI<TLogin>.single.responder()
//        print("respLg: \(respLg)")
//    }
//
//    func testSingleChannel() {
//        print("\n")
//        self.registerLogin()
//
//        let respLg = AntBusChannelI<TLogin>.single.responder()
//        print("test.respLg: \(respLg)")
//    }
//
//
//    func registerMultiService() {
//        autoreleasepool {
//            let tsA = TestServiceA(id: 100)
//            AntBusServiceI<TService>.multi.register("TSA", tsA)
//
//            let tsAA = TestServiceA(id: 200)
//            AntBusServiceI<TService>.multi.register("TSA", tsAA)
//
//            let tsB = TestServiceB()
//            tsB.id = 300
//            AntBusServiceI<TService>.multi.register("TSB", tsB)
//
//            let respA = AntBusServiceI<TService>.multi.responders("TSA")
//            let respB = AntBusServiceI<TService>.multi.responders("TSB")
//            print("r.respA: \(respA)")
//            print("r.respB: \(respB)")
//        }
//    }
//
//    func testMultiService() {
//        print("");
//        self.registerMultiService()
//        let respA = AntBusServiceI<TService>.multi.responders("TSA")
//        let respB = AntBusServiceI<TService>.multi.responders("TSB")
//        print("respA: \(respA)")
//        print("respB: \(respB)")
//        AntBusServiceI<TService>.multi.remove("TSA") { resp in
//            return (resp as? TestServiceA)?.id == 200
//        }
//        let respAA = AntBusServiceI<TService>.multi.responders("TSA")
//        let respBB = AntBusServiceI<TService>.multi.responders("TSB")
//        print("respAA: \(respAA)")
//        print("respBB: \(respBB)")
//        print("");
//    }
//
//    func registerSingleService(){
//        autoreleasepool {
//            let tsLogin = TestServiceLogin.init()
//            AntBusServiceI<TSLogin>.single.register(tsLogin)
//        }
//    }
//
//    func testSingleService() {
//        self.registerSingleService()
//        let respLogin = AntBusServiceI<TSLogin>.single.responder()
//        respLogin?.login()
//        print("respLogin: \(respLogin)")
//    }
    

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    

}
