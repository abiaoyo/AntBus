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
        AntBus.service<SFViewPage>.single.register(self)
        AntBus.service<ViewController2>.single.register(self)
    }
    
    @IBAction func clickButton1(_ sender: Any) {
        let sfviewpages = AntBus.service<SFViewPage>.single.responder()
        print("sfviewpages: \(sfviewpages)")
    }

}
