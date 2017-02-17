//
//  AppearanceConstants.swift
//  RxThings
//
//  Created by silly on 14/02/2017.
//  Copyright © 2017 silly. All rights reserved.
//

import Foundation
import UIKit
import SQLite

struct ColorConstant {
    static let navigationBarTintColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let navigationBarBarTintColor: UIColor = UIColor(red:0.42, green:0.54, blue:0.80, alpha:1.00)
    static let backgroudColor: UIColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.00)
}

struct DBConstant {
    static let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    static let tasksTableName = "Tasks"
}
