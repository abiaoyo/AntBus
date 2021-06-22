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

        self.textLabel.text = AntBusContainer<FourthPageProtocol>.single.responser()?.pageTitle()
    }

    @IBAction func clickButton(_ sender: Any) {
        let moduleA = AntBusContainer<ModuleAProtocol>.single.responser()
        print("moduleA:\(moduleA)")
        let moduleB = AntBusContainer<ModuleBProtocol>.single.responser()
        print("moduleB:\(moduleB)")
        let moduleLogin = AntBusContainer<ModuleLoginProtocol>.single.responser()
        print("moduleLogin:\(moduleLogin)")
    }
    
}
