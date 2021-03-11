//
//  Login.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2021/3/9.
//

import Foundation

@objc public protocol LoginService {
    func logout(account:String)
    func login()
    
}
