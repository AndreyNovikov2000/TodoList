//
//  SubTaskModel.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation

class TaskModel {
    private let notifications = NotificationManager.current
    
    func setCalendarNotification(with task: Task, dateComponets: DateComponents) {
        guard let taskId = task.taskId, let body = task.taskTitle  else { return }
        let taskNotification = TaskNotifications(title: "Title", body: body)
        notifications.setCalendarNotification(with: taskNotification, dateComponents: dateComponets, indentifier: taskId)
    }
}

