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
    init(view: SpentViewProtocol, service: ServiceProtocol)
    
    func fetchCategories() -> Void
    func addSpent(price: Float, date: Date, type: CategoryModel) -> Void
}

class SpentViewPresenter: SpentViewPresenterProtocol {
    private weak var view: SpentViewProtocol?
    
    private let service: ServiceProtocol!
    private let defaultError = "Something went wrong"
    
    required init(view: SpentViewProtocol, service: ServiceProtocol) {
        self.service = service
        self.view = view
    }
    
    func fetchCategories() {
        service.getCategories { result in
            switch result {
            case .success(let items):
                self.view?.presentCategories(categories: items)
            case .failure:
                self.view?.showError(errorMessage: self.defaultError)
            }
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
