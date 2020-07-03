//
//  Event.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/2/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class Model {
    let storageManager = StorageManager()
    var tasks = [Task]()
    var lists = [Lists]()
    
    
    init() {
        _ = getTasks()
    }
    
    func getTasks() -> [[Task]] {
        do {
            
            let sortDescriptor = NSSortDescriptor(key: "orderPosition", ascending: true)
            tasks = try storageManager.request(descriptors: [sortDescriptor])
            return getTask2d()
            
        } catch let error as NSError {
            print(error.userInfo)
            return [[Task]]()
        }
    }
    
    
    func delete(_ task: Task?) {
        guard let task = task else { return }
        storageManager.delete(object: task)
        storageManager.save()
    }
}

extension Model {
    func getList() -> [Lists] {
        do {
            return try storageManager.request(descriptors: nil)
        } catch let error as NSError {
            print("Error - \(error.userInfo)")
            return [Lists]()
        }
    }
    
    private func getTask2d() -> [[Task]] {
        var tasks2D = [[Task]]()
        var todayTasks = [Task]()
        var tomorrowTasks = [Task]()
        var laterTasks = [Task]()
        
        let todayDate = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 1
        let tomorrowDate = calendar.date(byAdding: dateComponents, to: todayDate)!
        
        for task in tasks {
            let dateNotification = task.dateNotification ?? Date()
            
            let taskDay = calendar.component(.day, from: dateNotification)
            let today = calendar.component(.day, from: todayDate)
            let tomorrow = calendar.component(.day, from: tomorrowDate)
            
            switch taskDay {
            case today:
                todayTasks.append(task)
            case tomorrow:
                tomorrowTasks.append(task)
            default:
                laterTasks.append(task)
            }
        }
        
        tasks2D.append(todayTasks)
        tasks2D.append(tomorrowTasks)
        tasks2D.append(laterTasks)
        
        for (index ,todayTask) in todayTasks.enumerated() {
            todayTask.orderPosition = Int64(index)
        }
        
        for (index ,todayTask) in todayTasks.enumerated() {
            todayTask.orderPosition = Int64(index)
        }
        
        for (index ,tomorrowTask) in tomorrowTasks.enumerated() {
            tomorrowTask.orderPosition = Int64(index * 1000)
        }
        
        for (index ,laterTasks) in laterTasks.enumerated() {
            laterTasks.orderPosition = Int64(index * 10000)
        }
        
        storageManager.save()
        
        return tasks2D
    }
}
