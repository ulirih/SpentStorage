//
//  SpentViewPresenter.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 04.11.2022.
//

import Foundation

protocol SpentViewPresenterDelegate: AnyObject {
    func presentCategories(categories: [CategoryModel]) -> Void
    func onSpentSaved() -> Void
    func showError(errorMessage: String) -> Void
}

class SpentViewPresenter {
    weak var delegate: SpentViewPresenterDelegate?
    
    private let service: SpentServiceProtocol
    private let defaultError = "Something went wrong"
    
    init(service: SpentServiceProtocol) {
        self.service = service
    }
    
    func fetchCategories() {
        do {
            let result = try service.getCategories()
            delegate?.presentCategories(categories: result)
        } catch {
            delegate?.showError(errorMessage: defaultError)
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
            try service.addSpent(spent)
            delegate?.onSpentSaved()
        } catch {
            delegate?.showError(errorMessage: defaultError)
        }
    }
}
