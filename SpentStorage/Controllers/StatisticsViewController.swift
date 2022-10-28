//
//  StatisticsViewController.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 27.10.2022.
//

import UIKit

class StatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
    }
    
    private func setupNavBar() {
        view.backgroundColor = Colors.backgroundColor
        title = Tabs.statistics.title
    }
}
