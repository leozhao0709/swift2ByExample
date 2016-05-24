//
//  EditTodoTableViewController.swift
//  Todolist
//
//  Created by Lei Zhao on 5/23/16.
//  Copyright © 2016 Lei Zhao. All rights reserved.
//

import UIKit

class EditTodoTableViewController: UITableViewController {

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    var todoToEdit: Todo?
    var todosDatastore: TodosDatastore?
    
    private var list: List?
    private var dueDate: NSDate?
}

private extension EditTodoTableViewController {
    func datePickerSetup() {
        self.dueDatePicker.datePickerMode = .DateAndTime
        self.dueDatePicker.minimumDate = NSDate()
        self.dueDatePicker.date = dueDate!
        self.dueDatePicker.addTarget(self, action: #selector(EditTodoTableViewController.dueDateChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func setup() {
        if let todo = todoToEdit {
            descriptionTextField.text = todo.description
            list = todo.list
            dueDate = todo.dueDate
        } else if let todosDatastore = todosDatastore {
            list = todosDatastore.defaultList()
            dueDate = todosDatastore.defaultDueDate()
        }
        datePickerSetup()
    }
}

// MARK: Actions
extension EditTodoTableViewController {
    func dueDateChanged(sender: UIButton!) {
        dueDate = dueDatePicker.date
        refresh()
    }
    
    func refresh(){
        listLabel.text = "List: \(list!.description)"
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm dd-MM-YY"
        if let dueDate = dueDate {
            let formattedDueDate = dateFormatter.stringFromDate(dueDate)
            dueDateLabel.text = "Due date: \(formattedDueDate)"
        }
    }
}