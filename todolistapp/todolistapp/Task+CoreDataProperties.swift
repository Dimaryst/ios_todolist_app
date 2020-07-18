//
//  Task+CoreDataProperties.swift
//  todolistapp
//
//  Created by  Dimary on 14.07.2020.
//  Copyright © 2020  Dimary. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var task_text: String?

}
