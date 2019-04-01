//
//  MovieSingleton.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 2/28/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation

class MovieSingleton {
    static let shared = MovieSingleton()
    
    var movies = [Movie]()
    
    private init() {}
    
    func getMovies() -> [Movie] {
        return movies
    }
    
    func setMovies() {
        TMDBClient.getMoviesNowPlaying { (moviesNowPlaying, error) in
           self.movies = moviesNowPlaying
        }
    }
}


