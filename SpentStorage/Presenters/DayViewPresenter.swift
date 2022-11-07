//
//  DayViewPresenter.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 07.11.2022.
//

import Foundation

protocol DayViewPresenterDelegate: AnyObject {
    func presentSpents(data: [SpentModel]) -> Void
    func presentSum(sum: Float) -> Void
    func presentDate(date: Date) -> Void
    func showError(errorMessage: String) -> Void
}

class DayViewPresenter {
    weak var delegate: DayViewPresenterDelegate?
    
    private let service: SpentServiceProtocol
    private let defaultError = "Something went wrong"
    private var currentDate: Date
    
    init(service: SpentServiceProtocol) {
        self.service = service
        currentDate = Date()
    }
    
    func fetch(on date: Date) {
        currentDate = date
        do {
            let result = try service.getSpents(on: date)
            
            delegate?.presentSpents(data: result)
            delegate?.presentSum(sum: getSum(for: result))
        } catch {
            delegate?.showError(errorMessage: defaultError)
        }
    }
    
    private func getSum(for data: [SpentModel]) -> Float {
        return data.reduce(0) { $0 + $1.price }
    }
}
