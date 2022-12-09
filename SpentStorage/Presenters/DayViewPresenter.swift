//
//  DayViewPresenter.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 07.11.2022.
//

import Foundation

enum DayStepType: Int {
    case nextDay = 1
    case previousDay = -1
}

protocol DayViewProtocol: AnyObject {
    func presentSpents(data: [SpentModel]) -> Void
    func presentSum(sum: Float) -> Void
    func presentDate(date: Date) -> Void
    func showError(errorMessage: String) -> Void
}

protocol DayViewPresenterProtocol {
    init(view: DayViewProtocol, service: ServiceProtocol)
    
    func fetch(on date: Date?) -> Void
    func onDayStepFetch(step: DayStepType) -> Void
}

class DayViewPresenter: DayViewPresenterProtocol {
    private weak var view: DayViewProtocol?
    
    private let service: ServiceProtocol
    private let defaultError = "Something went wrong"
    private var currentDate: Date
    
    required init(view: DayViewProtocol, service: ServiceProtocol) {
        self.view = view
        self.service = service
        currentDate = Date()
    }
    
    func fetch(on date: Date? = nil) {
        currentDate = date ?? currentDate
        
        view?.presentDate(date: currentDate)
        service.getSpents(on: currentDate) { result in
            switch result {
            case .success(let spents):
                self.view?.presentSpents(data: spents)
                self.view?.presentSum(sum: self.getSum(for: spents))
                
            case .failure:
                self.view?.showError(errorMessage: self.defaultError)
            }
        }
    }
    
    func onDayStepFetch(step: DayStepType) {
        let newDate = Calendar.current.date(byAdding: .day, value: step.rawValue , to: currentDate)
        if let newDate = newDate {
            currentDate = newDate
            fetch(on: newDate)
        }
    }
    
    private func getSum(for data: [SpentModel]) -> Float {
        return data.reduce(0) { $0 + $1.price }
    }
}
