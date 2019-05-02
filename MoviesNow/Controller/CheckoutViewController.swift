//
//  CheckoutViewController.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 4/29/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import UIKit
import Stripe
import FirebaseDatabase

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
    
    var accountID: Int = 0
    
    var movieID: Int = 0
    var seatNumbers: [String] = []

    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Checkout"

        // Do any additional setup after loading the view.
        movieID = UserDefaults.standard.object(forKey: "MovieID") as! Int
        
        continueButton.layer.cornerRadius = 5
        
        accountID = UserDefaults.standard.object(forKey: "AccountID") as! Int
    }
    
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard seatNumbers.count > 0 else {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Your cart is empty",
                                                    preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(alertAction)
            present(alertController, animated: true)
            return
        }
        
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        navigationController?.pushViewController(addCardViewController, animated: true)
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
            let total = NumberFormat.format(value: seatNumbers.count * 10)
            
            cell.totalLabel.text = total
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

extension CheckoutViewController: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        let total = (seatNumbers.count * 10) * 100
        StripeClient.shared.completeCharge(with: token, amount: total) { result in
            switch result {
            // 1
            case .success:
                completion(nil)
                
                // MARK: Storing data in Firebase
                let ref = Database.database().reference()
                
                ref.child("movieDetails").observeSingleEvent(of: .value, with:
                    { (snapshot) in
                    if snapshot.hasChild((String(self.movieID))) {
                        print("Movie already exists")
                        ref.child("movieDetails/\(self.movieID)/seatsSelected").observeSingleEvent(of: .value, with: { (snapshot) in
                            var seatsSelected = snapshot.value as! [String]
                            print("SEATS BEFORE APPEND: \(seatsSelected)")

                            for seat in self.seatNumbers {
                                seatsSelected.append(seat)
                            }

                            print("Seats AFTER APPEND: \(seatsSelected)")


                            let updates = ["movieDetails/\(self.movieID)/seatsSelected": seatsSelected]
                            ref.updateChildValues(updates)
                        })
                        
                    }
                    else {
                        let seatsSelectedRef = ref.child("movieDetails/\(self.movieID)").child("seatsSelected")
                        seatsSelectedRef.setValue(self.seatNumbers)
                    }
                    
                })
                
                ref.child("userDetails").observeSingleEvent(of: .value, with:
                    { (snapshot) in
                        if snapshot.hasChild((String(self.accountID))) {
                            print("User already exists")
                            ref.child("userDetails/\(self.accountID)/bookedSeats").observeSingleEvent(of: .value, with: { (snapshot) in
                                let updates = ["userDetails/\(self.accountID)/\(self.movieID)/bookedSeats": self.seatNumbers]
                                ref.updateChildValues(updates)
                            })
                                
                            
                        }
                        else {
                            let userRef = ref.child("userDetails/\(self.accountID)/\(self.movieID)").child("bookedSeats")
                            userRef.setValue(self.seatNumbers)
                        }
                        
                })
                
                
//
                
                
                
                
//                let updates = []
//
//                ref.child("movieDetails").setValue(["movieID": self.movieID, "seatsSelected": self.seatNumbers])
                
                
                let alertController = UIAlertController(title: "Congrats",
                                                        message: "Your payment was successful!",
                                                        preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popToRootViewController(animated: true)
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            // 2
            case .failure(let error):
                print(error)
                completion(error)
            }
        }
    }
}
