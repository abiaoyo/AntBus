//
//  FourthPageViewController_A.swift
//  AntBusDemo
//
//  Created by 李叶彪 on 2021/6/14.
//

import UIKit
import AntBus

class FourthPageViewController_A: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textLabel.text = AntBusContainer<FourthPageProtocol>.single.responser()?.pageTitle()
    }



}
