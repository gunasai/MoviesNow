//
//  SeatCollectionViewController.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 4/14/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import UIKit

class SeatCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionview: UICollectionView!
    fileprivate let cellID = "SeatCell"
    fileprivate let headerID = "MovieHeader"
    
    let numbers = ["1A", "2A", "3A", "4B", "5B", "6B", "7C", "8C", "9C", "10D",  "11D", "12D"]
    
    let bookedSeats = ["1A", "2A", "3A"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an instance of UICollectionViewFlowLayout since you cant
        // Initialize UICollectionView without a layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        collectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.allowsMultipleSelection = true
        collectionview.register(SeatCell.self, forCellWithReuseIdentifier: cellID)
        collectionview.register(MovieScreenHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = UIColor.white
        self.view.addSubview(collectionview)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionview.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! MovieScreenHeader
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = view.frame.height * 0.2
        return .init(width: view.frame.width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SeatCell
        cell.seatLabel.text = numbers[indexPath.item]
//        print("cell LABEL: \(numbers[indexPath.item])")
        let seat = numbers[indexPath.item]
        if bookedSeats.contains(seat) {
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .yellow
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor(white: 0.9, alpha: 1)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        let leftRightPadding = view.frame.width * 0.13
        let interSpacing = view.frame.width * 0.1
            
        let cellWidth = (view.frame.width - 2 * leftRightPadding - 2 * interSpacing) / 3
            
        return .init(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            
        let leftRightPadding = view.frame.width * 0.15
            
        return .init(top: 16, left: leftRightPadding, bottom: 16, right: leftRightPadding)
    }
    
}




