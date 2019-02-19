//
//  RequestTokenResponse.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 2/5/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation

struct RequestTokenResponse: Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
