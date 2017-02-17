//
//  Task.swift
//  RxThings
//
//  Created by silly on 16/02/2017.
//  Copyright © 2017 silly. All rights reserved.
//

import Foundation
import SQLite

class Task {
    
    var title: String
    var hasRemindDate: Bool?
    var remindDate: Date?
    var repeatTimes: Int64?
    var isDue: Bool?
    var dueDate: Date?
    
    init(title: String) {
        self.title = title
    }
    
}
