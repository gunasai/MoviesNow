//
//  MovieDetailViewController.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 4/1/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    @IBOutlet weak var bookingButton: UIButton!
    
    var backdropPath: String?
    var movieName: String?
    var movieSynopsis: String?
    
    // setting the image and hiding the tab bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TMDBClient.getPoster(poster: backdropPath!) { (poster, error) in
            if let poster = poster {
                DispatchQueue.main.async {
                    self.moviePoster.image = poster
                }
            }
        }
        movieTitle.text = movieName
        if let movieSynopsis = movieSynopsis {
            movieDescription.text = movieSynopsis
        }
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.view.backgroundColor = UIColor.white
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviePoster.clipsToBounds = true
        moviePoster.layer.masksToBounds = true
        moviePoster.layer.cornerRadius = CGFloat(10)
        bookingButton.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
