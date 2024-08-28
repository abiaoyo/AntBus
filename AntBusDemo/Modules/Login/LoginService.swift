//
//  LoginService.swift
//  AntBusDemo
//
//  Created by abiaoyo on 2024/8/22.
//

import Foundation
import UIKit

protocol LoginService {
    
    var loginInfo: LoginInfo { get }
    func login(account:String)
    func logout()
    func viewController() -> UIViewController
}
