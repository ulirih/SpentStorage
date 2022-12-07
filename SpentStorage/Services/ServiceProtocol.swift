//
//  ServiceProtocol.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 07.12.2022.
//

import Foundation

protocol ServiceProtocol: AnyObject {
    func getCategories() throws -> [CategoryModel]
    func getSpents(on date: Date) throws -> [SpentModel]
    func getSpents(startDate: Date, endDate: Date) throws -> [SpentModel]
    func addCategory(for category: CategoryModel) throws -> Void
    func addSpent(for spent: SpentModel) throws -> Void
}
