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
    func presentCategoryStatistic(data: [StatisticCategoryModel]) -> Void
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
        var balance: Float = 0
        
        do {
            let spents = try service.getSpents(startDate: startDate, endDate: endDate)
            balance = spents.reduce(0, { $0 + $1.price })
            
            let grouped = Dictionary(grouping: spents, by: { Calendar.current.startOfDay(for: $0.date) })
            var chartData: [BarChartDataEntry] = []
            grouped.forEach { item in
                let xValue = item.key.timeIntervalSince1970.since1970ToDays()
                let yValue = item.value.reduce(0, { $0 + Double($1.price) })
                
                chartData.append(BarChartDataEntry(x: xValue, y: yValue))
            }
            delegate?.presentBarChart(data: chartData.sorted(by: { $0.x < $1.x }))
            
            let category = Dictionary(grouping: spents, by: { $0.type.id })
            var categoryData: [StatisticCategoryModel] = []
            category.forEach { item in
                let amount = item.value.reduce(0, { $0 + $1.price })
                let percent = amount * 100 / balance
                categoryData.append(
                    StatisticCategoryModel(name: item.value[0].type.name, amount: amount, percent: percent))
            }
            delegate?.presentCategoryStatistic(data: categoryData.sorted(by: { $0.amount > $1.amount }))
            
        } catch let error {
            delegate?.showError(errorMessage: error.localizedDescription)
        }
    }
}
