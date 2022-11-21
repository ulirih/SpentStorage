//
//  StatisticCategoryCell.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 21.11.2022.
//

import Foundation
import UIKit
import LetterAvatarKit

class StatisticCategoryCell: UITableViewCell {
    
    static let cellId = "CategoryCellId"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(categoryNameLabel)
        addSubview(percentLabel)
        addSubview(avatarImage)
        addSubview(sumLabel)
        
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(model: StatisticCategoryModel) {
        categoryNameLabel.text = model.name
        percentLabel.text = model.percent.toFormattedPercent()
        sumLabel.text = model.amount.toFormattedAmount()
        avatarImage.image = LetterAvatarMaker()
            .setCircle(true)
            .setUsername(model.name)
            .setSize(CGSize(width: 40, height: 40))
            .build()
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            avatarImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            
            sumLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            sumLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 16),
            
            categoryNameLabel.topAnchor.constraint(equalTo: sumLabel.bottomAnchor, constant: 4),
            categoryNameLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 16),
            
            percentLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            percentLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }
    
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getHelveticFont(size: 14)
        label.textColor = Colors.navigationBarTitleColor
        return label
    }()
    
    private let sumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getHelveticFont(size: 18)
        label.textColor = Colors.navigationBarTitleColor
        return label
    }()
    
    private let percentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getHelveticFont(size: 18)
        return label
    }()
    
    private let avatarImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
}
