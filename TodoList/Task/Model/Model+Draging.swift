//
//  Model+Draging.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


extension Model {
    
    func getDragItems(with tasks2d: [[Task]], for indexPath: IndexPath) -> [UIDragItem]  {
        let task = tasks2d[indexPath.section][indexPath.row]
        let data = try! NSKeyedArchiver.archivedData(withRootObject: task, requiringSecureCoding: false)
        let itemProvider = NSItemProvider()
        itemProvider.registerDataRepresentation(forTypeIdentifier: "Task" , visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        
        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }

    
    func moveRow(with tasks2d: [[Task]], from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let calendar = Calendar.current
        let changeTask = tasks2d[destinationIndexPath.section][destinationIndexPath.row]
        let taskDate = changeTask.dateNotification ?? Date()
        
        switch (sourceIndexPath, destinationIndexPath) {
        case let (source, destination) where source.section == destination.section:
            // section does not change, today = today, tomorrow = tomorrow, later = later
            
            for (index, task) in tasks2d[sourceIndexPath.section].enumerated() {
                switch sourceIndexPath.section {
                case 0: task.orderPosition = Int64(index)
                case 1: task.orderPosition = Int64(index * 1000)
                case 2: task.orderPosition = Int64(index * 10000)
                default: break
                }
            }
            
        case let (source, destination) where source.section == 0 && destination.section == 1:
            // move from today section to tomorrow section
            
            changeTask.dateNotification = calendar.replaceDate(fromDate: taskDate, byAdding: 1)
            for (index, task) in tasks2d[destination.section].enumerated() {
                task.orderPosition = Int64(index * 1000)
            }
            
        case let (source, destination) where source.section == 0 && destination.section == 2:
            // move from today section to later section
            
            changeTask.dateNotification = calendar.replaceDate(fromDate: taskDate, byAdding: 7)
            for (index, task) in tasks2d[destination.section].enumerated() {
                task.orderPosition = Int64(index * 10000)
            }
            
        case let (source, destination) where source.section == 1 && destination.section == 0:
            // move from tomorrow section to today section
            
            changeTask.dateNotification = calendar.replaceDate(fromDate: taskDate, byAdding: -1)
            for (index, task) in tasks2d[destination.section].enumerated() {
                task.orderPosition = Int64(index)
            }
            
        case let (source, destination) where source.section == 1 && destination.section == 2:
            // move from tomorrow section to later section
            
            changeTask.dateNotification = calendar.replaceDate(fromDate: taskDate, byAdding: 6)
            for (index, task) in tasks2d[destination.section].enumerated() {
                task.orderPosition = Int64(index * 10000)
            }
            
        case let (source, destination) where source.section == 2 && destination.section == 0:
            // move from later section to today section
            
            let today = Date()
            var components = DateComponents()
            
            components.year = calendar.component(.year, from: today)
            components.month = calendar.component(.month, from: today)
            components.day = calendar.component(.day, from: today)
            components.hour = calendar.component(.hour, from: taskDate)
            components.minute = calendar.component(.minute, from: taskDate)
            
            let newTodayDate = calendar.date(from: components)
            
            changeTask.dateNotification = newTodayDate
            
            for (index, task) in tasks2d[destination.section].enumerated() {
                task.orderPosition = Int64(index)
            }
            
        case let (source, destination) where source.section == 2 && destination.section == 1:
            // move from later section to tomorrow section
            
            let today = Date()
            var components = DateComponents()
            
            components.year = calendar.component(.year, from: today)
            components.month = calendar.component(.month, from: today)
            components.day = calendar.component(.day, from: today)
            components.hour = calendar.component(.hour, from: taskDate)
            components.minute = calendar.component(.minute, from: taskDate)
            
            let newTodayDate = calendar.date(from: components)
            
            changeTask.dateNotification = calendar.replaceDate(fromDate: newTodayDate, byAdding: 1)
            
            for (index, task) in tasks2d[destination.section].enumerated() {
                task.orderPosition = Int64(index)
            }
            
        default:
            break
        }
        
        storageManager.save()
    }
}
