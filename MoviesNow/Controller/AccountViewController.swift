//
//  AccountViewController.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 2/7/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation
import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gravatarImageView: UIImageView!
    
    override func viewDidLoad() {
        TMDBClient.getAccountDetails(completionHandler: handleAccountDetailsResponse(accountDetails:error:))
        gravatarImageView.layer.cornerRadius = gravatarImageView.frame.size.width / 2
        gravatarImageView.clipsToBounds = true
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        TMDBClient.logout {
            DispatchQueue.main.async {
                // TODO: Check if root view is initialized or not
                if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginScreen") {
                    self.show(loginVC, sender: nil)
                }
                
            }
        }
    }
    
    
    func handleAccountDetailsResponse(accountDetails: AccountDetailsRequest?, error: Error?) {
        if let accountDetails = accountDetails {
            print("AccountID: \(accountDetails.id)")
            TMDBClient.getGravatar(hash: accountDetails.avatar.gravatar.hash, completionHandler: handleImageResponse(gravatar:error:))
            DispatchQueue.main.async {
                self.nameLabel.text = "Welcome \(accountDetails.username)!"
            }
        } else {
            print("Cannot retrieve details")
        }
    }
    
    func handleImageResponse(gravatar: UIImage?, error: Error?) {
        if let gravatar = gravatar {
            DispatchQueue.main.async {
                self.gravatarImageView.image = gravatar
            }
        }
    }
    
    
}
