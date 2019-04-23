//
//  MarkFavorite.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 4/16/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation

struct MarkFavorite: Codable {
    let mediaType: String
    let mediaId: Int
    let favorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaId = "media_id"
        case favorite = "favorite"
    }
    
}
