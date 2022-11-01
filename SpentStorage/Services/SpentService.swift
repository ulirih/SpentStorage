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

    // TODO: will move to settings
    func addDefaultCategories() -> Void
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

// MARK: - default category data
extension SpentService {
    func addDefaultCategories() {
        let data: [CategoryModel] = [
            CategoryModel(id: UUID(), name: "Авто"),
            CategoryModel(id: UUID(), name: "Продукты"),
            CategoryModel(id: UUID(), name: "Спортзал"),
            CategoryModel(id: UUID(), name: "Курсы/Кружки"),
            CategoryModel(id: UUID(), name: "Бары/Рестораны"),
            CategoryModel(id: UUID(), name: "Такси"),
            CategoryModel(id: UUID(), name: "Кофе"),
            CategoryModel(id: UUID(), name: "Одежда"),
            CategoryModel(id: UUID(), name: "Техника"),
            CategoryModel(id: UUID(), name: "Мебель"),
        ]
        
        data.forEach {
            let category = CategoryEntity(context: dbManager.context)
            category.id = $0.id
            category.name = $0.name
            dbManager.context.insert(category)
        }
        try? dbManager.save()
    }
}
