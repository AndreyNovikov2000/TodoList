//
//  StorageManager.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/12/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import CoreData

protocol StoreManager {
    func createEntity<T: NSManagedObject>(entityName: String) -> T
    func delete<T: NSManagedObject>(object: T)
    func request<T: NSManagedObject>(descriptors: [NSSortDescriptor]?) throws -> [T]
    func save()
}

class StorageManager: StoreManager {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createEntity<T: NSManagedObject>(entityName: String) -> T {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context), let object = NSManagedObject(entity: entity, insertInto: context) as? T  else { fatalError("Error: The entity does no exist, entity name - \(String(describing: T.self))!") }
        
        return object
    }
    
    func delete<T: NSManagedObject>(object: T) {
        context.delete(object)
    }
    
    func request<T: NSManagedObject>(descriptors: [NSSortDescriptor]?) throws -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.sortDescriptors = descriptors
        
        return try context.fetch(fetchRequest)
    }
    
    func save() {
        do {
            try context.save()
        } catch let error as NSError {
            print("error - \(error.userInfo)")
        }
    }
}
