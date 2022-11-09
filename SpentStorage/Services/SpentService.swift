//
//  SpentService.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 01.11.2022.
//

import Foundation
import CoreData

enum ServiceError: Error {
    case DBError
    case UndefinedCategoryError
}

protocol SpentServiceProtocol {
    func getCategories() throws -> [CategoryModel]
    func addCategory(for category: CategoryModel) throws -> Void
    func addSpent(for spent: SpentModel) throws -> Void
    func getSpents(on date: Date) throws -> [SpentModel]

    // TODO: will move to settings
    func addDefaultCategories() -> Void
}

class SpentService: SpentServiceProtocol {
    
    private var dbManager = CoreDataManager.shared
    
    func getCategories() throws -> [CategoryModel] {
        let sort = [NSSortDescriptor(key: "name", ascending: true)]
        let result = try dbManager.getData(
            entityName: String(describing: CategoryEntity.self),
            predicate: nil,
            sort: sort
        ) as? [CategoryEntity]
        
        return result?.map { CategoryModel(id: $0.id, name: $0.name) } ?? []
    }
    
    func addCategory(for category: CategoryModel) throws {
        dbManager.context.insert(categoryModelToEntity(category: category))
        try dbManager.save()
    }
    
    func getSpents(on date: Date) throws -> [SpentModel] {
        let predicate = NSPredicate(format: "date >= %@ and date <= %@", Calendar.current.startOfDay(for: date) as CVarArg, Calendar.current.startOfDay(for: date).addingTimeInterval(86400.0) as CVarArg)
        
        let sort = [NSSortDescriptor(key: "date", ascending: false)]
        
        let result = try dbManager.getData(
            entityName: String(describing: SpentEntity.self),
            predicate: predicate,
            sort: sort
        ) as? [SpentEntity]
        
        return result?.map { SpentModel(id: $0.id, date: $0.date, price: $0.price, type: $0.type.toModel()) } ?? []
    }
    
    func addSpent(for spent: SpentModel) throws {
        let entity = try spentModelToEntity(spent: spent)
        dbManager.context.insert(entity)
        try dbManager.save()
    }
}

extension SpentService {
    private func categoryModelToEntity(category model: CategoryModel) -> CategoryEntity {
        let category = CategoryEntity(context: dbManager.context)
        category.id = model.id
        category.name = model.name
        
        return category
    }
    
    private func spentModelToEntity(spent model: SpentModel) throws -> SpentEntity {
        let predicate = NSPredicate(format: "id == %@", model.type.id.uuidString)
        let categories = try? dbManager.getData(
            entityName: String(describing: CategoryEntity.self),
            predicate: predicate,
            sort: nil
        ) as? [CategoryEntity]
        
        guard let category = categories?.first else { throw ServiceError.UndefinedCategoryError }
        
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
