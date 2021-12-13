//
//  AntBusDemoTests.swift
//  AntBusDemoTests
//
//  Created by 李叶彪 on 2021/12/12.
//

import XCTest
import AntBus

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
    
    func testMultiStruct() throws {
        let pageA = PageA.init()
        AntServiceInterface<IEFG>.multiple.register("page_a", pageA)
        
        let pageB = PageB.init()
        AntServiceInterface<IEFG>.multiple.register("page_b", pageB)
        
        print("\n")
        let allresponders0 = AntServiceInterface<IEFG>.multiple.responders()
        print("allresponders0:\(allresponders0)")
        
        //判断struct重复
        AntServiceInterface<IEFG>.multiple.register("page_b", pageB) { page in
            return page.name == pageB.name
        }
        
        let allresponders1 = AntServiceInterface<IEFG>.multiple.responders()
        print("allresponders1:\(allresponders1)")
        
        
        print("\n")
    }
    
    func testMultiClass() throws {
        let p1 = Person.init()
        AntServiceInterface<Animal>.multiple.register("p1", p1)
        
        let p2 = Person.init()
        AntServiceInterface<Animal>.multiple.register("p2", p2)
        
        print("\n")
        let allresponders0 = AntServiceInterface<Animal>.multiple.responders()
        print("allresponders0:\(allresponders0)")
        
        AntServiceInterface<Animal>.multiple.register("p2", p2)
        
        let allresponders1 = AntServiceInterface<Animal>.multiple.responders()
        print("allresponders1:\(allresponders1)")
        
        
        print("\n")
    }
    
    func testStruct() throws {
        let pageA = PageA.init()
        AntServiceInterface<IEFG>.multiple.register("page_a", pageA)

        let pageB = PageB.init()
        AntServiceInterface<IEFG>.multiple.register("page_b", pageB)
        AntServiceInterface<IEFG>.multiple.register("page_b", pageB) { page in
            return page.name == pageB.name
        }

        let pageC1 = PageC.init(name: "1")
        let pageC2 = PageC.init(name: "2")
        AntServiceInterface<IEFG>.multiple.register("page_c1", [pageC1,pageC2])
        
        let allresponders0 = AntServiceInterface<IEFG>.multiple.responders()
        print("allresponders0:\(allresponders0)")
        
        let allpage_c1 = AntServiceInterface<IEFG>.multiple.responders("page_c1")
        print("allpage_c1:\(allpage_c1)")

        AntServiceInterface<IEFG>.multiple.remove("page_c1") { page in
            return page.name == pageC1.name
        }
        
        let allpage_c1_2 = AntServiceInterface<IEFG>.multiple.responders("page_c1")
        print("allpage_c1_2:\(allpage_c1_2)")
        
        AntServiceInterface<IEFG>.multiple.remove("page_c1")
        
        let allpage_c1_3 = AntServiceInterface<IEFG>.multiple.responders("page_c1")
        print("allpage_c1_3:\(allpage_c1_3)")
        
        let allresponders1 = AntServiceInterface<IEFG>.multiple.responders()
        print("allresponders1:\(allresponders1)")
        
        AntServiceInterface<IEFG>.multiple.removeAll()
        
        let allresponders2 = AntServiceInterface<IEFG>.multiple.responders()
        print("allresponders2:\(allresponders2)")
    }
    
    func testClass() throws {

        let person = Person.init()
        AntServiceInterface<Animal>.multiple.register("P", person)
        let allresponders001 = AntServiceInterface<Animal>.multiple.responders()
        print("allresponders001:\(allresponders001)")

        let paName = AntServiceInterface<Animal>.multiple.responders()?.first?.name
        print("paName:\(paName)")

        person.name = "PA"
        let paName2 = AntServiceInterface<Animal>.multiple.responders()?.first?.name
        print("paName2:\(paName2)")

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
    }
    
    func testSingle() throws {
        let lm = LoginModule.init()
        
        AntServiceInterface<ILoginModule>.single.register(lm)
        var isLogin = AntServiceInterface<ILoginModule>.single.responder()?.isLogin
        
        print("isLogin:\(isLogin)")
        lm.isLogin = true
        
        isLogin = AntServiceInterface<ILoginModule>.single.responder()?.isLogin
        print("isLogin:\(isLogin)")
    }

}
