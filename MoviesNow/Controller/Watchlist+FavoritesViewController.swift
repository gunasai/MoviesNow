//
//  Watchlist+FavoritesViewController.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 4/22/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import UIKit

class WatchlistFavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let items = ["Watchlist", "Favorites"]
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Watchlist", "Favorites"])
        sc.selectedSegmentIndex = 0
        sc.tintColor = #colorLiteral(red: 1, green: 0.4190880954, blue: 0.3932890296, alpha: 1)
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return sc
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc fileprivate func handleSegmentChange() {
        print(segmentedControl.selectedSegmentIndex)
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            rowsToDisplay = watchlistMovies
        case 1:
            rowsToDisplay = favoriteMovies
        default:
            rowsToDisplay = watchlistMovies
        }
        
        tableView.reloadData()
    }
    
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    var watchlistMovies = [Movie]()
    var favoriteMovies = [Movie]()
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = rowsToDisplay[indexPath.row].originalTitle
        return cell
    }
    
    // Master Array
    lazy var rowsToDisplay = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let paddedStackView = UIStackView(arrangedSubviews: [segmentedControl])
        paddedStackView.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 12)
        paddedStackView.isLayoutMarginsRelativeArrangement = true
        
        let stackView = UIStackView(arrangedSubviews: [
            paddedStackView, tableView
            ])
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        
        setUpNavBar()
        
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .zero)
        
        _ = TMDBClient.getWatchlist() { movies, error in
            self.watchlistMovies = movies
            self.rowsToDisplay = self.watchlistMovies
            self.tableView.reloadData()
        }
        
        TMDBClient.getFavorites() { movies, error in
            self.favoriteMovies = movies
            self.tableView.reloadData()
        }
        
        for movie in watchlistMovies {
            MovieModel.watchlist.append(movie.id)
        }
        
        for movie in favoriteMovies {
            MovieModel.favorites.append(movie.id)
        }
        
        
    }
    
    
    func setUpNavBar() {
        navigationController?.navigationBar.topItem?.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.view.backgroundColor = UIColor.white
    }
    

}
