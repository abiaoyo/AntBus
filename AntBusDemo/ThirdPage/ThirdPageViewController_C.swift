//
//  ThirdPageViewController_C.swift
//  AntBusDemo
//
//  Created by 李叶彪 on 2021/6/14.
//

import UIKit
import AntBus

class ThirdPageViewController_C: UIViewController, ThirdPageProtocol {
    
    deinit {
        print("deinit  \(self.classForCoder)")
    }
    
    func third_page() -> String?{
        return "Third_Page_C"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ThirdPageC"
        AntBusContainer<ThirdPageProtocol>.multi.register(["ThirdPageC"], self)
    }

    @IBAction func removePageB(_ sender: Any) {
        AntBusContainer<ThirdPageProtocol>.multi.remove("ThirdPageB")
    }
    
    @IBAction func callResponsers(_ sender: Any) {
        let responserA = AntBusContainer<ThirdPageProtocol>.multi.responsers("ThirdPageA")
        print("ThirdPageProtocol.responserA:\(responserA)")
        
        let responserA2 = AntBusContainer<ThirdPageProtocol>.multi.responsers("PageA")
        print("ThirdPageProtocol.responserA2:\(responserA2)")
        
        let responserB = AntBusContainer<ThirdPageProtocol>.multi.responsers("ThirdPageB")
        print("ThirdPageProtocol.responserB:\(responserB)")
        
        let responserC = AntBusContainer<ThirdPageProtocol>.multi.responsers("ThirdPageC")
        print("ThirdPageProtocol.responserC:\(responserC)")
        
        let responsers = AntBusContainer<ThirdPageProtocol>.multi.responsers()
        print("ThirdPageProtocol:  .count:\(responsers?.count)   .responsers:\(responsers)")
        
        
        let PageA = AntBusContainer<ThirdPageProtocolA>.multi.responsers("PageA")
        print("ThirdPageProtocolA.PageA:\(PageA)")
    }
    

}
