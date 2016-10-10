//
//  MovieData.swift
//  iOS challenge
//
//  Created by Denis Prša on 8. 10. 16.
//  Copyright © 2016 Denis Prša. All rights reserved.
//

import Foundation

struct MovieData {
    let title: String?
    let runtime: Int?
    let voteAverage: Double?
    let voteCount: Int?
    let overview: String?
    let realeseDate: NSDate?
    let revenue: Double?
    var generes: [Genres]?
    var cast: [Actor]?
    let tagline: String?
    let poster: String?
    let url: String?
}

struct Actor {
    let name: String?
    let picture: String?
    let roleName: String?
}

struct Genres {
    let id: Int?
    let name: String?
}

struct GuestSession {
    let success: Bool?
    var guestSessionID: String?
    var expiresAT: Date?
}
struct MovieVideo {
    let id: String?
    let key: String?
    let type: String?
    let site: String?
}
