//
//  Login.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import Foundation

@objc public protocol LoginModule: NSObjectProtocol{
    func login(account:String,password:String) -> String
    func logout()
    
    func popLoginPage()
}
