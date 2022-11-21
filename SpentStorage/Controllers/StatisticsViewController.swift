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
    private var categoryData: [StatisticCategoryModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupViews()
        setupConstraints()
        
        presenter.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.fetchDataOfLastWeek()
    }
    
    private func setupViews() {
        view.addSubview(periodSegment)
        view.addSubview(chartView)
        view.addSubview(tableView)
        
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
            chartView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            chartView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 200),
            
            tableView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = 60
        table.register(StatisticCategoryCell.self, forCellReuseIdentifier: StatisticCategoryCell.cellId)
        
        return table
    }()
    
    let periodSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Year", "Month", "Week"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 2
        
        return segment
    }()
    
    let chartView: BarChartView = {
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
        xAxis.valueFormatter = XAxisValueFormatter()
        
        chart.rightAxis.enabled = false
        chart.leftAxis.spaceBottom = 0
        
        return chart
    }()
}

// MARK: Presenter Protocol
extension StatisticsViewController: StatisticsViewPresenterProtocol {
    
    func presentBarChart(data: [BarChartDataEntry]) {
        let barChartDataSet = BarChartDataSet(entries: data)
        barChartDataSet.setColor(.systemGreen)
        barChartDataSet.valueFont = UIFont.getNunitoFont(type: .regular, size: 12)
        
        let chartData = BarChartData(dataSet: barChartDataSet)
        chartView.data = chartData
    }
    
    func presentCategoryStatistic(data: [StatisticCategoryModel]) {
        categoryData = data
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
        cell.setupCell(model: categoryData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count
    }
}

class XAxisValueFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = value.since1970DaysToDate()
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "dd.MM"

        return formatter.string(from: date)
    }
}

