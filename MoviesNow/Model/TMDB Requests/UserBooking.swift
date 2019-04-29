//
//  UserBooking.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 4/29/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation

struct UserBooking: Codable {
    let userID: String
    let movie: MovieDetails
}

struct MovieDetails: Codable {
    let movieID: String
    let seatNumbers: [String]
}
