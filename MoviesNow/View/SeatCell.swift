//
//  SeatCell.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 4/14/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import UIKit

class SeatCell: UICollectionViewCell {
    
//    override var isSelected: Bool{
//        didSet{
//            if self.isSelected
//            {
//                self.backgroundColor = .yellow
//
//            }
//        }
//    }
    
    let seatLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.text = "1"
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.298, green: 0.8196, blue: 0, alpha: 1.0)
        
        let stackView = UIStackView(arrangedSubviews: [seatLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

