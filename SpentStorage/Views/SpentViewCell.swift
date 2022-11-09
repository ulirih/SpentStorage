//
//  SpentViewCell.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 09.11.2022.
//

import Foundation
import UIKit

class SpentViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(categoryNameLabel)
        addSubview(sumLabel)
        
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(model: SpentModel) {
        categoryNameLabel.text = model.type.name
        sumLabel.text = model.price.toFormattedString()
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            categoryNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            
            sumLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            sumLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }
    
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getHelveticFont()
        label.textColor = Colors.navigationBarTitleColor
        return label
    }()
    
    private let sumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getHelveticFont(size: 18)
        return label
    }()
}
