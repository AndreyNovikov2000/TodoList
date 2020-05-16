//
//  NotificationManager.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/15/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject {
    let notificationCenter = UNUserNotificationCenter.current()
    
    func setupNotificationCenter() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (success , error) in
            if let error = error {
                print("Error - \(error.localizedDescription)")
            }
            
            guard success else { return }
            
            self.notificationCenter.getNotificationSettings { notificationSetting in
                guard notificationSetting.authorizationStatus == .authorized else { return }
            }
        }
        notificationCenter.delegate = self
    }
    
    func setNotification(with identifier: String, dateNotification: Date, repeats: Bool) {
//        let calendat = Calendar.current
//        let year = calendat.component(.year, from: dateNotification)
//        let month = calendat.component(.month, from: dateNotification)
//        let day = calendat.component(.day, from: dateNotification)
//        let hour = calendat.component(.hour, from: dateNotification)
//        let minute = calendat.component(.minute, from: dateNotification)
        
        let components = DateComponents()
//        components.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        let contextual = UNMutableNotificationContent()
//        contextual.body
        
        let request = UNNotificationRequest(identifier: identifier, content: contextual, trigger: trigger)
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error - \(error.localizedDescription)")
            }
        }
    }
    
    func deleteNotification(with identifier: String) {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
    }
    
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
}
