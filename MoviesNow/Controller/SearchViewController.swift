//
//  SearchViewController.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 2/26/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation
import UIKit

class  SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [Movie]()
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
    }
    
    func setUpNavBar() {
        navigationController?.navigationBar.topItem?.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        TMDBClient.search(query: searchText, completionHandler: { (movies, error) in
            self.movies = movies
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
        let movie = movies[indexPath.row]
        cell.textLabel?.text = "\(movie.title) - \(movie.releaseYear)"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // navigating to detail view
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        detailController.movieName = movies[indexPath.row].originalTitle
        detailController.movieSynopsis = movies[indexPath.row].overview
        detailController.backdropPath = movies[indexPath.row].backdropPath
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    
}
