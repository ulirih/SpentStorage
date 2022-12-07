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
    init(view: DayViewProtocol, service: SpentServiceProtocol)
    
    func fetch(on date: Date?) -> Void
    func onDayStepFetch(step: DayStepType) -> Void
}

class DayViewPresenter: DayViewPresenterProtocol {
    private weak var view: DayViewProtocol?
    
    private let service: SpentServiceProtocol
    private let defaultError = "Something went wrong"
    private var currentDate: Date
    
    required init(view: DayViewProtocol, service: SpentServiceProtocol) {
        self.view = view
        self.service = service
        currentDate = Date()
    }
    
    func fetch(on date: Date? = nil) {
        currentDate = date ?? currentDate
        do {
            let result = try service.getSpents(on: currentDate)
            
            view?.presentSpents(data: result)
            view?.presentSum(sum: getSum(for: result))
            view?.presentDate(date: currentDate)
        } catch {
            view?.showError(errorMessage: defaultError)
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
