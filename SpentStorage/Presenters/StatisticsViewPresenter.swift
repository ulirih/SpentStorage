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
        var start: Date
        var end: Date?
        let calendar = Calendar.current
        
        switch self {
        case .year:
            let year = calendar.component(.year, from: Date())
            start = calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
            end = calendar.date(from: DateComponents(year: year, month: 12, day: 31))
        case .month:
            start = calendar.date(byAdding: .month, value: -1, to: Date())!
        case .week:
            start = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())!
        }
        
        return (start, end ?? Date())
    }
}

protocol StatisticsViewPresenterProtocol: AnyObject {
    func presentBarChart(data: [BarChartDataEntry]) -> Void
    func presentCategoryStatistic(data: [StatisticCategoryModel]) -> Void
    func presentSpentSum(total: Float) -> Void
    func showError(errorMessage: String) -> Void
}

class StatisticViewPresenter {
    weak var delegate: StatisticsViewPresenterProtocol?
    var selectedPeriod: ChartPeriodType = .week
    
    private let service: SpentServiceProtocol
    
    init(service: SpentServiceProtocol) {
        self.service = service
    }
    
    func fetchData(for periodType: ChartPeriodType) {
        selectedPeriod = periodType
        let (startDate, endDate) = periodType.getDetesInterval()
        
        do {
            let spents = try service.getSpents(startDate: startDate, endDate: endDate)
            
            delegate?.presentSpentSum(total: spents.reduce(0, { $0 + $1.price }))
            delegate?.presentBarChart(data: groupByPeriod(for: spents))
            delegate?.presentCategoryStatistic(data: groupByCategory(for: spents))
            
        } catch let error {
            delegate?.showError(errorMessage: error.localizedDescription)
        }
    }
    
    private func groupByPeriod(for spents: [SpentModel]) -> [BarChartDataEntry] {
        var chartData: [BarChartDataEntry] = []
        
        switch selectedPeriod {
        case .year:
            // grouping by months
            let groups = Dictionary(grouping: spents, by: { Calendar.current.dateComponents([.month], from: $0.date).month })
            for month in 1...12 {
                let values = groups[month]
                let yValue = values != nil ? values!.reduce(0, { $0 + Double($1.price) }) : 0
                chartData.append(BarChartDataEntry(x: Double(month), y: yValue))
            }
        case .month, .week:
            // grouping by days
            let groups = Dictionary(grouping: spents, by: { Calendar.current.startOfDay(for: $0.date) })
            let (startedDate, endDate) = selectedPeriod.getDetesInterval()
            let dates = dateRange(starDate: startedDate, endDate: endDate)
            
            dates.forEach { date in
                if let sameDay = groups[Calendar.current.startOfDay(for: date)] {
                    let xValue = date.timeIntervalSince1970.since1970ToDays()
                    let yValue = sameDay.reduce(0, { $0 + Double($1.price) })
                    
                    chartData.append(BarChartDataEntry(x: xValue, y: yValue))
                } else {
                    chartData.append(BarChartDataEntry(x: date.timeIntervalSince1970.since1970ToDays(), y: 0))
                }
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
