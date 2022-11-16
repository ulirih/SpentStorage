//
//  StatisticsViewPresenter.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 14.11.2022.
//

import Foundation
import Charts

protocol StatisticsViewPresenterProtocol: AnyObject {
    func presentBarChart(data: [BarChartDataEntry]) -> Void
    func showError(errorMessage: String) -> Void
}

class StatisticViewPresenter {
    weak var delegate: StatisticsViewPresenterProtocol?
    private let service: SpentServiceProtocol
    
    init(service: SpentServiceProtocol) {
        self.service = service
    }
    
    func fetchDataOfLastWeek() {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: endDate) ?? Date()
        
        do {
            let spents = try service.getSpents(startDate: startDate, endDate: endDate)
            let grouped = Dictionary(grouping: spents, by: { Calendar.current.startOfDay(for: $0.date) })
            
            var chartData: [BarChartDataEntry] = []
            grouped.forEach { item in
                let xValue = item.key.timeIntervalSince1970
                let yValue = item.value.reduce(0, { $0 + Double($1.price) })
                
                chartData.append(BarChartDataEntry(x: xValue, y: yValue))
            }
            
            delegate?.presentBarChart(data: chartData)
            
        } catch let error {
            delegate?.showError(errorMessage: error.localizedDescription)
        }
    }
}
