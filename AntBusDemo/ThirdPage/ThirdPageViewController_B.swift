//
//  ThirdPageViewController_B.swift
//  AntBusDemo
//
//  Created by 李叶彪 on 2021/6/14.
//

import UIKit
import AntBus

class ThirdPageViewController_B: UIViewController , ThirdPageProtocol{

    deinit {
        print("deinit  \(self.classForCoder)")
    }
    
    func third_page() -> String?{
        return "Third_Page_B"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ThirdPageB"
        AntBusContainer<ThirdPageProtocol>.multi.register(["ThirdPageB"], self)
    }
    
    @IBAction func goThirdPageC(_ sender: Any) {
        let viewCtl = ThirdPageViewController_C.init()
        self.navigationController?.pushViewController(viewCtl, animated: true)
    }
}
