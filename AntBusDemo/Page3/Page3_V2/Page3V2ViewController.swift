//
//  Page3V2ViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/10/17.
//

import UIKit
import AntBus

class Page3V2Container{
    deinit {
        print("deinit Page3V2===========Container")
    }
    var title:String?
}

class Page3V2Container2{
    deinit {
        print("deinit Page3V2_2===========Container")
    }
    var title:String?
}

class Page3V2ViewController: UIViewController {
    
    deinit {
        print("deinit \(type(of: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "page3_v2"
//        AntBusObject<Page3V2Container>.shared.register(Page3V2Container.init(), self)
    }
    
    @IBAction func clickTestObject(_ sender: Any) {
//        let page3V2 = AntBusObject<Page3V2Container>.shared.object()
        let page3V2 = AntBus.sharedObject.object(Page3V2Container.self)
        print("page3V2:\(page3V2)")
        
//        let page3V2_2 = AntBusObject<Page3V2Container2>.shared.object()
        let page3V2_2 = AntBus.sharedObject.object(Page3V2Container2.self)
        print("page3V2_2:\(page3V2_2)")
    }
    
    @IBAction func clickRemoveObject(_ sender: Any) {
//        AntBusObject<Page3V2Container>.shared.remove()
        AntBus.sharedObject.remove(Page3V2Container.self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
