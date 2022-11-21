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
        title: "Statistics",
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
        tabBar.tintColor = Colors.activeTabColor
        tabBar.unselectedItemTintColor = Colors.inactiveTabColor
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBar.clipsToBounds = true
        
        let navDayViewController = NavigationController(rootViewController: DayViewController())
        let navStatisticsViewController = NavigationController(rootViewController: StatisticsViewController())

        navDayViewController.tabBarItem = UITabBarItem(
            title: Tabs.day.title,
            image: Tabs.day.icon,
            tag: Tabs.day.tag.rawValue
        )
        navStatisticsViewController.tabBarItem = UITabBarItem(
            title: Tabs.statistics.title,
            image: Tabs.statistics.icon,
            tag: Tabs.statistics.tag.rawValue
        )
        
        self.setViewControllers([
            navDayViewController,
            navStatisticsViewController
        ], animated: true)
    }
}
