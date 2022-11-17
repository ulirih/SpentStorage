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
        view.addSubview(chartView)
        
        chartView.delegate = self
    }
    
    private func setupNavBar() {
        view.backgroundColor = Colors.backgroundColor
        title = Tabs.statistics.title
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chartView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            chartView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
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
        chart.legend.textColor = .red
        
        return chart
    }()
}

extension StatisticsViewController: StatisticsViewPresenterProtocol {
    
    func presentBarChart(data: [BarChartDataEntry]) {
        let barChartDataSet = BarChartDataSet(entries: data)
        barChartDataSet.setColor(.systemGreen)
        barChartDataSet.valueFont = UIFont.getHelveticFont(size: 12)
        
        let chartData = BarChartData(dataSet: barChartDataSet)
        
        chartView.data = chartData
    }
    
    func showError(errorMessage: String) {
        showAlertError(message: errorMessage)
    }
}

class XAxisValueFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value * 60 * 60 * 24)
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "dd.MM"

        return formatter.string(from: date)
    }
}

