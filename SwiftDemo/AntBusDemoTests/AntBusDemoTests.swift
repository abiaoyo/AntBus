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

struct TestServiceA: TService{
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


class AntBusDemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func registerA() {
        autoreleasepool {
            let ta = TestA.init()
            AntBusChannelI<TP>.multi.register("A", ta)
            let rsp = AntBusChannelI<TP>.multi.responders("A")
            print("registerA() rsp.ta: \(rsp)")
        }
    }
    
    func registerB() {
        let tb = TestB.init()
        AntBusChannelI<TP>.multi.register("B", tb)
        let rsp = AntBusChannelI<TP>.multi.responders("B")
        print("registerB() rsp.tb: \(rsp)")
    }
    
    
    func testMultiChannel() {
        print("\n")
        
        self.registerA()
        self.registerB()
        
        let rspA = AntBusChannelI<TP>.multi.responders("A")
        print("rspA: \(rspA)")
        
        let rspB = AntBusChannelI<TP>.multi.responders("B")
        print("rspB: \(rspB)")
    }
    
    func registerLogin() {
        let lg = TestLogin.init()
        AntBusChannelI<TLogin>.single.register(lg)
        
        let respLg = AntBusChannelI<TLogin>.single.responder()
        print("respLg: \(respLg)")
    }
    
    func testSingleChannel() {
        print("\n")
        self.registerLogin()
        
        let respLg = AntBusChannelI<TLogin>.single.responder()
        print("test.respLg: \(respLg)")
    }
    
    
    func registerMultiService() {
        autoreleasepool {
            let tsA = TestServiceA(id: 100)
            AntBusServiceI<TService>.multi.register("TSA", tsA)
            
            let tsAA = TestServiceA(id: 200)
            AntBusServiceI<TService>.multi.register("TSA", tsAA)
            
            let tsB = TestServiceB()
            tsB.id = 300
            AntBusServiceI<TService>.multi.register("TSB", tsB)
            
            let respA = AntBusServiceI<TService>.multi.responders("TSA")
            let respB = AntBusServiceI<TService>.multi.responders("TSB")
            print("r.respA: \(respA)")
            print("r.respB: \(respB)")
        }
    }
    
    func testMultiService() {
        print("");
        self.registerMultiService()
        let respA = AntBusServiceI<TService>.multi.responders("TSA")
        let respB = AntBusServiceI<TService>.multi.responders("TSB")
        print("respA: \(respA)")
        print("respB: \(respB)")
        AntBusServiceI<TService>.multi.remove("TSA") { resp in
            return (resp.responder as? TestServiceA)?.id == 200
        }
        let respAA = AntBusServiceI<TService>.multi.responders("TSA")
        let respBB = AntBusServiceI<TService>.multi.responders("TSB")
        print("respAA: \(respAA)")
        print("respBB: \(respBB)")
        print("");
    }
    
    func registerSingleService(){
        autoreleasepool {
            let tsLogin = TestServiceLogin.init()
            AntBusServiceI<TSLogin>.single.register(tsLogin)
        }
    }
    
    func testSingleService() {
        self.registerSingleService()
        let respLogin = AntBusServiceI<TSLogin>.single.responder()
        respLogin?.login()
        print("respLogin: \(respLogin)")
    }
    

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
