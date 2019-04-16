//
//  MarkWatchlist.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 4/15/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation

import Foundation

struct MarkWatchlist: Codable {
    let mediaType: String
    let mediaId: Int
    let watchlist: Bool
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaId = "media_id"
        case watchlist = "watchlist"
    }
    
}


