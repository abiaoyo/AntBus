//
//  Login.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import UIKit

@objc public protocol LoginModule: NSObjectProtocol{
    @objc optional func login(account:String,password:String) -> String
    func logout()
    func showLoginPage(viewController:UIViewController!)
}
