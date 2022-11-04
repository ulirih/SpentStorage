//
//  SpentEntity+CoreDataProperties.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 04.11.2022.
//
//

import Foundation
import CoreData


extension SpentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpentEntity> {
        return NSFetchRequest<SpentEntity>(entityName: "SpentEntity")
    }

    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var price: Float
    @NSManaged public var type: CategoryEntity

}

extension SpentEntity : Identifiable {

}
