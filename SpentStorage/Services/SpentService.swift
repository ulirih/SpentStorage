//
//  SpentService.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 01.11.2022.
//

import Foundation
import CoreData

class SpentService: ServiceProtocol {
    
    private var dbManager = CoreDataManager.shared
    
    func getCategories(completion: @escaping (Result<[CategoryModel], ServiceError>) -> Void) {
        let sort = [NSSortDescriptor(key: "name", ascending: true)]
        dbManager.getData(
            entityName: String(describing: CategoryEntity.self),
            predicate: nil,
            sort: sort
        ) { result in
            switch result {
            case .success(let items):
                var categories: [CategoryModel] = []
                if items.isEmpty {
                    categories = try! self.addDefaultCategories()
                } else {
                    categories = items.map { item in
                        let entity = item as! CategoryEntity
                        return CategoryModel(id: entity.id, name: entity.name)
                    }
                }
                completion(.success(categories))
            case .failure:
                completion(.failure(.internalError))
            }
        }
    }
    
    func addCategory(for category: CategoryModel) throws {
        dbManager.context.insert(categoryModelToEntity(category: category))
        try dbManager.save()
    }
    
    func getSpents(on date: Date, completion: @escaping (Result<[SpentModel], ServiceError>) -> Void) {
        getSpents(startDate: date, endDate: date) { result in
            completion(result)
        }
    }
    
    func getSpents(startDate: Date, endDate: Date, completion: @escaping (Result<[SpentModel], ServiceError>) -> Void) {
        let predicate = NSPredicate(
            format: "date >= %@ and date <= %@",
            Calendar.current.startOfDay(for: startDate) as CVarArg,
            Calendar.current.startOfDay(for: endDate).addingTimeInterval(86400.0) as CVarArg
        )
        
        dbManager.getData(
            entityName: String(describing: SpentEntity.self),
            predicate: predicate,
            sort: nil
        ) { result in
            switch result {
            case .success(let items):
                var spents: [SpentModel] = []
                items.forEach { item in
                    let entity = item as! SpentEntity
                    spents.append(SpentModel(id: entity.id, date: entity.date, price: entity.price, type: entity.type.toModel()))
                }
                completion(.success(spents))
                
            case .failure:
                completion(.failure(.internalError))
            }
        }
    }
    
    func addSpent(for spent: SpentModel) throws {
        try spentModelToEntity(spent: spent) { entity in
            self.dbManager.context.insert(entity)
            try? self.dbManager.save()
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
    
    private func spentModelToEntity(spent model: SpentModel, completion: @escaping (SpentEntity) -> Void) throws {
        let predicate = NSPredicate(format: "id == %@", model.type.id.uuidString)
        dbManager.getData(
            entityName: String(describing: CategoryEntity.self),
            predicate: predicate,
            sort: nil
        ) { result in
            switch result {
            case .success(let items):
                guard let category = items.first, category is CategoryEntity else {
                    print("Error")
                    return
                }
                
                let entity = SpentEntity(context: self.dbManager.context)
                entity.id = model.id
                entity.date = model.date
                entity.price = model.price
                entity.type = category as! CategoryEntity
                completion(entity)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
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
