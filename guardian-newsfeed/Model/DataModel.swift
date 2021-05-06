//
//  DataModel.swift
//  guardian-newsfeed
//
//  Created by Nouman on 04/05/2021.
//

import Foundation

struct NewsfeedResponse: Codable {
    let response: Response?
    let message: String?
}
struct Response: Codable {
    let status : String
    let pageSize, currentPage, pages: Int
    let results: [Result]
}
struct Result: Codable, Identifiable, Equatable {
    let id, sectionName, pillarName: String
    let fields: Fields
}
struct Fields: Codable, Equatable {
    let trailText, bodyText, headline, thumbnail: String
}

