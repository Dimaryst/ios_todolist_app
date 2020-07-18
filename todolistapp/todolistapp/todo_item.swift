//
//  todo_item.swift
//  todolistapp
//
//  Created by  Dimary on 13.07.2020.
//  Copyright © 2020  Dimary. All rights reserved.
//

import Foundation

// class with toDo items
class ToDoItem
{
    var Title: String
    var isCompleted: Bool
    
    public init(Title: String)
    {
        self.Title = Title
        self.isCompleted = false // default
    }
    
    public class func getDefaultData() -> [ToDoItem]
    {
        return [
            ToDoItem(Title: "Add saving to DB"),
            ToDoItem(Title: "Find the meaning of life"),
        ]
    }
}

