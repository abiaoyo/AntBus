//
//  SecondPageViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit
import AntBus
import CommonModule

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
    
    @IBAction func clickAntService(_ sender: Any) {
        let ptha = PTHA.init()
        AntService<DeviceModule>.multiple.register(ptha.keys, ptha)

        let pthb = PTHB.init()
        AntService<DeviceModule>.multiple.register(pthb.keys, pthb)

        let support_H6117s = AntService<DeviceModule>.multiple.responders("H6117")
        let H6117s = support_H6117s?.first(where: { module in
            let deviceInfo = DeviceInfo.init()
            deviceInfo.sku = "H6117"
            deviceInfo.pactCode = 4
            return module.isSupport(device: deviceInfo)
        })
        print("H6117s:\(H6117s)")
        
        
        
        let H6143 = AntService<DeviceModule>.multiple.responders("H6143")
        print("H6143:\(H6143)")
        
        let H6127 = AntService<DeviceModule>.multiple.responders("H6127")
        print("H6127:\(H6127)")
        
        let H6117 = AntService<DeviceModule>.multiple.responders("H6117")
        print("H6117:\(H6117)")
        
        let H6163 = AntService<DeviceModule>.multiple.responders("H6163")
        print("H6163:\(H6163)")
        
        let H611A = AntService<DeviceModule>.multiple.responders("H611A")
        print("H611A:\(H611A)")

        
        AntService<DeviceModule>.multiple.remove("H6127", responder: pthb)
        let H6127_2 = AntService<DeviceModule>.multiple.responders("H6127")
        print("H6127_2:\(H6127_2)")
        
        AntService<DeviceModule>.multiple.remove("H6117")
        let H6117_2 = AntService<DeviceModule>.multiple.responders("H6117")
        print("H6117_2:\(H6117_2)")
        
        
        let allresponders = AntService<DeviceModule>.multiple.responders()
        print("allresponders:\(allresponders)")
        
        AntService<DeviceModule>.multiple.remove(["H6163","H6117","H611A"])
        
        let allresponders2 = AntService<DeviceModule>.multiple.responders()
        print("allresponders2:\(allresponders2)")
        
        
        AntService<DeviceModule>.multiple.removeAll()
        let allresponders3 = AntService<DeviceModule>.multiple.responders()
        print("allresponders3:\(allresponders3)")
    }
}

class DeviceInfo{
    var sku:String = ""
    var bleVersion:String = ""
    var pactCode = 0
}

protocol DeviceModule{
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
