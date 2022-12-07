//
//  TotalAmountCell.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 06.12.2022.
//

import UIKit

class TotalAmountCell: UITableViewCell {
    static let cellId = "TotalAmountCellId"
    static let cellHeight: CGFloat = 100

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(amountLabel)
        setupLayout()
    }
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getNunitoFont(type: .bold, size: 24)
        label.textAlignment = .center
        return label
    }()
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            amountLabel.leftAnchor.constraint(equalTo: leftAnchor),
            amountLabel.rightAnchor.constraint(equalTo: rightAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
