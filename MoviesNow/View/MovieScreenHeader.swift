//
//  MovieScreenHeader.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 4/14/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import UIKit

class MovieScreenHeader: UICollectionReusableView {
    let movieScreenLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Movie Screen"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let stackView = UIStackView(arrangedSubviews: [movieScreenLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
