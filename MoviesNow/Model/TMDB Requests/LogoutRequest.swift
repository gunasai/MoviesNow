//
//  LogoutRequest.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 2/7/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation

struct LogoutRequest: Codable {
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
    }
}

