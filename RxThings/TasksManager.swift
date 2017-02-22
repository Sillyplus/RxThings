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
    static let remindDateEx = Expression<Date?>("remindDate")
    static let repeatTimesEx = Expression<Int64?>("repeatTimes")
    static let dueDateEx = Expression<Date?>("dueDate")
    static let noteEx = Expression<String?>("note")
    static let doneEx = Expression<Bool>("done")
    
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
                    t.column(TasksManager.remindDateEx)
                    t.column(TasksManager.repeatTimesEx)
                    t.column(TasksManager.dueDateEx)
                    t.column(TasksManager.noteEx)
                    t.column(TasksManager.doneEx, defaultValue: false)
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
    
    public func update(_ task: Task) {
        let db = TasksManager.singleton.db
        if db != nil {
            let tasks = Table(DBConstant.tasksTableName)
            let taskRow = tasks.filter(TasksManager.idEx == task.id!)
            do {
                if try db!.run(taskRow.update([TasksManager.titleEx <- task.title,
                                               TasksManager.remindDateEx <- task.remindDate,
                                               TasksManager.repeatTimesEx <- task.repeatTimes,
                                               TasksManager.dueDateEx <- task.dueDate,
                                               TasksManager.noteEx <- task.note,
                                               TasksManager.doneEx <- task.done])) > 0 {
                    print("Update task success")
                } else {
                    print("No task updated")
                }
            } catch {
                print("Update task failed")
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
            let query = tasks.select(tasks[*])
                             .filter(TasksManager.remindDateEx == nil &&
                                     TasksManager.dueDateEx == nil &&
                                     TasksManager.doneEx == false)
                             .order(TasksManager.idEx.desc)
            do {
                for task in try db!.prepare(query) {
                    ret.append(Task(title: task[TasksManager.titleEx]))
                    log.info(task)
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
