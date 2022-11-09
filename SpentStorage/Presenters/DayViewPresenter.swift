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

enum DayStepType: Int {
    case nextDay = 1
    case previousDay = -1
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
    
    func fetch(on date: Date?) {
        currentDate = date ?? currentDate
        do {
            let result = try service.getSpents(on: currentDate)
            
            delegate?.presentSpents(data: result)
            delegate?.presentSum(sum: getSum(for: result))
            delegate?.presentDate(date: currentDate)
        } catch {
            delegate?.showError(errorMessage: defaultError)
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
