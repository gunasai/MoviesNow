//
//  TMDBResponse.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 4/7/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation

struct TMDBResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension TMDBResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
