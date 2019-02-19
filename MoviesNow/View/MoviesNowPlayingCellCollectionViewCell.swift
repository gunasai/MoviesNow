//
//  MoviesNowPlayingCellCollectionViewCell.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 2/13/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialCards

class MoviesNowPlayingCellCollectionViewCell: MDCCardCollectionCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
}
