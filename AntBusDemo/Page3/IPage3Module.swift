//
//  IPage3Module.swift
//  AntBusDemo
//
//  Created by 李叶彪 on 2021/10/17.
//

import UIKit

protocol IPage3Module {
    
    func version() -> Int
    
    func pushPage(navCtl:UINavigationController)
    
}
