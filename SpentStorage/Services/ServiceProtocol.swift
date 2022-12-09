//
//  ServiceProtocol.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 07.12.2022.
//

import Foundation

protocol ServiceProtocol: AnyObject {
    func getCategories(completion: @escaping (Result<[CategoryModel], ServiceError>) -> Void) -> Void
    func getSpents(on date: Date, completion: @escaping (Result<[SpentModel], ServiceError>) -> Void) -> Void
    func getSpents(startDate: Date, endDate: Date, completion: @escaping (Result<[SpentModel], ServiceError>) -> Void) -> Void
    func addCategory(for category: CategoryModel) throws -> Void
    func addSpent(for spent: SpentModel) throws -> Void
}

enum ServiceError: Error {
    case internalError
    case undefinedCategoryError
}
