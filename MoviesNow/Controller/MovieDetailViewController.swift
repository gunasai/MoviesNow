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
    @IBOutlet weak var toolbar: UIToolbar!
    
    var backdropPath: String?
    var movieName: String?
    var movieSynopsis: String?
    var movieID: Int?
    
    @IBOutlet weak var watchListBarButton: UIBarButtonItem!
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    
    var isWatchlist: Bool {
        return MovieModel.watchlist.contains(movieID!)
    }
    
    var isFavorite: Bool {
        return MovieModel.favorites.contains(movieID!)
    }
    
    
    @IBAction func bookTickets(_ sender: Any) {
        let seatSelectionController = self.storyboard?.instantiateViewController(withIdentifier: "SeatCollectionViewController") as! SeatCollectionViewController
        self.navigationController?.pushViewController(seatSelectionController, animated: true)
    }
    
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
    
    @IBAction func watchListButtonTapped(_ sender: UIBarButtonItem) {
        TMDBClient.markWatchlist(movieID: movieID!, watchlist: !isWatchlist, completion: handleWatchlistResponse(success:error:))
        print("ID: \(movieID!)")
        print("WATCHLIST: \(MovieModel.watchlist)")
    }
    
    func handleWatchlistResponse(success: Bool, error: Error?) {
        if success {
            if isWatchlist {
                print("before delete: \(MovieModel.watchlist.count)")
                MovieModel.watchlist = MovieModel.watchlist.filter() {$0 != movieID!}
                print("after delete: \(MovieModel.watchlist.count)")
            } else {
                MovieModel.watchlist.append(movieID!)
            }
            toggleBarButton(watchListBarButton, enabled: isWatchlist)
        }
    }
    
    func handleFavoriteResponse(success: Bool, error: Error?) {
        if success {
            if isFavorite {
                print("before delete: \(MovieModel.favorites.count)")
                MovieModel.watchlist = MovieModel.favorites.filter() {$0 != movieID!}
                print("after delete: \(MovieModel.favorites.count)")
            } else {
                MovieModel.favorites.append(movieID!)
            }
            toggleBarButton(favoriteBarButton, enabled: isFavorite)
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        TMDBClient.markFavorite(movieId: movieID!, favorite: !isFavorite, completion: handleFavoriteResponse(success:error:))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviePoster.clipsToBounds = true
        moviePoster.layer.masksToBounds = true
        moviePoster.layer.cornerRadius = 20
        bookingButton.layer.cornerRadius = 5
        toolbar.clipsToBounds = true
        
        
        // Checking if users can book tickets.
        let movieSingleton = MovieSingleton.shared.getMovies()
        if !movieSingleton.contains(movieName ?? "") {
            bookingButton.isHidden = true
        }
        
        if MovieModel.watchlist.contains(movieID!) {
            watchListBarButton.tintColor = #colorLiteral(red: 1, green: 0.4190880954, blue: 0.3932890296, alpha: 1)
        } else {
            watchListBarButton.tintColor = UIColor.darkGray
        }
        
        if MovieModel.favorites.contains(movieID!) {
            favoriteBarButton.tintColor = #colorLiteral(red: 1, green: 0.4190880954, blue: 0.3932890296, alpha: 1)
        } else {
            favoriteBarButton.tintColor = UIColor.darkGray
        }
    }
    
    func toggleBarButton(_ button: UIBarButtonItem, enabled: Bool) {
        if enabled {
            button.tintColor = #colorLiteral(red: 1, green: 0.4190880954, blue: 0.3932890296, alpha: 1)
        } else {
            button.tintColor = UIColor.darkGray
        }
    }

}
