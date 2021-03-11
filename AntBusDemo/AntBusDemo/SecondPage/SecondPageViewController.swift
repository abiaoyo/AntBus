//
//  SecondPageViewController.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit

class SecondPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        AntBus.notification.register("login.success", owner: self) { [weak self] (_) in
            self?.refreshView()
        }
        AntBus.notification.register("logout.success", owner: self) { [weak self] (_) in
            self?.refreshView()
        }
        self.refreshView()
    }
    func refreshView(){
        let result:AntBusResult = AntBus.data.call("login.user.account")
        self.label.text = result.data as? String
    }
    
    @IBOutlet weak var label: UILabel!
    @IBAction func clickButton(_ sender: Any) {
        AntBus.router.call("LoginService.login")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
