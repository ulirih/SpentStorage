//
//  SpentViewCell.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 09.11.2022.
//

import Foundation
import UIKit
import LetterAvatarKit

class SpentViewCell: UITableViewCell {
    
    static let cellId = "SpentCellId"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(categoryNameLabel)
        addSubview(sumLabel)
        addSubview(avatarImage)
        
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(model: SpentModel) {
        categoryNameLabel.text = model.type.name
        sumLabel.text = model.price.toFormattedString()
        avatarImage.image = LetterAvatarMaker()
            .setCircle(true)
            .setUsername(model.type.name)
            .setSize(CGSize(width: 40, height: 40))
            .build()
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            avatarImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            
            categoryNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryNameLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 16),
            
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
    
    private let avatarImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
}
