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
        view.backgroundColor = Colors.backgroundColor
        title = Tabs.day.title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(onPressNavRightItem)
        )
    }
    
    @objc
    private func onPressNavRightItem() {
        let spentVC = SpentViewController()
        
        let nav = UINavigationController(rootViewController: spentVC)
        nav.modalPresentationStyle = .pageSheet
        
        present(nav, animated: true, completion: nil)
    }
}

