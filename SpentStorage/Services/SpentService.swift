//
//  SpentService.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 01.11.2022.
//

import Foundation
import CoreData

protocol SpentServiceProtocol {
    func getCategories() -> [CategoryModel]
    func addCategory(for category: CategoryModel) -> Void
}

class SpentService: SpentServiceProtocol {
    
    private var dbManager = CoreDataManager.shared
    
    func getCategories() -> [CategoryModel] {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        do {
            let result = try dbManager.context.fetch(request)

            return result.map { CategoryModel(id: $0.id, name: $0.name) }
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func addCategory(for category: CategoryModel) {
        let category = CategoryEntity(context: dbManager.context)
        category.id = category.id
        category.name = category.name
        
        dbManager.context.insert(category)
        try? dbManager.save()
    }
}
