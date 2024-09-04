//
//  Page2ViewController.swift
//  OCAntBusDemo
//
//  Created by abiaoyo on 2022/4/22.
//

import UIKit
import AntBus

public protocol UIViewPage: NSObject{
    
}

class Page2ViewController: UIViewController ,UIViewPage{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resps = AntBus.plus.container.multiple.objects(UIViewController.self)
        print("resps: \(resps)")
        
        let loginService = AntBus.service.single.responder(ILogin.self)
//        print("loginService: \(loginService)")
        loginService?.login(withAccount: "lily")
    }

}
