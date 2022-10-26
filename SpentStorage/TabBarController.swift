//
//  TabBarController.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 26.10.2022.
//

import UIKit

enum TabBarItemTag: Int {
    case day
    case statistics
}

struct MainTabBarItem {
    var title: String
    var icon: UIImage?
    var tag: TabBarItemTag
}

struct Tabs {
    static var day = MainTabBarItem(
        title: "Day",
        icon: UIImage(systemName: "house"),
        tag: .day
    )
    
    static var statistics = MainTabBarItem(
        title: "Statistic",
        icon: UIImage(systemName: "chart.bar") ?? nil,
        tag: .statistics
    )
}

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .lightGray
        
        let dataViewController = ViewController()
        let statisticViewController = ViewController()

        dataViewController.tabBarItem = UITabBarItem(title: Tabs.day.title, image: Tabs.day.icon, tag: Tabs.day.tag.rawValue)
        statisticViewController.tabBarItem = UITabBarItem(title: Tabs.statistics.title, image: Tabs.statistics.icon, tag: Tabs.statistics.tag.rawValue)
        
        self.setViewControllers([
            dataViewController,
            statisticViewController
        ], animated: true)
    }
}
