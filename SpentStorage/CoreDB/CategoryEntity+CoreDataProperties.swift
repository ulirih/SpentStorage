//
//  CategoryEntity+CoreDataProperties.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 01.11.2022.
//
//

import Foundation
import CoreData


extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?

}

extension CategoryEntity : Identifiable {

}
