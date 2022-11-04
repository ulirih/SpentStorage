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
    func addSpent(_ spent: SpentModel) -> Void
    func getSpents() -> [SpentModel]

    // TODO: will move to settings
    func addDefaultCategories() -> Void
}

class SpentService: SpentServiceProtocol {
    
    private var dbManager = CoreDataManager.shared
    private var categoriesEntity: [CategoryEntity] = []
    
    func getCategories() -> [CategoryModel] {
        do {
            let sort = [NSSortDescriptor(key: "name", ascending: true)]
            let result = try dbManager.getData(entityName: String(describing: CategoryEntity.self), predicate: nil, sort: sort) as? [CategoryEntity]

            return result?.map { CategoryModel(id: $0.id, name: $0.name) } ?? []
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func addCategory(for category: CategoryModel) {
        dbManager.context.insert(categoryModelToEntity(category: category))
        try? dbManager.save()
    }
    
    func getSpents() -> [SpentModel] {
        do {
            let sort = [NSSortDescriptor(key: "date", ascending: true)]
            let result = try dbManager.getData(entityName: String(describing: SpentEntity.self), predicate: nil, sort: sort) as? [SpentEntity]

            return result?.map { SpentModel(id: $0.id, date: $0.date, price: $0.price, type: $0.type.toModel()) } ?? []
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func addSpent(_ spent: SpentModel) {
        if let entity = spentModelToEntity(spent: spent) {
            dbManager.context.insert(entity)
            try? dbManager.save()
        }
    }
}

extension SpentService {
    private func categoryModelToEntity(category model: CategoryModel) -> CategoryEntity {
        let category = CategoryEntity(context: dbManager.context)
        category.id = model.id
        category.name = model.name
        
        return category
    }
    
    private func spentModelToEntity(spent model: SpentModel) -> SpentEntity? {
        let predicate = NSPredicate(format: "id == %@", model.type.id.uuidString)
        let categories = try? dbManager.getData(
            entityName: String(describing: SpentEntity.self),
            predicate: predicate,
            sort: nil
        ) as? [CategoryEntity]
        
        guard let category = categories?.first else { return nil }
        
        let entity = SpentEntity(context: dbManager.context)
        entity.id = model.id
        entity.date = model.date
        entity.price = model.price
        entity.type = category
        
        return entity
    }
    
    func addDefaultCategories() {
        let data: [CategoryModel] = [
            CategoryModel(id: UUID(), name: "Авто"),
            CategoryModel(id: UUID(), name: "Продукты"),
            CategoryModel(id: UUID(), name: "Спортзал"),
            CategoryModel(id: UUID(), name: "Курсы-Кружки"),
            CategoryModel(id: UUID(), name: "Бары-Рестораны"),
            CategoryModel(id: UUID(), name: "Такси"),
            CategoryModel(id: UUID(), name: "Кофе"),
            CategoryModel(id: UUID(), name: "Одежда"),
            CategoryModel(id: UUID(), name: "Техника"),
            CategoryModel(id: UUID(), name: "Мебель"),
            CategoryModel(id: UUID(), name: "Стк"),
        ]
        
        data.forEach { dbManager.context.insert(categoryModelToEntity(category: $0)) }
        try? dbManager.save()
    }
}
