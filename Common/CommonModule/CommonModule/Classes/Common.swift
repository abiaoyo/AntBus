//
//  Common.swift
//  CommonModule
//
//  Created by abiaoyo on 2021/11/11.
//

import Foundation

public protocol ILoginModule{
    func logout()
    func showLoginPage()
}

typealias ILogin = ILoginModule
