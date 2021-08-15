//
//  FourthPageViewController_A.swift
//  AntBusDemo
//
//  Created by 李叶彪 on 2021/6/14.
//

import UIKit
import AntBus
import LoginModule

class FourthPageViewController_A: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    deinit {
        print("deinit  \(self.classForCoder)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textLabel.text = AntBus<FourthPageProtocol>.single.responder()?.pageTitle()
        
    }

    @IBAction func clickButton(_ sender: Any) {
        let moduleA = AntBus<ModuleAProtocol>.single.responder()
        print("moduleA:\(moduleA)")
        let moduleB = AntBus<ModuleBProtocol>.single.responder()
        print("moduleB:\(moduleB)")
        let moduleLogin = AntBus<ModuleLoginProtocol>.single.responder()
        print("moduleLogin:\(moduleLogin)")
    }
    
}
