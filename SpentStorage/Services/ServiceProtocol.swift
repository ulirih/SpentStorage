//
//  ServiceProtocol.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 07.12.2022.
//

import Foundation

protocol ServiceProtocol: AnyObject {
    func getCategories(completion: @escaping ([CategoryModel]) -> Void) throws -> Void
    func getSpents(on date: Date, completion: @escaping ([SpentModel]) -> Void) throws -> Void
    func getSpents(startDate: Date, endDate: Date, completion: @escaping ([SpentModel]) -> Void) throws -> Void
    func addCategory(for category: CategoryModel) throws -> Void
    func addSpent(for spent: SpentModel) throws -> Void
}
