//
//  Task+CoreDataProperties.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/12/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var taskTitle: String?
    @NSManaged public var isComplite: Bool
    @NSManaged public var isNotificate: Bool
    @NSManaged public var dateNotification: Date?
    @NSManaged public var degreeOfProtection: Int16
    @NSManaged public var taskId: UUID?
    @NSManaged public var subTasks: NSOrderedSet?
    @NSManaged public var orderPosition: Int64
}

// MARK: Generated accessors for subTasks
extension Task {

    @objc(addSubTasksObject:)
    @NSManaged public func addToSubTasks(_ value: SubTask)

    @objc(removeSubTasksObject:)
    @NSManaged public func removeFromSubTasks(_ value: SubTask)

    @objc(addSubTasks:)
    @NSManaged public func addToSubTasks(_ values: NSSet)

    @objc(removeSubTasks:)
    @NSManaged public func removeFromSubTasks(_ values: NSSet)

}
