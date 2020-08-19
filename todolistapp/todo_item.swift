//
//  todo_item.swift
//  todolistapp
//
//  Created by  Dimary on 13.07.2020.
//  Copyright © 2020  Dimary. All rights reserved.
//

import Foundation

// class with toDo items
class ToDoItem: NSObject, NSCoding
{
    var Title: String
    var isCompleted: Bool
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.Title, forKey: "title")
        aCoder.encode(self.isCompleted, forKey: "done")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        // Try to unserialize the "title" variable
        if let title = aDecoder.decodeObject(forKey: "title") as? String
        {
            self.Title = title
        }
        else
        {
            // There were no objects encoded with the key "title",
            // so that's an error.
            return nil
        }

        // Check if the key "done" exists, since decodeBool() always succeeds
        if aDecoder.containsValue(forKey: "done")
        {
            self.isCompleted = aDecoder.decodeBool(forKey: "done")
        }
        else
        {
            // Same problem as above
            return nil
        }
    }

    
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

extension Collection where Iterator.Element == ToDoItem
{
    // Builds the persistence URL. This is a location inside
    // the "Application Support" directory for the App.
    private static func persistencePath() -> URL?
    {
        let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)

        return url?.appendingPathComponent("todoitems.bin")
    }

    // Write the array to persistence
    func writeToPersistence() throws
    {
        if let url = Self.persistencePath(), let array = self as? NSArray
        {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            try data.write(to: url)
        }
        else
        {
            throw NSError(domain: "com.example.ToDo", code: 10, userInfo: nil)
        }
    }

    // Read the array from persistence
    static func readFromPersistence() throws -> [ToDoItem]
    {
        if let url = persistencePath(), let data = (try Data(contentsOf: url) as Data?)
        {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ToDoItem]
            {
                return array
            }
            else
            {
                throw NSError(domain: "com.example.ToDo", code: 11, userInfo: nil)
            }
        }
        else
        {
            throw NSError(domain: "com.example.ToDo", code: 12, userInfo: nil)
        }
    }
}
