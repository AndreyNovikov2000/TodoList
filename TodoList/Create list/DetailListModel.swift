//
//  DetailListModel.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/11/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation

class DetailListModel {
    private let notificationsManager = NotificationManager.current
    
    func setNotificationWith(with detailList: DetailList?, components: DateComponents) {
        guard let title = detailList?.title, let id = detailList?.taskId else { return }
        let taskNotification = TaskNotifications(title: "title", body: title)
        notificationsManager.setCalendarNotification(with: taskNotification, dateComponents: components, indentifier: id)
    }
}
