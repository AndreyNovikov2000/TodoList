//
//  NotificationManager.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/15/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation
import UserNotifications

protocol UNotifications {
    func setCalendarNotification(with task: TaskNotifications, dateComponents: DateComponents, indentifier: String)
    func deleteNotification(with identifier: String)
}

class NotificationManager: NSObject, UNotifications {
    
    static let current = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Public methods
    
    func configure() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (success , error) in
            if let error = error {
                print("Error - \(error.localizedDescription)")
            }
            
            guard success else { return }
            
        }
        
        self.notificationCenter.getNotificationSettings { notificationSetting in
            guard notificationSetting.authorizationStatus == .authorized else { return }
        }
        
        notificationCenter.delegate = self
    }

    
    func setCalendarNotification(with task: TaskNotifications, dateComponents: DateComponents, indentifier: String) {
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.body
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: indentifier, content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error - \(error.localizedDescription)")
                return
            }
        }
    }
    
    func deleteNotification(with identifier: String) {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.body)
        completionHandler()
    }
}


