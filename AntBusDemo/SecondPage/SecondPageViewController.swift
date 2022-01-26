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
    
    @IBAction func clickChanngeTabBar(_ sender: Any) {
        let index = AntChannelInterface<TabBarProtocol>.single.responder()!.currentIndex()
        AntChannelInterface<TabBarProtocol>.single.responder()?.changeTabIndex(abs(1-index))
    }
    
    @IBAction func clickAntChannel(_ sender: Any) {
        
        AntChannelInterface<IFirstPageController>.single.responder()


        AntChannel.multipleInterface(Page3_V1_Controller.self).responders()
        
        let singleContainer = AntServiceInterface<Any>.singleContainer()
        let multiContainer = AntServiceInterface<Any>.multiContainer()
        
        print("singleContainer:\(singleContainer)")
        print("multiContainer:\(multiContainer)")
        
    }
    
    
    
    @IBAction func clickAntService(_ sender: Any) {
        let ptha = PTHA.init()
        AntServiceInterface<DeviceModule>.multiple.register(ptha.keys, ptha)
        
        let pthb = PTHB.init()
        let resp_b = AntServiceInterface<DeviceModule>.multiple.register(pthb.keys, pthb)
        
        let pthc = PTHC.init()
        AntServiceInterface<DeviceModule>.multiple.register(pthc.keys, pthc)

        // ************************************************
        let multiContainer = AntServiceInterface<Any>.multiContainer()
        print("\nmultiContainer:\(multiContainer) \n")
        // ************************************************
        
        
        let resp1 = AntServiceInterface<DeviceModule>.multiple.responders()
        print("resp1:\(resp1)")
        
        
        let support_H6117s = AntServiceInterface<DeviceModule>.multiple.responders("H6117")?.first(where: { module in
            let deviceInfo = DeviceInfo.init()
            deviceInfo.sku = "H6117"
            deviceInfo.pactCode = 4
            return module.isSupport(device: deviceInfo)
        })
        print("H6117s:\(support_H6117s)")
        
        
        
        let resp2 = AntServiceInterface<DeviceModule>.multiple.responders("H6143")
        print("resp2:\(resp2)")
        
        let resp3 =  AntServiceInterface<DeviceModule>.multiple.responders("H6127")
        print("resp3:\(resp3)")
        
        let resp4 = AntServiceInterface<DeviceModule>.multiple.responders("H6117")
        print("resp4:\(resp4)")
        
        AntServiceInterface<DeviceModule>.multiple.remove("H6117") { resp in
            print("remove where resp:\(resp.responder)")
            let b = resp_b === resp
            return b
        }
        let resp4_1 = AntServiceInterface<DeviceModule>.multiple.responders("H6117")
        print("resp4_1:\(resp4_1)")
        
        let resp5 = AntServiceInterface<DeviceModule>.multiple.responders("H6163")
        print("resp5:\(resp5)")
        
        let resp6 = AntServiceInterface<DeviceModule>.multiple.responders("H611A")
        print("resp6:\(resp6)")

/*
        // remove where
        AntServiceInterface<DeviceModule>.multiple.remove("H6127") { m in
            
        }
        AntServiceInterface<DeviceModule>.multiple.responders("H6127")
 */
        
        AntServiceInterface<DeviceModule>.multiple.remove("H6117")
        let resp7 = AntServiceInterface<DeviceModule>.multiple.responders("H6117")
        print("resp7:\(resp7)")
        
        
        let resp8 = AntServiceInterface<DeviceModule>.multiple.responders()
        print("resp8:\(resp8)")
        
        AntServiceInterface<DeviceModule>.multiple.remove(["H6163","H6117","H611A"])
        
        let resp9 = AntServiceInterface<DeviceModule>.multiple.responders()
        print("resp9:\(resp9)")
        
        AntServiceInterface<DeviceModule>.multiple.removeAll()
        
        let resp10 = AntServiceInterface<DeviceModule>.multiple.responders()
        print("resp10:\(resp10)")
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
