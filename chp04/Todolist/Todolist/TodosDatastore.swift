//
//  TodosDatastore.swift
//  Todolist
//
//  Created by Lei Zhao on 5/22/16.
//  Copyright © 2016 Lei Zhao. All rights reserved.
//

import Foundation

class TodosDatastore {
    private var savedLists = [List]()
    private var savedTodos = [Todo]()
    
    init(){
        savedLists = [
            List(description: "Persional"),
            List(description: "Work"),
            List(description: "Family")
        ]
        savedTodos = [
            Todo(description: "Remember the Milk",
                list: List(description: "Family"),
                dueDate: NSDate(),
                done: false,
                doneDate: nil),
            Todo(description: "Buy Spider Man Comics",
                list: List(description: "Personal"),
                dueDate: NSDate(),
                done: true,
                doneDate: nil),
            Todo(description: "Release build",
                list: List(description: "Work"),
                dueDate: NSDate(),
                done: false,
                doneDate: nil)
        ]
    }
    
    func todos()->[Todo] {
        return savedTodos
    }
    
    func lists()->[List] {
        return [defaultList()] + savedLists
    }
}

//MARK: Actions
extension TodosDatastore {
    func addTodo(todo: Todo) {
        savedTodos = savedTodos + [todo]
    }
    func deleteTodo(todo: Todo?) {
        if let todo = todo {
            savedTodos = savedTodos.filter({$0 != todo})
        }
    }
    
    func doneTodo(todo: Todo) {
        deleteTodo(todo)
        let doneTodo = Todo(description: todo.description,
                            list: todo.list,
                            dueDate: todo.dueDate,
                            done: true,
                            doneDate: NSDate())
        addTodo(doneTodo)
    }
    
    func addListDescription(description: String) {
        if !description.isEmpty {
            savedLists = savedLists + [List(description: description)]
        }
    }
}

// MARK: Defaults
extension TodosDatastore {
    func defaultList() -> List {
        return List(description: "Personal")
    }
    
    func defaultDueDate() -> NSDate {
        let now = NSDate()
        let secondsInADay = NSTimeInterval(24 * 60 * 60)
        return now.dateByAddingTimeInterval(secondsInADay)
    }
}