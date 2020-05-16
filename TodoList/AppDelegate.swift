//
//  AppDelegate.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let notificationManager = NotificationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        notificationManager.setupNotificationCenter()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        save()
    }
    
    // MARK: - Core data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoList")
        container.loadPersistentStores { (store, error) in
            if let error = error {
                print("error - \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    func save() {
        let contex = persistentContainer.viewContext
        
        do {
            try contex.save()
        } catch let error as NSError {
            print("error - \(error.userInfo)")
        }
    }
}
