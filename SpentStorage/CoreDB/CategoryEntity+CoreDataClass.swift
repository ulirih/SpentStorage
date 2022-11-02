//
//  CategoryEntity+CoreDataClass.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 01.11.2022.
//
//

import Foundation
import CoreData


public class CategoryEntity: NSManagedObject {

}

extension CategoryEntity {
    func toModel() -> CategoryModel {
        return CategoryModel(id: self.id, name: self.name)
    }
}
