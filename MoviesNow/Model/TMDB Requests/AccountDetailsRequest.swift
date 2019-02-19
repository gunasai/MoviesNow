//
//  AccountDetailsRequest.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 2/7/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation

struct AccountDetailsRequest: Codable {
    let avatar: Avatar
    let id: Int
    let languageCode, countryCode, name: String
    let includeAdultItems: Bool
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case avatar, id
        case languageCode = "iso_639_1"
        case countryCode = "iso_3166_1"
        case name
        case includeAdultItems = "include_adult"
        case username
    }
}

struct Avatar: Codable {
    let gravatar: Gravatar
}

struct Gravatar: Codable {
    let hash: String
}

