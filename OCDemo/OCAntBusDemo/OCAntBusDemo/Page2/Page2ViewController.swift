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
        
        let resps = AntBus.channel<UIViewController>.multi.responders()
        print("resps: \(resps)")
        
        let loginService = AntBus.service<ILogin>.single.responder()
//        print("loginService: \(loginService)")
        loginService?.login(withAccount: "lily")
    }

}
