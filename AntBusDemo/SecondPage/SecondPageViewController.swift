//
//  SecondPageViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit
import AntBus
import CommonModule

class SecondPageViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AntBus.groupNotification.register("TestGroupKey", group: "TestGroup", owner: self) { group, groupIndex, data in
            print("SecondPage group:\(group)  groupIndex:\(groupIndex)  data:\(data ?? "nil")")
        }
    }
    
    @IBAction func clickPage3V1(_ sender: Any) {
        AntServiceInterface<IPage3Module>.multiple.responders("page3")?.first(where: { page3Module in
            if(page3Module.version() == 1){
                return true
            }
            return false
        })?.pushPage(navCtl: self.navigationController!)
        
    }
    
    @IBAction func clickPage3V2(_ sender: Any) {
        AntServiceInterface<IPage3Module>.multiple.responders("page3")?.first(where: { page3Module in
            if(page3Module.version() == 2){
                return true
            }
            return false
        })?.pushPage(navCtl: self.navigationController!)
    }
    
    @IBAction func clickPage4(_ sender: Any) {
        AntServiceInterface<IPage4Module>.single.responder()?.pushPage(navCtl: self.navigationController!)
    }
    
    
    @IBAction func clickAntChannel(_ sender: Any) {
        
        AntChannelInterface<IFirstPageController>.single.responder()
        
        
        AntChannel.multipleInterface(Page3_V1_Controller.self).responders()
        
    }
    
    
    
    @IBAction func clickAntService(_ sender: Any) {
        let ptha = PTHA.init()
        AntServiceInterface<DeviceModule>.multiple.register(ptha.keys, ptha)
        
        let pthb = PTHB.init()
        AntServiceInterface<DeviceModule>.multiple.register(pthb.keys, pthb)
        
        let pthc = PTHC.init()
        AntServiceInterface<DeviceModule>.multiple.register(pthc.keys, pthc)

        AntServiceInterface<DeviceModule>.multiple.responders()
        
        let support_H6117s = AntServiceInterface<DeviceModule>.multiple.responders("H6117")
        let H6117s = support_H6117s?.first(where: { module in
            let deviceInfo = DeviceInfo.init()
            deviceInfo.sku = "H6117"
            deviceInfo.pactCode = 4
            return module.isSupport(device: deviceInfo)
        })
        print("H6117s:\(H6117s)")
        
        
        
        AntServiceInterface<DeviceModule>.multiple.responders("H6143")
        
        
        AntServiceInterface<DeviceModule>.multiple.responders("H6127")
        
        AntServiceInterface<DeviceModule>.multiple.responders("H6117")
        
        
        AntServiceInterface<DeviceModule>.multiple.responders("H6163")

        AntServiceInterface<DeviceModule>.multiple.responders("H611A")

/*
        // remove where
        AntServiceInterface<DeviceModule>.multiple.remove("H6127") { m in
            
        }
        AntServiceInterface<DeviceModule>.multiple.responders("H6127")
 */
        
        AntServiceInterface<DeviceModule>.multiple.remove("H6117")
        AntServiceInterface<DeviceModule>.multiple.responders("H6117")
        
        
        AntServiceInterface<DeviceModule>.multiple.responders()
        
        
        AntServiceInterface<DeviceModule>.multiple.remove(["H6163","H6117","H611A"])
        
        AntServiceInterface<DeviceModule>.multiple.responders()
        
        AntServiceInterface<DeviceModule>.multiple.removeAll()
        AntServiceInterface<DeviceModule>.multiple.responders()
    }
}

class DeviceInfo:NSObject{
    var sku:String = ""
    var bleVersion:String = ""
    var pactCode = 0
}

@objc protocol DeviceModule{
    var keys: [String] {get}
    func isSupport(device:DeviceInfo) -> Bool
}

class PTHA: DeviceModule{
    func isSupport(device: DeviceInfo) -> Bool {
        if keys.contains(where: {$0 == device.sku}) {
            if device.sku == "H6117" {
                return device.pactCode <= 3
            }
        }
        return false
    }
    
    var keys: [String] = ["H6143","H6127","H6117"]
    
    deinit {
        print("deinit PTHA")
    }
}

class PTHB: DeviceModule{
    var keys: [String] = ["H6163","H6117","H611A","H6127"]
    func isSupport(device: DeviceInfo) -> Bool {
        if keys.contains(where: {$0 == device.sku}) {
            if device.sku == "H6117" {
                return device.pactCode > 3
            }
        }
        return false
    }
    deinit {
        print("deinit PTHB")
    }
}


class PTHC: DeviceModule{
    var keys: [String] = ["H6117"]
    func isSupport(device: DeviceInfo) -> Bool {
        if keys.contains(where: {$0 == device.sku}) {
            if device.sku == "H6117" {
                return device.pactCode > 4
            }
        }
        return false
    }
    deinit {
        print("deinit PTHC")
    }
}
