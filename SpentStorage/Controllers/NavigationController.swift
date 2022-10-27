//
//  NavigationController.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 27.10.2022.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    private func setup() {
        navigationBar.isTranslucent = false
        view.backgroundColor = .white
        navigationBar.standardAppearance.titleTextAttributes = [
            .foregroundColor: UIColor().fromHexColor(hex: "#545C77"),
            .font: UIFont(name: "Helvetica", size: 17) ?? UIFont()
        ]
    }
}
