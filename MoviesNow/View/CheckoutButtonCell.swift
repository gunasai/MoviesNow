//
//  CheckoutButtonCell.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 4/23/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import UIKit

class CheckoutButtonCell: UICollectionViewCell {
    
    let checkoutCellLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Confirm Purchase"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 1, green: 0.4190880954, blue: 0.3932890296, alpha: 1)
        
        let stackView = UIStackView(arrangedSubviews: [checkoutCellLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        checkoutCellLabel.centerInSuperview(size: .init(width: 200, height: 200))
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
