//
//  ListModel.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class ListModel {
   let storageManager = StorageManager()
   
   init() {
       
   }
}



// MARK: - Draging
extension ListModel {
    
    func getDragItems(for list: Lists?, for indexPath: IndexPath) -> [UIDragItem]  {
        let detailList = list?.detailLists?[indexPath.row] as? DetailList
        
        let data = try! NSKeyedArchiver.archivedData(withRootObject: detailList!, requiringSecureCoding: false)
        let itemProvider = NSItemProvider()
        itemProvider.registerDataRepresentation(forTypeIdentifier: "detailList" , visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        
        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
}
