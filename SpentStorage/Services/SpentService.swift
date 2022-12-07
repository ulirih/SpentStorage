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

class SpentService: ServiceProtocol {
    
    private var dbManager = CoreDataManager.shared
    
    func getCategories() throws -> [CategoryModel] {
        let sort = [NSSortDescriptor(key: "name", ascending: true)]
        let result = try dbManager.getData(
            entityName: String(describing: CategoryEntity.self),
            predicate: nil,
            sort: sort
        ) as? [CategoryEntity]
        
        if result?.isEmpty ?? true {
            return try addDefaultCategories()
        }
        
        return result?.map { CategoryModel(id: $0.id, name: $0.name) } ?? []
    }
    
    func addCategory(for category: CategoryModel) throws {
        dbManager.context.insert(categoryModelToEntity(category: category))
        try dbManager.save()
    }
    
    func getSpents(on date: Date) throws -> [SpentModel] {
        return try getSpents(startDate: date, endDate: date)
    }
    
    func getSpents(startDate: Date, endDate: Date) throws -> [SpentModel] {
        let predicate = NSPredicate(
            format: "date >= %@ and date <= %@",
            Calendar.current.startOfDay(for: startDate) as CVarArg,
            Calendar.current.startOfDay(for: endDate).addingTimeInterval(86400.0) as CVarArg
        )
        
        let result = try dbManager.getData(
            entityName: String(describing: SpentEntity.self),
            predicate: predicate,
            sort: nil
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
    
    func addDefaultCategories() throws -> [CategoryModel] {
        // TODO: move to config
        let defaultNames = [
            "Авто", "Продукты", "Спортзал", "Курсы-Кружки", "Бары-Рестораны", "Такси",
            "Кофе", "Одежда", "Техника", "Мебель", "Стк", "ЖКХ"
        ]
        
        var defaultCategories: [CategoryModel] = []
        defaultNames.forEach { categoryName in
            let model = CategoryModel(id: UUID(), name: categoryName)
            dbManager.context.insert(categoryModelToEntity(category: model))
            defaultCategories.append(model)
        }
        try dbManager.save()
        
        return defaultCategories
    }
}
