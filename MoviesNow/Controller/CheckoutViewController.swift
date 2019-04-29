//
//  CheckoutViewController.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 4/29/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    private enum Section: Int {
        case seats = 0
        case total
        
        static func cellIdentifier(for section: Section) -> String {
            switch section {
            case .seats:
                return "SeatTableViewCell"
            case .total:
                return "CheckoutTotalTableViewCell"
            }
        }
    }
    
    var movieID: Int = 0
    var seatNumbers: [String] = []

    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Checkout"

        // Do any additional setup after loading the view.
        movieID = UserDefaults.standard.object(forKey: "MovieID") as! Int
        
        continueButton.layer.cornerRadius = 5
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension CheckoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.seats.rawValue {
            return seatNumbers.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Section.seats.rawValue {
            return "Seats Selected"
        } else {
            return "Amount"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Section not found")
        }
        let identifier = Section.cellIdentifier(for: section)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        switch cell {
        case let cell as SeatTableViewCell:
            let seat = seatNumbers[indexPath.row]
            cell.seatLabel.text = seat
            cell.priceLabel.text = "$10"
        case let cell as CheckoutTotalTableViewCell:
            let total = String(seatNumbers.count * 10)
            cell.totalLabel.text = "$\(total)"
        default:
            fatalError("Cell does not match the correct type")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == Section.seats.rawValue {
            return false
        } else {
            return false
        }
    }
    
}


extension CheckoutViewController {
    func removeSeat(_ seat: String) -> Bool {
        guard let index = seatNumbers.firstIndex(of: seat) else {
            return false
        }
        seatNumbers.remove(at: index)
        return true
    }
}
