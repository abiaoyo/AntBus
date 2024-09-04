//
//  ViewController2.swift
//  OCAntBusDemo
//
//  Created by abiaoyo on 2022/4/22.
//

import UIKit
import AntBus

@objc public protocol SFViewPage: NSObjectProtocol{
    var title2:String? {get}
}



@objcMembers
public class ViewController2: UIViewController, SFViewPage{
    public var title2: String?
    

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title2 = "ViewController2"
        
        AntBus.plus.container.single.register(SFViewPage.self, object: self)
        AntBus.plus.container.single.register(ViewController2.self, object: self)
        
    }
    
    @IBAction func clickButton1(_ sender: Any) {
        let sfviewpages = AntBus.plus.container.single.object(SFViewPage.self)
        print("sfviewpages: \(sfviewpages)")
    }

}
