//
//  SpentViewPresenter.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 04.11.2022.
//

import Foundation

protocol SpentViewPresenterDelegate {
    func presentCategories(categories: [CategoryModel]) -> Void
    func onSpentSaved() -> Void
    func showError(error: Error) -> Void
}

class SpentViewPresenter {
    
    public var delegate: SpentViewPresenterDelegate?
    private let service: SpentServiceProtocol
    
    init(service: SpentServiceProtocol) {
        self.service = service
    }
    
    func fetchCategories() {
        let result = service.getCategories()
        delegate?.presentCategories(categories: result)
    }
    
    func addSpent(price: Float, date: Date, type: CategoryModel) {
        let spent = SpentModel(
            id: UUID(),
            date: date,
            price: price,
            type: type
        )
        service.addSpent(spent)
        delegate?.onSpentSaved()
    }
}
