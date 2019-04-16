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
    
    
    var movies = [Movie]()
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        TMDBClient.getMoviesNowPlaying { (movies, error) in
            self.movies = movies
            self.collectionView.reloadData()
        }
        
        MovieSingleton.shared.setMovies()
        
        setUpNavBar()
    }
    
    func setUpNavBar() {
        navigationController?.navigationBar.topItem?.title = "Now Playing"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.view.backgroundColor = UIColor.white
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
        
        cell.movieName.text = movies[indexPath.row].originalTitle
        TMDBClient.getPoster(poster: movies[indexPath.row].backdropPath!) { (poster, error) in
            if let poster = poster {
                DispatchQueue.main.async {
                    cell.moviePoster.image = poster
                }
            }
        }
        cell.movieDescription.text = movies[indexPath.row].overview
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // navigating to detail view
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        detailController.movieName = movies[indexPath.row].originalTitle
        detailController.movieID = movies[indexPath.row].id
        detailController.movieSynopsis = movies[indexPath.row].overview
        detailController.backdropPath = movies[indexPath.row].backdropPath
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
}
