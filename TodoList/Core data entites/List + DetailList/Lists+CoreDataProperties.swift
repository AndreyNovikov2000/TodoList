//
//  Lists+CoreDataProperties.swift
//  
//
//  Created by Andrey Novikov on 5/18/20.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "Lists")
    }

    @NSManaged public var title: String?
    @NSManaged public var titntColor: NSObject?
    @NSManaged public var detailLists: NSOrderedSet?

}

// MARK: Generated accessors for detailLists
extension List {

    @objc(insertObject:inDetailListsAtIndex:)
    @NSManaged public func insertIntoDetailLists(_ value: DetailList, at idx: Int)

    @objc(removeObjectFromDetailListsAtIndex:)
    @NSManaged public func removeFromDetailLists(at idx: Int)

    @objc(insertDetailLists:atIndexes:)
    @NSManaged public func insertIntoDetailLists(_ values: [DetailList], at indexes: NSIndexSet)

    @objc(removeDetailListsAtIndexes:)
    @NSManaged public func removeFromDetailLists(at indexes: NSIndexSet)

    @objc(replaceObjectInDetailListsAtIndex:withObject:)
    @NSManaged public func replaceDetailLists(at idx: Int, with value: DetailList)

    @objc(replaceDetailListsAtIndexes:withDetailLists:)
    @NSManaged public func replaceDetailLists(at indexes: NSIndexSet, with values: [DetailList])

    @objc(addDetailListsObject:)
    @NSManaged public func addToDetailLists(_ value: DetailList)

    @objc(removeDetailListsObject:)
    @NSManaged public func removeFromDetailLists(_ value: DetailList)

    @objc(addDetailLists:)
    @NSManaged public func addToDetailLists(_ values: NSOrderedSet)

    @objc(removeDetailLists:)
    @NSManaged public func removeFromDetailLists(_ values: NSOrderedSet)

}
