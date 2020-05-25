//
//  DetailList+CoreDataProperties.swift
//  
//
//  Created by Andrey Novikov on 5/18/20.
//
//

import Foundation
import CoreData


extension DetailList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DetailList> {
        return NSFetchRequest<DetailList>(entityName: "DetailList")
    }

    @NSManaged public var title: String?
    @NSManaged public var notificationDate: Date?
    @NSManaged public var isNotificate: Bool
    @NSManaged public var list: List?

}
