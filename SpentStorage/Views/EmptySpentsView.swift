//
//  EmptySpentsView.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 10.11.2022.
//

import UIKit

class EmptySpentsView: UIView {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "You didn't have spends"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getHelveticFont(size: 18)
        label.textColor = Colors.navigationBarTitleColor
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "hand.thumbsup"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(image)
        addSubview(label)

        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -70),
            image.heightAnchor.constraint(equalToConstant: 70),
            image.widthAnchor.constraint(equalToConstant: 70),
            
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 14),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
