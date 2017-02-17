//
//  ToDoTaskModel.swift
//  RxThings
//
//  Created by silly on 16/02/2017.
//  Copyright © 2017 silly. All rights reserved.
//

import Foundation
import SQLite

class TodoTask {
    
    static let idEx = Expression<Int64>("id")
    static let titleEx = Expression<String>("title")
    

    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    public func save() {
        do {
            let db = try Connection("\(DBConstant.dbPath)/db.sqlite3")
            let tasks = Table(DBConstant.tasksTableName)
            do {
                let rowId = try db.run(tasks.insert(TodoTask.titleEx <- self.title))
                print("Record Id: \(rowId)")
            } catch {
                print("Insert New Task Failed")
            }
        } catch {
            print("Connect To DB Failed!")
        }
    }
    
}

extension TodoTask {
    
    static func createTable() {
        do {
            let db = try Connection("\(DBConstant.dbPath)/db.sqlite3")
            let tasks = Table(DBConstant.tasksTableName)
            do {
                try db.run(tasks.create(ifNotExists: true) { t in
                    t.column(self.idEx, primaryKey: true)
                    t.column(self.titleEx)
                })
            } catch {
                print("Create Table failed")
            }
        } catch {
            print("Connect to DB failed")
        }
    }
    
    static func fetchAll() -> [String] {
        var ret: [String] = []
        
        do {
            let db = try Connection("\(DBConstant.dbPath)/db.sqlite3")
            let tasks = Table(DBConstant.tasksTableName)
            do {
                for task in try db.prepare(tasks) {
                    ret.append("\(task[TodoTask.titleEx])")
                }
            } catch {
                print("Fetch All Tasks Failed")
            }
        } catch {
            print("Connect To DB Failed!")
        }
        
        return ret
    }
    
}
