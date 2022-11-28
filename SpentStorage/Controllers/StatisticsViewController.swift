//
//  StatisticsViewController.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 27.10.2022.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController, ChartViewDelegate {
    
    private let presenter = StatisticViewPresenter(service: SpentService())
    private var categoriesData: [StatisticCategoryModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupViews()
        setupConstraints()
        
        presenter.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.fetchData(for: .week)
    }
    
    private func setupViews() {
        view.addSubview(periodSegment)
        view.addSubview(chartView)
        view.addSubview(tableView)
        view.addSubview(spentsSumLabel)
        
        chartView.delegate = self
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
            
            chartView.topAnchor.constraint(equalTo: periodSegment.bottomAnchor, constant: 8),
            chartView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            chartView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 200),
            
            spentsSumLabel.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 16),
            spentsSumLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            spentsSumLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: spentsSumLabel.bottomAnchor, constant: 16),
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
        table.rowHeight = 60
        table.register(StatisticCategoryCell.self, forCellReuseIdentifier: StatisticCategoryCell.cellId)
        
        return table
    }()
    
    private let periodSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Year", "Month", "Week"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 2
        segment.addTarget(self, action: #selector(onChangeSegment), for: .valueChanged)
        
        return segment
    }()
    
    private var barChartDataSet: BarChartDataSet = {
        let dataSet = BarChartDataSet()
        dataSet.setColor(.systemGreen)
        dataSet.valueFont = UIFont.getNunitoFont(type: .regular, size: 12)
        
        return dataSet
    }()
    
    private let chartView: BarChartView = {
        let chart = BarChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        chart.highlightPerTapEnabled = true
        chart.highlightFullBarEnabled = true
        chart.highlightPerDragEnabled = false
        
        chart.pinchZoomEnabled = false
        chart.setScaleEnabled(false)
        chart.doubleTapToZoomEnabled = false
        
        chart.drawBarShadowEnabled = false
        chart.drawGridBackgroundEnabled = false
        chart.drawBordersEnabled = false
        
        chart.legend.enabled = false
        chart.animate(yAxisDuration: 1.5 , easingOption: .easeOutBounce)
        
        let xAxis = chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1
        
        chart.rightAxis.enabled = false
        chart.leftAxis.spaceBottom = 0
        
        return chart
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

// MARK: Presenter Protocol
extension StatisticsViewController: StatisticsViewPresenterProtocol {
    func presentSpentSum(total: Float) {
        spentsSumLabel.text = total.toFormattedAmount()
    }
    
    func presentBarChart(data: [BarChartDataEntry]) {
        barChartDataSet.replaceEntries(data)
        barChartDataSet.drawValuesEnabled = presenter.selectedPeriod == .week
        
        let chartData = BarChartData(dataSet: barChartDataSet)
        chartView.xAxis.valueFormatter = XAxisValueFormatter(periodType: presenter.selectedPeriod)
        chartView.data = chartData
    }
    
    func presentCategoryStatistic(data: [StatisticCategoryModel]) {
        categoriesData = data
        tableView.reloadData()
    }
    
    func showError(errorMessage: String) {
        showAlertError(message: errorMessage)
    }
}

// MARK: TableView Delegates
extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatisticCategoryCell.cellId, for: indexPath) as! StatisticCategoryCell
        cell.setupCell(model: categoriesData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesData.count
    }
}

class XAxisValueFormatter: AxisValueFormatter {
    private let periodType: ChartPeriodType
    
    init(periodType: ChartPeriodType) {
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

