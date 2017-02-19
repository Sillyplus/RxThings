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
    
    var id: Int64?
    var title: String
    var remindDate: Date?
    var repeatTimes: Int64?
    var dueDate: Date?
    var note: String?
    
    init(title: String) {
        self.title = title
    }
    
    
    
    init(taskRow: Row) {
        self.id = taskRow[TasksManager.idEx]
        self.title = taskRow[TasksManager.titleEx]
        self.remindDate = taskRow[TasksManager.remindDateEx]
        self.repeatTimes = taskRow[TasksManager.repeatTimesEx]
        self.dueDate = taskRow[TasksManager.dueDateEx]
        self.note = taskRow[TasksManager.noteEx]
    }
    
}
