//
//  SpentViewPresenter.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 04.11.2022.
//

import Foundation

protocol SpentViewProtocol: AnyObject {
    func presentCategories(categories: [CategoryModel]) -> Void
    func onSpentSaved() -> Void
    func showError(errorMessage: String) -> Void
}

protocol SpentViewPresenterProtocol {
    init(view: SpentViewProtocol, service: SpentServiceProtocol)
    func fetchCategories() -> Void
    func addSpent(price: Float, date: Date, type: CategoryModel) -> Void
}

class SpentViewPresenter: SpentViewPresenterProtocol {
    private weak var view: SpentViewProtocol?
    
    private let service: SpentServiceProtocol
    private let defaultError = "Something went wrong"
    
    required init(view: SpentViewProtocol, service: SpentServiceProtocol) {
        self.service = service
        self.view = view
    }
    
    func fetchCategories() {
        do {
            let result = try service.getCategories()
            view?.presentCategories(categories: result)
        } catch {
            view?.showError(errorMessage: defaultError)
        }
    }
    
    func addSpent(price: Float, date: Date, type: CategoryModel) {
        do {
            let spent = SpentModel(
                id: UUID(),
                date: date,
                price: price,
                type: type
            )
            try service.addSpent(for: spent)
            view?.onSpentSaved()
        } catch {
            view?.showError(errorMessage: defaultError)
        }
    }
}
