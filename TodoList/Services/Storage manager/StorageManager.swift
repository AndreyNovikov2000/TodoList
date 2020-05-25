//
//  StorageManager.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/12/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import CoreData

protocol StoreManager {
    func createEntity<T: NSManagedObject>(entityName: String, contex: NSManagedObjectContext) -> T
    func delete<T: NSManagedObject>(_ contex: NSManagedObjectContext, object: T)
    func request<T: NSManagedObject>(contex: NSManagedObjectContext) throws -> [T]
    func save(_ context: NSManagedObjectContext)
}

class StorageManager: StoreManager {
    
    func createEntity<T: NSManagedObject>(entityName: String, contex: NSManagedObjectContext) -> T {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: contex), let object = NSManagedObject(entity: entity, insertInto: contex) as? T  else { fatalError("Error: The entity does no exist, entity name - \(String(describing: T.self))!") }
       
        return object
    }
    
    func delete<T: NSManagedObject>(_ contex: NSManagedObjectContext, object: T) {
        contex.delete(object)
    }
    
    func request<T: NSManagedObject>(contex: NSManagedObjectContext) throws -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
    
        return try contex.fetch(fetchRequest)
    }

    func save(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error as NSError {
            print("error - \(error.userInfo)")
        }
    }
}
