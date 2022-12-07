//
//  StatisticsViewController.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 27.10.2022.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController, ChartViewDelegate {
    
    private var presenter: StatisticsPresenterViewProtocol!
    private var statisticsData: [StatisticType] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupViews()
        setupConstraints()
        
        presenter = StatisticViewPresenter(view: self, service: SpentService())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.fetchData(for: .week)
    }
    
    private func setupViews() {
        view.addSubview(periodSegment)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavBar() {
        view.backgroundColor = .white
        title = Tabs.statistics.title
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            periodSegment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            periodSegment.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            periodSegment.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: periodSegment.bottomAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private let spentsSumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getNunitoFont(type: .bold, size: 24)
        label.textAlignment = .center
        
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = UITableView.automaticDimension
        table.isUserInteractionEnabled = true
        table.allowsSelection = false
        table.register(StatisticCategoryCell.self, forCellReuseIdentifier: StatisticCategoryCell.cellId)
        table.register(BarChartCell.self, forCellReuseIdentifier: BarChartCell.cellId)
        table.register(TotalAmountCell.self, forCellReuseIdentifier: TotalAmountCell.cellId)
        
        return table
    }()
    
    private let periodSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Year", "Month", "Week"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 2
        segment.addTarget(self, action: #selector(onChangeSegment), for: .valueChanged)
        
        return segment
    }()
    
    @objc
    private func onChangeSegment() {
        if periodSegment.selectedSegmentIndex == 0 {
            presenter.fetchData(for: .year)
        } else if periodSegment.selectedSegmentIndex == 1 {
            presenter.fetchData(for: .month)
        } else {
            presenter.fetchData(for: .week)
        }
    }
}

// MARK: View Protocol
extension StatisticsViewController: StatisticsViewProtocol {
    func didLoadStatistic(statistic: [StatisticType]) {
        statisticsData = statistic
        tableView.reloadData()
    }
    
    func showError(errorMessage: String) {
        showAlertError(message: errorMessage)
    }
}

// MARK: TableView Delegates
extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch statisticsData[indexPath.section] {
        case .amount(let value):
            let cell = tableView.dequeueReusableCell(withIdentifier: TotalAmountCell.cellId, for: indexPath) as! TotalAmountCell
            cell.amountLabel.text = value.toFormattedAmount()
            return cell
            
        case .categories(let items):
            let cell = tableView.dequeueReusableCell(withIdentifier: StatisticCategoryCell.cellId, for: indexPath) as! StatisticCategoryCell
            cell.setupCell(model: items[indexPath.row])
            return cell
            
        case .chart(let data):
            let cell = tableView.dequeueReusableCell(withIdentifier: BarChartCell.cellId, for: indexPath) as! BarChartCell
            cell.barChartDataSet.replaceEntries(data)
            cell.barChartDataSet.drawValuesEnabled = presenter.selectedPeriod == .week
            
            let chartData = BarChartData(dataSet: cell.barChartDataSet)
            cell.chartView.xAxis.valueFormatter = XAxisValueFormatter(periodType: presenter.selectedPeriod)
            cell.chartView.data = chartData
            cell.heightAnchor.constraint(equalToConstant: 200).isActive = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch statisticsData[section] {
        case .amount: return 1
        case .chart: return 1
        case .categories(let items): return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: need refator
        switch statisticsData[indexPath.section] {
        case .categories: return StatisticCategoryCell.cellHeight
        case .chart: return BarChartCell.cellHeight
        case .amount: return TotalAmountCell.cellHeight
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        statisticsData.count
    }
}

class XAxisValueFormatter: AxisValueFormatter {
    private let periodType: StatisticPeriodType
    
    init(periodType: StatisticPeriodType) {
        self.periodType = periodType
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let isYearPeriod = periodType == .year
        
        let date = isYearPeriod
            ? Calendar.current.date(from: DateComponents(month: Int(value))) ?? Date()
            : value.since1970DaysToDate()
        
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = isYearPeriod ? "MMM" : "dd.MM"

        return formatter.string(from: date)
    }
}

