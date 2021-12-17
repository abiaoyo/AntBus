//
//  AntBusDemoTests.swift
//  AntBusDemoTests
//
//  Created by abiaoyo on 2021/12/12.
//

import XCTest
import AntBus
import CommonModule

public protocol IEFG{
    var name:String {get}
    func efg()
}

struct PageA:IEFG{
    var name: String = "page_a"
    
    func efg() {
        
    }
}

struct PageB:IEFG{
    var name: String = "page_b"
    func efg() {
        
    }
}

struct PageC:IEFG{
    var name:String = "C"
    func efg() {
        
    }
}

protocol Animal {
    var name:String{get}
}

class Person: Animal {
    var name: String = "P"
}

protocol ILoginModule {
    var isLogin:Bool{get}
}
class LoginModule:ILoginModule{
    var isLogin: Bool = false
}

class LoginModuleB:CommonModule.ILoginModule{
    func logout() {
        
    }
    
    func showLoginPage() {
        
    }
    
    
}

class AntBusDemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    func testMulti_keys_responder_1() throws {
        print("\n")
        let pageA = PageA.init()
        AntServiceInterface<IEFG>.multiple.register(["page_a","page"], pageA)
        AntServiceInterface<IEFG>.multiple.responders("page_a")
        AntServiceInterface<IEFG>.multiple.responders("page")
        AntServiceInterface<IEFG>.multiple.responders()
        print("\n")
    }
    
    func testMulti_keys_responder_2() throws {
        print("\n")
        let pageA = PageA.init()
        let pageB = PageB.init()
        AntServiceInterface<IEFG>.multiple.register(["page_a","page"], pageA)
        AntServiceInterface<IEFG>.multiple.register(["page_b","page"], pageB)
        AntServiceInterface<IEFG>.multiple.responders("page_a")
        AntServiceInterface<IEFG>.multiple.responders("page_b")
        AntServiceInterface<IEFG>.multiple.responders("page")
        AntServiceInterface<IEFG>.multiple.responders()
        print("\n")
    }
    
    func testMulti_SameProtocolName(){
        print("\n")
        let loginA1 = LoginModule.init()
        let loginA2 = LoginModule.init()
        
        let loginB1 = LoginModuleB.init()
        let loginB2 = LoginModuleB.init()
        
        AntServiceInterface<ILoginModule>.multiple.register("loginA1", loginA1)
        AntServiceInterface<ILoginModule>.multiple.register("loginA2", loginA2)
        AntServiceInterface<ILoginModule>.multiple.responders()
        
        AntServiceInterface<CommonModule.ILoginModule>.multiple.register("loginB1", loginB1)
        AntServiceInterface<CommonModule.ILoginModule>.multiple.register("loginB2", loginB2)
        AntServiceInterface<CommonModule.ILoginModule>.multiple.responders()
        
        print("\n")
    }
    
    
    
    func testMulti_Delete() throws {
        print("\n")
        
        let pageA = PageA.init()
        let respA = AntServiceInterface<IEFG>.multiple.register("page_a", pageA)
        
        let pageB = PageB.init()
        AntServiceInterface<IEFG>.multiple.register("page_b", pageB)
        
        AntServiceInterface<IEFG>.multiple.responders()
        
        AntServiceInterface<IEFG>.multiple.remove("page_a") { resp in
            return respA === resp
        }
        
        AntServiceInterface<IEFG>.multiple.responders()
        
        print("\n")
    }
    
    func testMulti_Class() throws {
        print("\n")
        
        let p1 = Person.init()
        AntServiceInterface<Animal>.multiple.register("p1", p1)
        
        let p2 = Person.init()
        AntServiceInterface<Animal>.multiple.register("p2", p2)
        
        AntServiceInterface<Animal>.multiple.responders()
        
        //这里重复注册了一次p2，响应也会多一个
        AntServiceInterface<Animal>.multiple.register("p2", p2)
        
        AntServiceInterface<Animal>.multiple.responders()
        
        
        print("\n")
    }
    
    func testSysContainer() throws {
        let testArr = [1,2,3]
        AntServiceInterface<Array<Int>>.multiple.register("123", testArr)
        let testArr2 = [4,5,6]
        AntServiceInterface<Array<Int>>.multiple.register("456", testArr2)
        
        let allArrayRes = AntServiceInterface<Array<Int>>.multiple.responders()
        print("allArrayRes:\(allArrayRes)")
        
        let userDict = [["name":"lisa","age":"31"],["name":"hello","age":"23"]]
        AntServiceInterface<Dictionary<String,String>>.multiple.register("users", userDict)
        
        let allDict = AntServiceInterface<Dictionary<String,String>>.multiple.responders()
        print("allDict:\(allDict)")
        
        print("\n")
    }
    
    func testSingle() throws {
        //.. class
        let lm = LoginModule.init()
        
        AntServiceInterface<ILoginModule>.single.register(lm)
        var isLogin = AntServiceInterface<ILoginModule>.single.responder()?.isLogin
        
        print("isLogin:\(isLogin)")
        lm.isLogin = true
        
        isLogin = AntServiceInterface<ILoginModule>.single.responder()?.isLogin
        print("isLogin:\(isLogin)")
        
        print("\n")
    }

}
