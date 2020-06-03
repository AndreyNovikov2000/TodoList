//
//  List+CoreDataProperties.swift
//  
//
//  Created by Andrey Novikov on 5/31/20.
//
//

import Foundation
import CoreData


extension Lists {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lists> {
        return NSFetchRequest<Lists>(entityName: "List")
    }

    @NSManaged public var title: String?
    @NSManaged public var titntColor: Data?
    @NSManaged public var detailLists: NSOrderedSet?

}

// MARK: Generated accessors for detailLists
extension Lists {

    @objc(addDetailListsObject:)
    @NSManaged public func addToDetailLists(_ value: DetailList)

    @objc(removeDetailListsObject:)
    @NSManaged public func removeFromDetailLists(_ value: DetailList)

    @objc(addDetailLists:)
    @NSManaged public func addToDetailLists(_ values: NSOrderedSet)

    @objc(removeDetailLists:)
    @NSManaged public func removeFromDetailLists(_ values: NSOrderedSet)

}

