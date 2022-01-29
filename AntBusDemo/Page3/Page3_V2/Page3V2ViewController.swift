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
        print("deinit Page3V2Container")
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
        let container = Page3V2Container.init()
        container.title = "Page3V2Container"
        AntBusObject<Page3V2Container>.shared.register(container, owner: self)
    }

    @IBAction func clickTestObject(_ sender: Any) {
        let title = AntBusObject<Page3V2Container>.shared.object()?.title
        print("title:\(title)")
    }
    
    @IBAction func clickRemoveObject(_ sender: Any) {
        AntBusObject<Page3V2Container>.shared.remove()
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
