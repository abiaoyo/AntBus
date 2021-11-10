//
//  SecondPageViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit
import AntBus
import BaseModule

class SecondPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AntBusChannel.groupNotification.register("TestGroupKey", group: "TestGroup", owner: self) { group, groupIndex, data in
            print("SecondPage group:\(group)  groupIndex:\(groupIndex)  data:\(data ?? "nil")")
        }
    }
    
    @IBAction func clickPage3V1(_ sender: Any) {
        AntService<IPage3Module>.multiple.responders("page3")?.first(where: { page3Module in
            if(page3Module.version() == 1){
                return true
            }
            return false
        })?.pushPage(navCtl: self.navigationController!)
        
    }
    
    @IBAction func clickPage3V2(_ sender: Any) {
        AntService<IPage3Module>.multiple.responders("page3")?.first(where: { page3Module in
            if(page3Module.version() == 2){
                return true
            }
            return false
        })?.pushPage(navCtl: self.navigationController!)
    }
    
    @IBAction func clickPage4(_ sender: Any) {
        AntService<IPage4Module>.single.responder()?.pushPage(navCtl: self.navigationController!)
    }
    
}
