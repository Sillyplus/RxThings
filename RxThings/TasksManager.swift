//
//  TasksManager.swift
//  RxThings
//
//  Created by silly on 17/02/2017.
//  Copyright © 2017 silly. All rights reserved.
//

import Foundation
import SQLite

class TasksManager {
    
    static let idEx = Expression<Int64>("id")
    static let titleEx = Expression<String>("title")
    static let hasRemindDate = Expression<Bool?>("hasRemindDate")
    static let remindDate = Expression<Date?>("remindDate")
    static let repeatTimes = Expression<Int64?>("repeatTimes")
    static let isDue = Expression<Bool?>("isDue")
    static let dueDate = Expression<Date?>("dueDate")
    
    /// Make Singleton
    var db: Connection?

    static let singleton: TasksManager = {
        let instance = TasksManager()
        return instance
    }()
    
    private init() {
        do {
            self.db = try Connection("\(DBConstant.dbPath)/db.sqlite3")
            print(NSHomeDirectory())
        } catch {
            self.db = nil
        }
    }
    
}

extension TasksManager {
    
    class func createTable() {
        let db = TasksManager.singleton.db
        if db != nil {
            let tasks = Table(DBConstant.tasksTableName)
            do {
                try db!.run(tasks.create(ifNotExists: true) { t in
                    t.column(TasksManager.idEx, primaryKey: true)
                    t.column(TasksManager.titleEx)
                    t.column(TasksManager.hasRemindDate)
                    t.column(TasksManager.remindDate)
                    t.column(TasksManager.repeatTimes)
                    t.column(TasksManager.isDue)
                    t.column(TasksManager.dueDate)
                })
            } catch {
                print("Create Table failed")
            }
        } else {
            print("Connect to DB failed")
        }
    }
    
    class func dropTable() {
        let db = TasksManager.singleton.db
        if db != nil {
            let tasks = Table(DBConstant.tasksTableName)
            do {
                try db!.run(tasks.drop(ifExists: true))
            } catch {
                print("Drop Table failed")
            }
        } else {
            print("Connect to DB failed")
        }
    }
    
    public func save(_ task: Task) {
        let db = TasksManager.singleton.db
        if db != nil {
            let tasks = Table(DBConstant.tasksTableName)
            do {
                let rowId = try db!.run(tasks.insert(TasksManager.titleEx <- task.title))
                print("Record Id: \(rowId)")
            } catch {
                print("Insert New Task Failed")
            }
        } else {
            print("Connect To DB Failed!")
        }
    }
    
    public func fetchInbox() -> [Task] {
        var ret: [Task] = []
        let db = TasksManager.singleton.db
        if db != nil {
            let tasks = Table(DBConstant.tasksTableName)
            do {
                for task in try db!.prepare(tasks) {
                    ret.append(Task(title: task[TasksManager.titleEx]))
                    print(task)
                }
                return ret
            } catch {
                print("Fetch Inobx Failed")
                return ret
            }
        } else {
            print("Connect To DB Failed!")
            return ret
        }
    }
    
}
