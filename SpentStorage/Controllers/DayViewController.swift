//
//  ViewController.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 26.10.2022.
//

import UIKit

class DayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
    }
    
    private func setupNavBar() {
        view.backgroundColor = UIColor().fromHexColor(hex: "#F8F9F9")
        title = Tabs.day.title
    }
}

