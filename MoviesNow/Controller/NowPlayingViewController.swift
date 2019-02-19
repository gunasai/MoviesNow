//
//  NowPlayingCollectionViewController.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 2/9/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialCards

class NowPlayingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var movies: [Result] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    var moviesNowPlaying = ["End Game", "Dark Knight", "Spider Man"]
    let moviePosters = ["e1mjopzAS2KNsvpbpahQ1a6SkSn", "e1mjopzAS2KNsvpbpahQ1a6SkSn", "e1mjopzAS2KNsvpbpahQ1a6SkSn"]
    
    let movieDescription = ["Awesome", "Legendary", "Boooo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TMDBClient.getMoviesNowPlaying { (moviesNow, error) in
            if moviesNow?.results != nil {
                DispatchQueue.main.async {
                    self.movies = (moviesNow?.results)!
                    self.collectionView.reloadData()
                }
                
            } else {
                print("No movies playing")
            }
        }
        
        setUpNavBar()
    }
    
    func setUpNavBar() {
        navigationController?.navigationBar.topItem?.title = "Now Playing"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if movies.count > 0 {
            return movies.count - 15
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MoviesNowPlayingCellCollectionViewCell
        
        
        cell.cornerRadius = 8
        cell.setBorderWidth(0.1, for: .normal)
        cell.setShadowElevation(ShadowElevation(18.0), for: .selected)
        cell.setShadowColor(UIColor.blue, for: .highlighted)
        
        print("MOVIE TITLE: \(movies[indexPath.row].originalTitle)")
        
        cell.movieName.text = movies[indexPath.row].originalTitle
        TMDBClient.getPoster { (poster, error) in
            if let poster = poster {
                DispatchQueue.main.async {
                    cell.moviePoster.image = poster
                }
            } else {
                print("No poster found")
            }
        }
        cell.movieDescription.text = movies[indexPath.row].overview
        
        return cell
    }
    
}
