//
//  CategoryEntity+CoreDataProperties.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 04.11.2022.
//
//

import Foundation
import CoreData


extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var spentOf: NSSet

}

// MARK: Generated accessors for spentOf
extension CategoryEntity {

    @objc(addSpentOfObject:)
    @NSManaged public func addToSpentOf(_ value: SpentEntity)

    @objc(removeSpentOfObject:)
    @NSManaged public func removeFromSpentOf(_ value: SpentEntity)

    @objc(addSpentOf:)
    @NSManaged public func addToSpentOf(_ values: NSSet)

    @objc(removeSpentOf:)
    @NSManaged public func removeFromSpentOf(_ values: NSSet)

}

extension CategoryEntity : Identifiable {

}
