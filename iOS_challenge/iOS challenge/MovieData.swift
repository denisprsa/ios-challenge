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
    let runtime: String?
    let voteAverage: Double?
    let voteCount: Int?
    let overview: String?
    let realeseDate: String?
    let revenue: Double?
    let generes: [Genres]?
    let cast: [Cast]?
    let storyLine: String?
    let video: String?
}

struct Cast {
    let name: String?
    let picture: String?
    let roleName: String?
}

struct Genres {
    let id: Int?
    let name: String?
}
