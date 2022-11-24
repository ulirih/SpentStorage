//
//  StatisticsViewPresenter.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 14.11.2022.
//

import Foundation
import Charts

enum ChartPeriodType {
    case year
    case month
    case week
    
    func getDetesInterval() -> (startDate: Date, endDate: Date) {
        var startDate: Date
        switch self {
        case .year:
            startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        case .month:
            startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        case .week:
            startDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        }
        
        return (startDate, Date())
    }
}

protocol StatisticsViewPresenterProtocol: AnyObject {
    func presentBarChart(data: [BarChartDataEntry]) -> Void
    func presentCategoryStatistic(data: [StatisticCategoryModel]) -> Void
    func showError(errorMessage: String) -> Void
}

class StatisticViewPresenter {
    weak var delegate: StatisticsViewPresenterProtocol?
    
    private let service: SpentServiceProtocol
    //TODO: move to delegate
    var selectedPeriod: ChartPeriodType = .week
    
    init(service: SpentServiceProtocol) {
        self.service = service
    }
    
    func fetchData(for periodType: ChartPeriodType) {
        selectedPeriod = periodType
        let (startDate, endDate) = periodType.getDetesInterval()
        
        do {
            let spents = try service.getSpents(startDate: startDate, endDate: endDate)
            
            delegate?.presentBarChart(data: groupByPeriod(for: spents))
            delegate?.presentCategoryStatistic(data: groupByCategory(for: spents))
            
        } catch let error {
            delegate?.showError(errorMessage: error.localizedDescription)
        }
    }
    
    private func groupByPeriod(for spents: [SpentModel]) -> [BarChartDataEntry] {
        let groups = Dictionary(grouping: spents, by: { Calendar.current.startOfDay(for: $0.date) })
        
        // get all dates in period
        let (startedDate, endDate) = selectedPeriod.getDetesInterval()
        let dates = dateRange(starDate: startedDate, endDate: endDate)
        
        var chartData: [BarChartDataEntry] = []
        dates.forEach { date in
            if let sameDay = groups[Calendar.current.startOfDay(for: date)] {
                let xValue = date.timeIntervalSince1970.since1970ToDays()
                let yValue = sameDay.reduce(0, { $0 + Double($1.price) })
                
                chartData.append(BarChartDataEntry(x: xValue, y: yValue))
            } else {
                chartData.append(BarChartDataEntry(x: date.timeIntervalSince1970.since1970ToDays(), y: 0))
            }
        }
        
        return chartData.sorted(by: { $0.x < $1.x })
    }
    
    private func groupByCategory(for spents: [SpentModel]) -> [StatisticCategoryModel] {
        let balance = spents.reduce(0, { $0 + $1.price })
        let groups = Dictionary(grouping: spents, by: { $0.type.id })
        var categoryData: [StatisticCategoryModel] = []
        groups.forEach { item in
            let amount = item.value.reduce(0, { $0 + $1.price })
            let percent = amount * 100 / balance
            categoryData.append(
                StatisticCategoryModel(name: item.value[0].type.name, amount: amount, percent: percent)
            )
        }
        
        return categoryData.sorted(by: { $0.amount > $1.amount })
    }
    
    private func dateRange(starDate: Date, endDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = starDate
        while !Calendar.current.isDate(date, equalTo: endDate, toGranularity: .day) {
            let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            dates.append(newDate)
            date = newDate
        }
        
        return dates
    }
}
