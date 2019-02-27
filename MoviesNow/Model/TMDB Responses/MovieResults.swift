//
//  MovieResults.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 2/26/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation

struct MovieResults: Codable {
    
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
}

