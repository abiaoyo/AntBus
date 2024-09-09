//
//  LoginService.swift
//  AntBusDemo

import Foundation
import UIKit

protocol LoginService {
    
    var loginInfo: LoginInfo { get }
    func login(account:String)
    func logout()
    func viewController() -> UIViewController
}
