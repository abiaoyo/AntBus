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
        AntBus<ThirdPageProtocol>.multi.register(["ThirdPageC"], self)
    }

    @IBAction func removePageB(_ sender: Any) {
        AntBus<ThirdPageProtocol>.multi.remove("ThirdPageB")
    }
    
    @IBAction func removeThirdPageProtocol(_ sender: Any) {
        AntBus<ThirdPageProtocol>.multi.removeAll()
    }
    
    @IBAction func callResponsers(_ sender: Any) {
        let responderA = AntBus<ThirdPageProtocol>.multi.responders("ThirdPageA")
        print("ThirdPageProtocol.responderA:\(responderA)")
        
        let responderA2 = AntBus<ThirdPageProtocol>.multi.responders("PageA")
        print("ThirdPageProtocol.responderA2:\(responderA2)")
        
        let responderB = AntBus<ThirdPageProtocol>.multi.responders("ThirdPageB")
        print("ThirdPageProtocol.responderB:\(responderB)")
        
        let responderC = AntBus<ThirdPageProtocol>.multi.responders("ThirdPageC")
        print("ThirdPageProtocol.responderC:\(responderC)")
        
        let responders = AntBus<ThirdPageProtocol>.multi.responders()
        print("ThirdPageProtocol:  .count:\(responders?.count)   .responders:\(responders)")
        
        let PageA = AntBus<ThirdPageProtocolA>.multi.responders("PageA")
        print("ThirdPageProtocolA.PageA:\(PageA)")
    }
    

}
