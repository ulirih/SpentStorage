//
//  StatisticsViewController.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 27.10.2022.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController {
    
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
        view.addSubview(chart)
    }
    
    private func setupNavBar() {
        view.backgroundColor = Colors.backgroundColor
        title = Tabs.statistics.title
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chart.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            chart.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            chart.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    let chart: BarChartView = {
        let chart = BarChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        return chart
    }()
}

extension StatisticsViewController: StatisticsViewPresenterProtocol {
    
    func presentBarChart(data: [BarChartDataEntry]) {
        let barChartDataSet = BarChartDataSet(entries: data)
//        barChartDataSet.setColor(.blue)
//        barChartDataSet.highlightColor = .red
//        barChartDataSet.highlightAlpha = 1
        
        let chartData = BarChartData(dataSet: barChartDataSet)
        chartData.setDrawValues(true)
        chartData.setValueTextColor(.blue)
        chart.data = chartData
    }
    
    func showError(errorMessage: String) {
        showAlertError(message: errorMessage)
    }
}

