//
//  BarChartCellTableViewCell.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 02.12.2022.
//

import UIKit
import Charts

class BarChartCell: UITableViewCell {
    
    static let cellId = "BarChartCellId"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(chartView)
        setupConstrains()
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            chartView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            chartView.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
            chartView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    let barChartDataSet: BarChartDataSet = {
        let dataSet = BarChartDataSet()
        dataSet.setColor(.systemGreen)
        dataSet.valueFont = UIFont.getNunitoFont(type: .regular, size: 12)
        
        return dataSet
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
        
        chart.rightAxis.enabled = false
        chart.leftAxis.spaceBottom = 0
        
        return chart
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
