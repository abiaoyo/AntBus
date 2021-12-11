//
//  IBaseModule.swift
//  LoginModule
//
//  Created by abiaoyo
//

import Foundation

public protocol IBaseModule{
    func moduleInit()
}

@objc public protocol IABC{
    
}

public class ABC:IABC{
    public init() {
        
    }
}
