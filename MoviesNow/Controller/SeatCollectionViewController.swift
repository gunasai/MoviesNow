//
//  SeatCollectionViewController.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 4/14/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SeatCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionview: UICollectionView!
    var movieID: Int = 0
    fileprivate let cellID = "SeatCell"
    fileprivate let headerID = "MovieHeader"
    
    let numbers = ["1A", "2A", "3A", "4B", "5B", "6B", "7C", "8C", "9C", "10D",  "11D", "12D"]
    
    var bookedSeats = [String]()
    var seatsAlreadybooked = [String]()
    
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
        
        let checkoutButton = UIButton(type: .system)
        checkoutButton.backgroundColor = #colorLiteral(red: 1, green: 0.4190880954, blue: 0.3932890296, alpha: 1)
        checkoutButton.setTitle("Confirm Purchase", for: .normal)
        checkoutButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        checkoutButton.layer.cornerRadius = 5
        checkoutButton.tintColor = .white
        
        self.view.addSubview(checkoutButton)
        
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        checkoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        checkoutButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        checkoutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        checkoutButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -120).isActive = true
        
        let ref = Database.database().reference()
        
        ref.child("movieDetails").observeSingleEvent(of: .value, with:
            { (snapshot) in
                if snapshot.hasChild((String(self.movieID))) {
                    print("Movie already exists")
                    ref.child("movieDetails/\(self.movieID)/seatsSelected").observeSingleEvent(of: .value, with: { (snapshot) in
                        let seatsSelected = snapshot.value as! [String]
                        print("SEATS BEFORE APPEND: \(seatsSelected)")
                        
                        DispatchQueue.main.async {
                            
                            for seat in seatsSelected {
                                self.seatsAlreadybooked.append(seat)
                            }
                            
                            self.collectionview.reloadData()
                            
                            print("Seats AFTER APPEND: \(self.seatsAlreadybooked)")
                        }
                        
                    })
                    
                }
                else {
                    _ = ref.child("movieDetails/\(self.movieID)").child("seatsSelected")
//                    seatsSelectedRef.setValue(self.bookedSeats)
                }
                
        })
        
        
    }


    
    override func viewWillDisappear(_ animated: Bool) {
        print("BOOKED SEATS: \(bookedSeats)")
        UserDefaults.standard.set(bookedSeats, forKey: "bookedSeats")
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        let checkoutViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        checkoutViewController.seatNumbers = bookedSeats
        self.navigationController?.pushViewController(checkoutViewController, animated: true)
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
        
        
        if seatsAlreadybooked.contains(seat) {
            print("SEAT ALREADY BOOKED")
            cell.isUserInteractionEnabled = false
            cell.isOpaque = true
            cell.backgroundColor = UIColor(white: 0.9, alpha: 1)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor(red: 0.9882, green: 0.8706, blue: 0, alpha: 1.0)
        bookedSeats.append(numbers[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor(red: 0.298, green: 0.8196, blue: 0, alpha: 1.0)
        
        bookedSeats = bookedSeats.filter() {$0 != numbers[indexPath.row]}
        
        print("SEATS SELECTED: \(bookedSeats)")
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





